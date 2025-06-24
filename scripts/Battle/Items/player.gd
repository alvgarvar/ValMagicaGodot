extends Actor
class_name Player

@onready var menu_ui = get_tree().current_scene.get_node("UI/ActionMenu")
@onready var atacar_button = menu_ui.get_node("AttackButton")
@onready var defend_button = menu_ui.get_node("DefendButton")

func act():
	if state == State.DEAD:
		return

	state = State.CHOOSING
	print(name_actor + " espera input del jugador.")

	# Mostrar menú
	menu_ui.visible = true

	# Conectar botones (desconectando si ya están conectados)
	if atacar_button.is_connected("pressed", Callable(self, "_on_atacar_pressed")) == false:
		atacar_button.pressed.connect(_on_atacar_pressed)
	if defend_button.is_connected("pressed", Callable(self, "_on_defend_pressed")) == false:
		defend_button.pressed.connect(_on_defend_pressed)

func _on_atacar_pressed():
	print(name_actor + " elige Atacar")

	close_menu()

	var valid_targets: Array[Actor] = []
	for node in get_node("/root/Battle").enemies:
		if node is Actor and node.is_alive:
			valid_targets.append(node as Actor)

	if valid_targets.size() > 0:
		var selector = get_node("/root/Battle/TargetSelector")
		selector.start_selection(valid_targets)

		var target = await selector.target_selected
		print(name_actor + " ataca a " + target.name_actor)
		target.take_damage(get_attack())
	else:
		print(name_actor + " no encuentra objetivo.")
	end_action()

func _on_defend_pressed():
	print(name_actor + " defiende en su turno")
	close_menu()
	end_action()

func close_menu():
	menu_ui.visible = false

func end_action():
	#TODO: Esto vamos a dejarlo asi por si acaso tenemos que eliminar contadores, pasos de turnos, limpieza de efectos y demas.
	end_turn()

func _on_target_selected(target: Enemy):
	print(name_actor + " ataca a " + target.name_actor)
	target.take_damage(get_attack())
	close_menu()