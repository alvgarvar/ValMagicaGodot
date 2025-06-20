extends Node2D
class_name Actor

@onready var health_bar = $HealthBar

# Estados posibles del actor
enum State { WAITING, CHOOSING, ACTING, DEAD }
var state: State = State.WAITING

# Atributos básicos
var name_actor: String = "Actor"
var is_player: bool = false
var base_speed: int = 10
var speed_modifier: int = 0

const MAX_HEALTH: int = 100
var health: int = MAX_HEALTH
var is_alive: bool = true

# Acción actual (puede redefinirse por clase hija)
var current_action: Callable = func(): pass

func _ready():
	update_health_bar()

# Devuelve la velocidad total del actor
func get_speed() -> int:
	return base_speed + speed_modifier

# Acción del turno
func act():
	if state == State.DEAD:
		return

	if is_player:
		state = State.CHOOSING
		print(name_actor + " espera input del jugador.")
		# El jugador debe seleccionar una acción, y luego llamar a end_turn()
	else:
		state = State.ACTING
		print(name_actor + " realiza su acción automáticamente.")
		current_action.call()
		end_turn()

# Daño y muerte
func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0
	update_health_bar()
	if health <= 0:
		die()

func die():
	is_alive = false
	state = State.DEAD
	print(name_actor + " ha muerto.")
	queue_free()

# Actualiza la barra de vida visual
func update_health_bar():
	if health_bar:
		health_bar.value = health
		health_bar.max_value = MAX_HEALTH

# Finaliza el turno y lo notifica al controlador
func end_turn():
	state = State.WAITING
	get_parent().emit_signal("turn_ended", self)
