class_name Stats extends Node2D

@export var character_name: String:
	set(value):
		character_name = value
		if is_node_ready():
			name_label.text = character_name

@onready var name_label: Label = $Name
@onready var hp_bar = $HPBar


func _ready():
	character_name = character_name
