class_name StatusNode extends Node

@onready var letter_label: Label = $Letter
@onready var value_label: Label = $Value
@onready var icon: TextureRect = $Icon

var status: Status


func update() -> void:
	letter_label.visible = true
	value_label.visible = true
	icon.visible = false
	value_label.text = str(status.value)
	match status.type:
		Status.Type.Defense:
			letter_label.visible = false
			icon.visible = true
		Status.Type.Poison:
			letter_label.text = "P"
			letter_label.self_modulate = Util.ACID_GREEN
		Status.Type.Angel:
			letter_label.text = "A"
			letter_label.self_modulate = Util.YELLOW
		Status.Type.Demon:
			letter_label.text = "D"
			letter_label.self_modulate = Util.DARK_RED
		Status.Type.KO:
			letter_label.text = "K.O."
			letter_label.self_modulate = Util.WHITE
			value_label.visible = false
