@icon("res://assets/icons/node_2D/icon_coin.png")
extends Node2D

@onready var count = $Count


func _ready():
	Progress.gold_changed.connect(update)
	update()


func update():
	count.text = str(Progress.gold)
