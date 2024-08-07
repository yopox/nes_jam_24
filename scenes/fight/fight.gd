class_name Fight extends Node2D

@onready var status: Label = $Status
@onready var slots: Slots = $slots

@onready var action_p1: ActionSelect = $Heroes/Action
@onready var action_p2: ActionSelect = $Heroes/Action2

@onready var action_box: ActionBox = $ActionBox

@export var heroes: Array[Fighter] = []
@onready var enemies: Container = $Enemies

var turn = 0

var reset := false


func _enter_tree():
	Team.fight = self


func _ready():
	set_status(slots.selected_rune().description())
	
	var chou = load("res://scenes/enemies/Chou.tscn")
	var e1: Fighter = chou.instantiate()
	enemies.add_child(e1)
	
	var piou = load("res://scenes/enemies/Piou.tscn")
	var e2: Fighter = piou.instantiate()
	enemies.add_child(e2)
	
	for e in enemies.get_children():
		e.reset()
	for h in heroes:
		h.reset()
		h.intent = Actions.Type.Atk
		h.target = get_first_alive_enemy().id
		h.update_gui()
	
	new_turn()


func _process(_delta):
	if slots.state == Slots.State.Fight:
		return


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


func get_first_alive_enemy() -> Fighter:
	for e: Fighter in enemies.get_children():
		if e.is_alive():
			return e
	return null


func get_first_alive_ally() -> Fighter:
	for e: Fighter in heroes:
		if e.is_alive():
			return e
	return null


func get_allies() -> Array:
	return heroes.filter(func(f: Fighter): return f.is_alive())


func get_enemies() -> Array:
	var e = enemies.get_children()
	return e.filter(func(f: Fighter): return f.is_alive())


func get_random_ally() -> Fighter: return get_allies().pick_random()
func get_random_enemy() -> Fighter: return get_enemies().pick_random()
func get_weakest_enemy() -> Fighter: return Util.min_by_hp(get_enemies())
func get_weakest_ally() -> Fighter: return Util.min_by_hp(get_allies())
func get_strongest_enemy() -> Fighter: return Util.max_by_hp(get_enemies())
func get_strongest_ally() -> Fighter: return Util.max_by_hp(get_allies())
func get_random_fighter() -> Fighter:
	var fighters = get_allies()
	fighters.append_array(get_enemies())
	return fighters.pick_random()


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
	slots.reset_positions()


func new_turn() -> void:
	turn += 1

	for e: Fighter in enemies.get_children():
		e.clear_enemy_runes()

	await Util.wait(0.25)

	for e: Fighter in enemies.get_children():
		if e.is_alive():
			e.draft_enemy_runes()

	slots.reset_cursor()
	slots.new_turn()


func fight():
	slots.state = Slots.State.Fight
	var actions: Array[Actions.Action] = []
	
	var p1_action = heroes[0].action()
	for rune in slots.runes["p1"]:
		if not rune.empty:
			Actions.apply_rune(p1_action, rune.type)
	actions.append(p1_action)
	
	var p2_action = heroes[1].action()
	for rune in slots.runes["p2"]:
		if not rune.empty:
			Actions.apply_rune(p2_action, rune.type)
	actions.append(p2_action)
	
	for enemy: Fighter in enemies.get_children():
		if enemy.is_alive():
			var e_action = enemy.action()
			for rune: Rune in enemy.enemy_rune_nodes:
				Actions.apply_rune(e_action, rune.type)
			actions.append(e_action)
	
	# Defense has priority
	for action in actions:
		if action.type == Actions.Type.Def and action.fighter.is_alive():
			await Actions.resolve_action(action)
	
	# Resolve non defense actions
	for action in actions:
		if action.type != Actions.Type.Def and action.fighter.is_alive():
			await Actions.resolve_action(action)
	
	for h in heroes:
		h.end_of_turn()
	for e in enemies.get_children():
		e.end_of_turn()

	new_turn()


func _on_action_box_selected(first: bool):
	if slots.state == Slots.State.Fight: return
	
	if first: fight()
	else: reset_runes()
