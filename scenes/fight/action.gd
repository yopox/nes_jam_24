class_name Action extends Node2D

@export var fight: Fight
@export var p1 := true

@onready var label: Label = $Label
@onready var label2: Label = $Label2


func set_state(state: Slots.State) -> void:
	label.modulate = Color.WHITE
	label2.modulate = Color.WHITE
	
	if state == Slots.State.P1Action and p1:
		label.modulate = Util.BLUE
	elif state == Slots.State.P2Action and not p1:
		label.modulate = Util.BLUE
	elif state == Slots.State.P1Target and p1:
		label2.modulate = Util.BLUE
	elif state == Slots.State.P2Target and not p1:
		label2.modulate = Util.BLUE


func _on_hero_action_changed(fighter: int, action: Fighter.Actions, target: int):
	match action:
		Fighter.Actions.Atk:
			label.text = "ATK"
		Fighter.Actions.Spl:
			label.text = "SPL"
		Fighter.Actions.Def:
			label.text = "DEF"
	
	if target == fighter or target == -1:
		label2.text = "Self"
	else:
		label2.text = fight.get_fighter_by_id(target).name
