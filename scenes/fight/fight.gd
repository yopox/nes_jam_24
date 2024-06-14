class_name Fight extends Node2D

@onready var status: Label = $Status
@onready var slots: Slots = $slots

@onready var action_p1: ActionSelect = $Heroes/Action
@onready var action_p2: ActionSelect = $Heroes/Action2

@onready var arrow: Sprite2D = $ActionBox/Arrow

@export var heroes: Array[Fighter] = []
@onready var enemies: Container = $Enemies


var reset := false


func _enter_tree():
	Team.fight = self


func _ready():
	set_status(slots.selected_rune().description())
	for e in enemies.get_children():
		e.reset()
		e.draft_enemy_runes()
	for h in heroes:
		h.reset()
		h.intent = Actions.Type.Atk
		h.target = get_first_alive_enemy()
		h.update_gui()


func _process(_delta):
	if slots.state == Slots.State.Fight:
		return
	if Input.is_action_just_pressed("select"):
		reset = !reset
		if reset:
			arrow.position.y = 75
		else:
			arrow.position.y = 85
	if Input.is_action_just_pressed("start"):
		if reset:
			reset_runes()
		else:
			fight()


func set_status(text: String) -> void:
	if not is_node_ready():
		return
	status.text = text


func update_state(state: Slots.State) -> void:
	if not is_node_ready():
		return
	action_p1.set_state(state)
	action_p2.set_state(state)


func get_fighter_by_id(id: int) -> Fighter:
	for f in heroes:
		if f.id == id:
			return f
	for e in enemies.get_children():
		if e.id == id:
			return e
	printerr("Can't find fighter!")
	return null


func get_next_target(target: int) -> int:
	var last = null
	for f in heroes:
		if last != null and last.id == target:
			return f.id
		last = f
	for e in enemies.get_children():
		if last.id == target:
			return e.id
		last = e
	return heroes[0].id


func get_first_alive_enemy() -> int:
	for e in enemies.get_children():
		if e.is_alive():
			return e.id
	return -1


func a(state: Slots.State) -> void:
	match state:
		Slots.State.P1Action:
			heroes[0].cycle_action()
		Slots.State.P1Target:
			heroes[0].cycle_target()
		Slots.State.P2Action:
			heroes[1].cycle_action()
		Slots.State.P2Target:
			heroes[1].cycle_target()


func reset_runes():
	slots.reset_cursor()
	pass


func fight():
	slots.state = Slots.State.Fight
	var p1_action = heroes[0].action()
	for rune in slots.runes["p1"]:
		if not rune.empty:
			Actions.apply_rune(p1_action, rune.type)
	var p2_action = heroes[1].action()
	for rune in slots.runes["p2"]:
		if not rune.empty:
			Actions.apply_rune(p2_action, rune.type)
	
	await Actions.resolve_action(p1_action)
	await Actions.resolve_action(p2_action)
	
	for h in heroes:
		h.end_of_turn()
	for e in enemies.get_children():
		e.end_of_turn()

	reset_runes()
	
