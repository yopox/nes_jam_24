@icon("res://assets/icons/node_2D/icon_character.png")
class_name Hero extends Node2D

@onready var stats: StatsNode = $Stats
@onready var sprite: Sprite2D = $Sprite2D

var fighter: Fighter: set = _set_fighter

signal action_changed(fighter: int, action: Actions.Type, target: int)


func _set_fighter(f: Fighter) -> void:
	fighter = f
	fighter.stats.stats_changed.connect(stats.stats_changed)
	stats.reset(fighter)
	# TODO: Update sprite


func end_of_turn() -> void:
	fighter.end_of_turn()
	
	var t: Fighter = fighter
	if fighter.target != -1: t = Team.fight.get_fighter_by_id(fighter.target)
	
	if not t.is_alive():
		if t in Team.fight.heroes:
			fighter.target = Team.fight.get_first_alive_ally().id
			action_changed.emit(fighter.id, fighter.intent, fighter.target)
		else:
			fighter.target = Team.fight.get_first_alive_enemy().id
			action_changed.emit(fighter.id, fighter.intent, fighter.target)


func update_gui():
	action_changed.emit(fighter.id, fighter.intent, fighter.target)


func cycle_action():
	match fighter.intent:
		Actions.Type.Atk:
			fighter.intent = Actions.Type.Def
			fighter.target = fighter.id
		Actions.Type.Spl:
			fighter.intent = Actions.Type.Def
			#fighter.target = fighter.id
		Actions.Type.Def:
			fighter.intent = Actions.Type.Atk
			fighter.target = Team.fight.get_first_alive_enemy().id
	update_gui()


func cycle_target():
	fighter.target = Team.fight.get_next_target(fighter.target)
	while not Team.fight.get_fighter_by_id(fighter.target).is_alive():
		fighter.target = Team.fight.get_next_target(fighter.target)
	update_gui()
