extends Node2D

class_name Actor

@onready var sprite = $Sprite2D

@onready var health_bar = $Bars/HealthBar
@onready var mana_bar = $Bars/ManaBar

# Estados posibles del actor
enum State { WAITING, CHOOSING, ACTING, DEAD }
var state: State = State.WAITING
var flash_tween = null

# Atributos básicos
var name_actor: String = "Unnamed"
var level: int = 1

var base_hp: int = 100
var current_hp: int = base_hp

var base_mana: int = 10
var current_mana: int = base_mana

var base_attack: int = 10
var attack_modifier: int = 0
var base_defense: int = 10
var defense_modifier: int = 0
var base_speed: int = 10
var speed_modifier: int = 0

var is_player: bool = false
var is_alive: bool = true

# Habilidades y estatus
var abilities: Array = [] # Habilidades activas
var passive_abilities: Array = [] # Habilidades pasivas
var status_effects: Array = [] # Buffs/Debuffs temporales

# Acción actual (puede redefinirse por clase hija)
var current_action: Callable = func(): pass

func _ready():
	initializeHealthBar()
	initializeManaBar()

# Métodos comunes
func get_attack() -> int:
	return base_attack + attack_modifier

func get_defense() -> int:
	return base_defense + defense_modifier

func get_speed() -> int:
	return base_speed + speed_modifier

func take_damage(amount: int) -> void:
	var damage_taken = max(0, amount - get_defense())
	current_hp = max(0, current_hp - damage_taken)
	print("%s recibió %d de daño. HP restante: %d" % [name_actor, damage_taken, current_hp])

	update_health_bar()
	die()

func die() -> bool:
	var checkHp = current_hp > 0
	if (checkHp):
		return false
	else:
		is_alive = false
		state = State.DEAD
		print(name_actor + " ha muerto.")
		return true

# Actualiza la barra de vida visual
func update_health_bar():
	if health_bar:
		health_bar.value = current_hp
		
func initializeHealthBar():
	if health_bar:
		health_bar.value = current_hp
		health_bar.max_value = base_hp

# Actualiza la barra de mana visual
func update_mana_bar():
	if mana_bar:
		mana_bar.value = current_mana
		
func initializeManaBar():
	if mana_bar:
		mana_bar.value = current_mana
		mana_bar.max_value = base_mana

# Finaliza el turno y lo notifica al controlador
func end_turn():
	state = State.WAITING
	get_tree().current_scene.emit_signal("turn_ended", self)

func start_flash():
	stop_flash()

	flash_tween = get_tree().create_tween()
	flash_tween.set_loops()

	flash_tween.tween_property(sprite, "modulate:a", 0.3, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	flash_tween.tween_property(sprite, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_flash():
	if flash_tween:
		flash_tween.kill()
		flash_tween = null
	sprite.modulate.a = 1.0