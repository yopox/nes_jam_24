@icon("res://assets/icons/control/icon_shield.png")
class_name StatusNode extends Node

@onready var letter_label: Label = $Letter
@onready var value_label: Label = $Value
@onready var icon: TextureRect = $Icon

var status: Status


func update() -> void:
	value_label.text = str(status.value)
	match status.type:
		Status.Type.Defense:
			show_icon()
		Status.Type.Poison:
			show_letter()
			letter_label.text = "P"
			letter_label.self_modulate = Util.ACID_GREEN
		Status.Type.Angel:
			show_letter()
			letter_label.text = "A"
			letter_label.self_modulate = Util.YELLOW
		Status.Type.Demon:
			show_letter()
			letter_label.text = "D"
			letter_label.self_modulate = Util.DARK_RED
		Status.Type.KO:
			show_text()
			letter_label.text = "K.O."
			letter_label.self_modulate = Util.WHITE


func show_letter():
	letter_label.visible = true
	value_label.visible = true
	icon.visible = false


func show_icon():
	letter_label.visible = false
	value_label.visible = true
	icon.visible = true


func show_text():
	letter_label.visible = true
	value_label.visible = false
	icon.visible = false
