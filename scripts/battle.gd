extends Node2D

@onready var player = $Player
@onready var enemy = $Enemy
@onready var turn_queue_display = $UI/TurnQueueDisplay

var turn_order = []
var current_actor: Node = null
var waiting_for_input := false

func _ready():
	# Inicializa el orden de turnos con instancias reales
	turn_order = [player, enemy, player, enemy]
	update_turn_display()
	process_turn()

func _process(delta):
	# Captura input si es turno del jugador
	if waiting_for_input and Input.is_action_just_pressed("attack"):
		var target = get_node_or_null("Enemy")
		if target:
			target.take_damage(25)
		waiting_for_input = false
		end_turn()

func process_turn():
	# Determina quién actúa en este turno
	current_actor = turn_order[0]

	if current_actor.is_player:
		waiting_for_input = true
		print("Turno del jugador")
	else:
		print("Turno del enemigo")
		await get_tree().create_timer(1.0).timeout
		enemy_take_action()

func enemy_take_action():
	var target = get_node_or_null("Player")
	if target:
		target.take_damage(15)
	end_turn()

func end_turn():
	# Rota el orden y continúa con el siguiente turno
	var first = turn_order.pop_front()
	turn_order.append(first)
	update_turn_display()
	process_turn()

func update_turn_display():
	# Actualiza la visualización de la lista de turnos
	for child in turn_queue_display.get_children():
		child.queue_free()

	for actor in turn_order:
		var label = Label.new()
		label.text = actor.name
		turn_queue_display.add_child(label)
