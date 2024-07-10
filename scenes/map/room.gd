class_name Room extends Node2D

@onready var border: Border = $Border

var right_door = true
var bottom_door = true

var visited = false
var open = false

enum Type { Fight, Boss, }
var type_hidden := true


func update():
	border.update(border_state())


func border_state() -> Border.State:
	if visited: return Border.State.White
	if open: return Border.State.Gray
	return Border.State.Dark
