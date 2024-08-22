extends Node

var hero1: Fighter
var hero2: Fighter

var gold: int = 0
var map: Map = Map.new()

signal gold_changed()


func _init():
	hero1 = Fighter.new()
	hero1.name = "Arches"
	hero2 = Fighter.new()
	hero2.name = "Ixous"
