@icon("res://assets/icons/control/icon_lever.png")
class_name ActionBox extends Control

@export var option_1: String = "OPT 1"
@export var option_2: String = "OPT 2"
@export var first = true: set = _set_first

@onready var opt_1: Label = $Opt1
@onready var opt_2: Label = $Opt2
@onready var arrow: Sprite2D = $Arrow

signal selected(first: bool)


func _ready():
	opt_1.text = option_1
	opt_2.text = option_2
	arrow.position.y = 11 if first else 21


func _process(delta):
	if Input.is_action_just_pressed("select"):
		select()
	elif Input.is_action_just_pressed("start"):
		selected.emit(first)


func _set_first(value):
	first = value
	if arrow != null and arrow.is_node_ready(): arrow.position.y = 11 if first else 21
	

func select():
	first = !first


func first_selected() -> bool:
	return first
