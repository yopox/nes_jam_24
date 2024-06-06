class_name Action extends Node2D

@export var p1 := true

@onready var label: Label = $Label
@onready var label2: Label = $Label2


func set_state(state: Slots.State) -> void:
	label.modulate = Color.WHITE
	label2.modulate = Color.WHITE
	
	if state == Slots.State.P1Action and p1:
		label.modulate = Color("#56cfde")
	elif state == Slots.State.P2Action and not p1:
		label.modulate = Color("#56cfde")
	elif state == Slots.State.P1Target and p1:
		label2.modulate = Color("#56cfde")
	elif state == Slots.State.P2Target and not p1:
		label2.modulate = Color("#56cfde")
