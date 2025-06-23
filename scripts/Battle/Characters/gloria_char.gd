extends Player

class_name Gloria

# Estadísticas base (pueden ajustarse luego con equipamiento, buffs, etc.)
func _init():
	name_actor = "Gloria"
	base_hp = 100
	base_attack = 20
	base_defense = 40
	base_speed = 10
	base_mana = 30
	
	current_hp = base_hp
	current_mana = base_mana

# Aquí podrías añadir métodos como atacar, recibir daño, etc.
