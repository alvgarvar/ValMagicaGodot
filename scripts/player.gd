extends Actor
class_name Player

@onready var menu_ui = get_tree().current_scene.get_node("UI/ActionMenu")
@onready var atacar_button = menu_ui.get_node("AtacarButton")
@onready var pasar_button = menu_ui.get_node("PasarButton")

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
	if pasar_button.is_connected("pressed", Callable(self, "_on_pasar_pressed")) == false:
		pasar_button.pressed.connect(_on_pasar_pressed)

func _on_atacar_pressed():
	print(name_actor + " elige Atacar")

	var enemies = get_tree().current_scene.get_node("Enemies").get_children()
	var target = enemies[0]
	print(name_actor + " ataca a " + target.name_actor)
	target.take_damage(25)

	close_menu()

func _on_pasar_pressed():
	print(name_actor + " pasa su turno")
	close_menu()

func close_menu():
	menu_ui.visible = false
	end_turn()
