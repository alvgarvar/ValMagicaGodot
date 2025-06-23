extends Player
class_name Heidi

# Estadísticas base (pueden ajustarse luego con equipamiento, buffs, etc.)
func _init():
	name_actor = "Heidi"
	base_hp = 140
	base_attack = 25
	base_defense = 35
	base_speed = 12
	base_mana = 20
	
	current_hp = base_hp
	current_mana = base_mana
# Aquí podrías añadir métodos como atacar, recibir daño, etc.

