extends Player
class_name Elizabeth

# Estadísticas base (pueden ajustarse luego con equipamiento, buffs, etc.)
func _init():
	name_actor = "Elizabeth"
	base_hp = 100
	base_attack = 20
	base_defense = 20
	base_speed = 20
	base_mana = 40

	current_hp = base_hp
	current_mana = base_mana
# Aquí podrías añadir métodos como atacar, recibir daño, etc.
