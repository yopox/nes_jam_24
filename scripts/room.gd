class_name Room extends Node

enum Type { None, Fight, Boss, Shop, Inn, Event }

var x: int = 0
var y: int = 0

var type: Room.Type = Room.Type.None

var right_door = true
var bottom_door = true

var visited = false
var open = false


func randomize() -> void:
	type = Type.values().pick_random()


func open_room() -> bool:
	open = true
	if type == Type.None:
		visited = true
	return true
