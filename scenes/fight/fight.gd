class_name Fight extends Node2D

@onready var status: Label = $Status
@onready var slots: Slots = $slots


func _ready():
	set_status(slots.selected_rune().description())


func set_status(text: String) -> void:
	if not is_node_ready():
		return
	status.text = text
