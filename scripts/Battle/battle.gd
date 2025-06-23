extends Node2D

signal turn_ended(actor)

# Obtiene todos los jugadores y enemigos
@onready var ally_container = $AlliesContainer
@onready var enemy_container = $EnemiesContainer

# Todos los actores vivos
var allies: Array[Player] = []
var enemies: Array[Enemy] = []
var actors: Array = []
var turn_queue: Array = []
var current_actor: Actor = null

#Nombres de personajes
var ally_names = CharacterRegistry.party
var enemy_names = CharacterRegistry.group_enemies

func _ready():
	# Cargar escenas

	spawn_actors(ally_names, "player")
	spawn_actors(enemy_names, "enemy")

	connect("turn_ended", Callable(self, "_on_turn_ended"))

	# Castear a Player y Enemy explícitamente
	for node in ally_container.get_children():
		if node is Player:
			allies.append(node)
	for node in enemy_container.get_children():
		if node is Enemy:
			enemies.append(node)

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

#Apariciones de enemigos y aliados
func spawn_actors(names: Array[String], type: String) -> void:
	var total_type_counts := count_type_occurrences(names)
	var current_instance_count := {}

	for i in names.size():
		var base_name = names[i]
		var name_actor = base_name

		if type == "enemy":
			if not current_instance_count.has(base_name):
				current_instance_count[base_name] = 1
			else:
				current_instance_count[base_name] += 1
			
			var instance_number = current_instance_count[base_name]

			# Solo añadir número si hay más de uno de ese tipo
			if total_type_counts[base_name] > 1:
				name_actor += " " + str(instance_number)

		var scene_path = CharacterRegistry.get_path_scene(base_name, type)
		
		if ResourceLoader.exists(scene_path):
			var actor_scene = load(scene_path)
			var actor = actor_scene.instantiate()

			var slot_node: Node2D
			
			if type == "player":
				slot_node = ally_container.get_node("AllySlot" + str(i + 1))
				ally_container.add_child(actor)
				actor.global_position = slot_node.global_position
			else:
				slot_node = enemy_container.get_node("EnemySlot" + str(i + 1))
				enemy_container.add_child(actor)
				actor.global_position = slot_node.global_position
				actor.name_actor = name_actor
		else:
			push_error("No se encontró la escena para: " + name_actor)

func count_type_occurrences(name_ene_all: Array[String]) -> Dictionary:
	var counts := {}
	for name_ene in name_ene_all:
		if counts.has(name_ene):
			counts[name_ene] += 1
		else:
			counts[name_ene] = 1
	return counts