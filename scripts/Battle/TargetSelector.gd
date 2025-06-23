extends Node

var targets: Array= []
var current_index: int = 0
var selecting: bool = false
signal target_selected(target: Actor)

func start_selection(valid_targets: Array):
	targets = valid_targets
	current_index = 0
	selecting = true
	highlight_target()

func _unhandled_input(event):
	if not selecting:
		return

	if event.is_action_pressed("ui_left"):
		current_index = (current_index - 1 + targets.size()) % targets.size()
		highlight_target()
	elif event.is_action_pressed("ui_right"):
		current_index = (current_index + 1) % targets.size()
		highlight_target()
	elif event.is_action_pressed("ui_accept"):
		confirm_selection()

func highlight_target():
	for i in targets.size():
		targets[i].stop_flash()
	targets[current_index].start_flash()

func confirm_selection():
	selecting = false
	for t in targets:
		t.stop_flash()
	emit_signal("target_selected", targets[current_index])
