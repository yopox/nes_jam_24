class_name Fighter extends Node

enum Type { Fighter, Knight }

enum Stat { HP, ATK, DEF }

var weapon = null
var spell = null

@export var MAX_HP: int = 100
var HP: int = MAX_HP
@export var ATK: int = 10
@export var DEF: int = 5

@export var runes: Array[Rune.Type] = []
@export var enemy_rune_nodes: Array[Rune] = []

@onready var stats_node: Stats = $Stats

var id = -1

signal action_changed(fighter: int, action: Actions.Type, target: int)
var intent = Actions.Type.Atk
var target = -1


func _ready():
	stats_node.character_name = name
	if len(runes) > 0:
		draft_enemy_runes()


func is_alive():
	return HP > 0


func update_gui():
	action_changed.emit(id, intent, target)


func cycle_action():
	match intent:
		Actions.Type.Atk:
			if spell != null:
				intent = Actions.Type.Spl
			else:
				intent = Actions.Type.Def
				target = id
		Actions.Type.Spl:
			intent = Actions.Type.Def
			target = id
		Actions.Type.Def:
			intent = Actions.Type.Atk
			target = Team.fight.get_first_alive_enemy()
	update_gui()


func cycle_target():
	target = Team.fight.get_next_target(target)
	update_gui()


func draft_enemy_runes():
	var draft = Util.distinct(len(enemy_rune_nodes), 0, len(runes) - 1)
	draft.sort()
	draft.reverse()
	for i in range(len(enemy_rune_nodes)):
		enemy_rune_nodes[i].type = runes[draft[i]]
		enemy_rune_nodes[i].update_sprite()
