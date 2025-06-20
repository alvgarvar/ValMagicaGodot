extends Node2D
class_name Actor

@onready var health_bar = $HealthBar;
var health: int = max_health;

var name_actor: String;
const max_health: int = 100;
var is_player: bool = false;

func act():
	print(name + " actúa.")

func _ready():
	update_health_bar()

func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0
	update_health_bar()

	if health <= 0:
		die()

func update_health_bar():
	health_bar.value = health
	health_bar.max_value = max_health

func die():
	print(name + " ha muerto.")
	queue_free() # O puedes disparar evento de derrota
