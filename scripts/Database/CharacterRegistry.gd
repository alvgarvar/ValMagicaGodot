extends Node

# Diccionarios de personajes
var party: Array[String] = [
    "Gloria"
]

var group_enemies: Array[String] = [
    "Miedillo",
	"Miedillo"
]

var players := {
	"Gloria": {
		"path": "res://scenes/Battle/Characters/gloria_scene.tscn",
		"nivel_base": 1
	},
	"Clara": {
		"path": "res://scenes/Battle/Characters/clara_scene.tscn",
		"nivel_base": 1
	},
	"XiangYu": {
		"path": "res://scenes/Battle/Characters/xiangyu_scene.tscn",
		"nivel_base": 1
	},
	"Heidi": {
		"path": "res://scenes/Battle/Characters/heidi_scene.tscn",
		"nivel_base": 1
	},
	"Elizabeth": {
		"path": "res://scenes/Battle/Characters/elizabeth.tscn",
		"nivel_base": 1
	}
}

var enemies := {
	"Miedillo": "res://scenes/Battle/Enemies/miedillo_scene.tscn",
}

func get_path_scene(name_char: String, type_char: String) -> String:
	if type_char == "player" and players.has(name_char):
		return players[name_char].path
	elif type_char == "enemy" and enemies.has(name_char):
		return enemies[name_char]
	else:
		push_error("No se encontró el personaje '%s' del tipo '%s'" % [name_char, type_char])
		return ""
