class_name Fight extends Node2D

@onready var status: Label = $Status
@onready var slots: Slots = $slots

@onready var action_p1: Action = $Heroes/Action
@onready var action_p2: Action = $Heroes/Action2

@onready var arrow: Sprite2D = $ActionBox/Arrow

var reset := false


func _ready():
	set_status(slots.selected_rune().description())


func _process(delta):
	if Input.is_action_just_pressed("select"):
		reset = !reset
		if reset:
			arrow.position.y = 75
		else:
			arrow.position.y = 85
	if Input.is_action_just_pressed("start"):
		if reset:
			print("Reset")
		else:
			print("Fight")


func set_status(text: String) -> void:
	if not is_node_ready():
		return
	status.text = text


func update_state(state: Slots.State) -> void:
	if not is_node_ready():
		return
	action_p1.set_state(state)
	action_p2.set_state(state)
