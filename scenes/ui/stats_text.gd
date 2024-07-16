class_name StatsText extends Node2D

@export var fighter: Fighter

@onready var name_label: Label = $Name
@onready var count: Label = $Count


func set_fighter(f: Fighter):
	fighter = f
	update()


func update():
	name_label.text = fighter.name
	count.text = "%s/%s" % [fighter.HP, fighter.MAX_HP]
