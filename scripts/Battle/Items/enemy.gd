extends Actor
class_name Enemy

func act():
	if state == State.DEAD:
		return

	state = State.ACTING
	print(name_actor + " está eligiendo un objetivo...")

	# Buscar aliados vivos para atacar (los jugadores están en Allies)
	var allies = get_node("/root/Battle/AlliesContainer").get_children()
	var valid_targets = allies.filter(func(a):
		return a is Player and a.is_alive
	)

	if valid_targets.size() > 0:
		var target = valid_targets[randi() % valid_targets.size()]
		print(name_actor + " ataca a " + target.name_actor)
		target.take_damage(15)
	else:
		print(name_actor + " no encuentra objetivo.")

	end_turn()
