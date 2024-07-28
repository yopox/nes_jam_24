class_name Manager extends Node2D

@onready var current = $Current

var map = preload("res://scenes/map/map_scene.tscn")
var fight = preload("res://scenes/fight/fight.tscn")
var perks = preload("res://scenes/perks/perks.tscn")

enum Scenes { Map, Fight, Perks }


func _ready():
	Progress.map.gen()
	change_scene(Scenes.Map)


func change_scene(scene: Scenes):
	var scene_node: Node
	match scene:
		Scenes.Map: scene_node = map.instantiate()
		Scenes.Fight: scene_node = fight.instantiate()
		Scenes.Perks: scene_node = perks.instantiate()
	
	for c in current.get_children():
		c.queue_free()
	
	current.add_child(scene_node)
