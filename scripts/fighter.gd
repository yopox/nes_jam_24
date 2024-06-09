class_name Fighter extends Node

enum Type { Fighter, Knight }

enum Stat { HP, ATK, DEF }
enum Actions { Atk, Spl, Def }

var weapon = null
var spell = null

@export var MAX_HP: int = 100
var HP: int = MAX_HP
@export var ATK: int = 10
@export var DEF: int = 5

@onready var stats_node: Stats = $Stats

var id = -1

signal action_changed(fighter: int, action: Fighter.Actions, target: int)
var intent = Actions.Atk
var target = -1


func _ready():
	stats_node.character_name = name


func is_alive():
	return HP > 0


func update_gui():
	action_changed.emit(id, intent, target)


func cycle_action():
	match intent:
		Actions.Atk:
			if spell != null:
				intent = Actions.Spl
			else:
				intent = Actions.Def
		Actions.Spl:
			intent = Actions.Def
		Actions.Def:
			intent = Actions.Atk
	update_gui()


func cycle_target():
	target = Team.fight.get_next_target(target)
	update_gui()
