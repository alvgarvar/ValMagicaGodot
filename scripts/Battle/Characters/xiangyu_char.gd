extends Player

class_name XiangYu

# Estadísticas base (pueden ajustarse luego con equipamiento, buffs, etc.)
func _init():
	name_actor = "Xiang Yu"
	base_hp = 90
	base_attack = 30
	base_defense = 15
	base_speed = 25
	base_mana = 60

	current_hp = base_hp
	current_mana = base_mana
# Aquí podrías añadir métodos como atacar, recibir daño, etc.