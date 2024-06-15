class_name Fighter extends Node

enum Type { Fighter, Knight,  }

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

var status: Array[Status] = []


func _ready():
	stats_node.character_name = name
	stats_node.update_status(self)


func reset():
	id = Util.get_unique_id()
	HP = MAX_HP
	status.clear()
	stats_node.stats_changed(self)
	stats_node.update_status(self)


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


func action() -> Actions.Action:
	var act = Actions.Action.new()
	act.fighter = self
	act.type = intent
	act.target = target
	return act


func draft_enemy_runes():
	var draft = Util.distinct(len(enemy_rune_nodes), 0, len(runes) - 1)
	draft.sort()
	draft.reverse()
	for i in range(len(enemy_rune_nodes)):
		enemy_rune_nodes[i].type = runes[draft[i]]
		enemy_rune_nodes[i].update_sprite()


func damage(amount: int) -> void:
	if not is_alive():
		printerr("Dead fighters shouldn't be targeted")
		return

	var final_amount = amount
	for s in status:
		if s.type == Status.Type.Defense:
			# total block
			if s.value >= final_amount:
				s.value -= final_amount
				final_amount = 0
			# partial block
			if s.value < final_amount:
				final_amount -= s.value
				s.value = 0
	HP -= final_amount
	stats_node.stats_changed(self)
	stats_node.update_status(self)
	await Team.message(Text.damage(self, final_amount))
	
	if HP <= 0:
		HP = 0
		status.clear()
		status.append(Actions.create_status(Status.Type.KO, 1))
		stats_node.stats_changed(self)
		stats_node.update_status(self)
		await Team.message(Text.ko(self))


func heal(percent: int) -> void:
	HP += percent / 100.0 * MAX_HP
	HP = min(HP, MAX_HP)
	stats_node.stats_changed(self)


func defend(amount: int) -> void:
	var existing = false
	var initial_def = 0
	var final_def = amount
	for s in status:
		if s.type == Status.Type.Defense:
			initial_def = s.value
			s.value += amount
			s.value = min(s.value, Values.MAX_DEF)
			final_def = s.value
			existing = true
	if not existing:
		status.append(Actions.create_status(Status.Type.Defense, amount))
	
	stats_node.update_status(self)
	await Team.message(Text.defend(self, initial_def, final_def))


func end_of_turn():
	var expired = []
	for i in range(len(status)):
		var s = status[i]
		if s.type == Status.Type.Defense:
			s.value = 0
		if s.is_expired():
			expired.append(i)
	expired.reverse()
	for i in expired:
		status.remove_at(i)
	stats_node.update_status(self)


func add_mark(type: Status.Type, amount: int) -> void:
	for s in status:
		if s.type == type:
			s.value += amount
			s.value = min(s.value, Values.MAX_MARKS)
			stats_node.update_status(self)
			return
	status.append(Actions.create_status(type, amount))
	stats_node.update_status(self)
	

func get_status_value(type: Status.Type) -> int:
	for s in status:
		if s.type == type:
			return s.value
	return 0


func remove_status(type: Status.Type) -> void:
	var to_remove = -1
	for i in range(len(status)):
		if status[i].type == type:
			to_remove = i
			break
	if to_remove != -1:
		status.remove_at(to_remove)
	stats_node.update_status(self)
