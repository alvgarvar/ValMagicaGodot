extends Enemy
class_name Miedillo

# Estadísticas base (pueden ajustarse luego con equipamiento, buffs, etc.)
func _init():
	name = "Miedillo"
	base_hp = 40
	base_attack = 10
	base_defense = 5
	base_speed = 10
	base_mana = 5

	current_hp = base_hp
	current_mana = base_mana
	
# Aquí podrías añadir métodos como atacar, recibir daño, etc.
