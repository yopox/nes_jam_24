@icon("res://assets/icons/node_2D/icon_text_panel.png")
class_name StatsNode extends Node2D

var character_name: String

@onready var name_label: Label = $Name
@onready var hp_bar: HPBar = $HPBar
@onready var status_list: BoxContainer = $StatusList

var status_scene: PackedScene = preload("res://scenes/fight/status_node.tscn")


func reset(fighter: Fighter) -> void:
	name_label.text = fighter.name
	stats_changed(fighter.stats)
	update_status(fighter)


func stats_changed(stats: Stats) -> void:
	hp_bar.update(stats.HP, stats.MAX_HP)


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
	
