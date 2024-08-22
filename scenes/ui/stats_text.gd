@icon("res://assets/icons/node_2D/icon_text_panel.png")
class_name StatsText extends Node2D

var fighter: Fighter

@onready var name_label: Label = $Name
@onready var count: Label = $Count


func set_fighter(f: Fighter):
	fighter = f
	update()


func update():
	name_label.text = fighter.name
	count.text = "%s/%s" % [fighter.stats.HP, fighter.stats.MAX_HP]
