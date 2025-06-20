extends Node2D

signal turn_ended(actor)

# Obtiene todos los jugadores y enemigos
@onready var allies_raw = $Allies.get_children()
@onready var enemies_raw = $Enemies.get_children()

# Todos los actores vivos
var allies: Array[Player] = []
var enemies: Array[Enemy] = []
var actors: Array[Actor] = []
var turn_queue: Array[Actor] = []
var current_actor: Actor = null

func _ready():
	connect("turn_ended", Callable(self, "_on_turn_ended"))

	# Castear a Player y Enemy explícitamente
	for node in allies_raw:
		allies.append(node as Player)
	for node in enemies_raw:
		enemies.append(node as Enemy)

	# Registrar todos los actores vivos
	actors = allies + enemies
	turn_queue = actors.duplicate()
	sort_turn_queue()

	start_next_turn()

func sort_turn_queue():
	# Ordena de mayor a menor velocidad
	turn_queue.sort_custom(func(a, b): return a.get_speed() > b.get_speed())

func start_next_turn():
	if check_battle_end():
		return

	if turn_queue.is_empty():
		# Repetir ciclo de turnos con actores vivos
		turn_queue = actors.filter(func(actor): return actor.is_alive).duplicate()
		sort_turn_queue()

	if turn_queue.is_empty():
		print("No quedan actores vivos. Fin del combate.")
		return

	current_actor = turn_queue.pop_front()

	if not current_actor.is_alive:
		start_next_turn()
		return

	print("Turno de: " + current_actor.name_actor)
	current_actor.act()

func _on_turn_ended(actor: Actor):
	await get_tree().create_timer(0.5).timeout
	start_next_turn()

func check_battle_end() -> bool:
	if enemies.all(func(e): return not e.is_alive):
		print("¡Victoria!")
		return true
	if allies.all(func(a): return not a.is_alive):
		print("Derrota...")
		return true
	return false
