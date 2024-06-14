class_name Stats extends Node2D

@export var character_name: String:
	set(value):
		character_name = value
		if is_node_ready():
			name_label.text = character_name

@onready var name_label: Label = $Name
@onready var hp_bar: HPBar = $HPBar
@onready var status_list: BoxContainer = $StatusList

var status_scene: PackedScene = preload("res://scenes/fight/status_node.tscn")


func _ready():
	character_name = character_name


func stats_changed(fighter: Fighter) -> void:
	hp_bar.update(fighter.HP, fighter.MAX_HP)


func update_status(fighter: Fighter) -> void:
	for i in range(len(fighter.status)):
		if status_list.get_child_count() <= i:
			var node: StatusNode = status_scene.instantiate()
			node.status = fighter.status[i]
			status_list.add_child(node)
			node.update()
		else:
			var node: StatusNode = status_list.get_child(i)
			node.status = fighter.status[i]
			node.update()
	
	for i in range(status_list.get_child_count()):
		if i >= len(fighter.status):
			status_list.get_child(i).queue_free()
	
