class_name Fight extends Node2D

@onready var status: Label = $Status
@onready var slots: Slots = $slots

@onready var action_p1: Action = $Heroes/Action
@onready var action_p2: Action = $Heroes/Action2

@onready var arrow: Sprite2D = $ActionBox/Arrow

@export var heroes: Array[Fighter] = []
@onready var enemies: Container = $Enemies


var reset := false


func _enter_tree():
	Team.fight = self


func _ready():
	set_status(slots.selected_rune().description())
	for e in enemies.get_children():
		e.id = Util.get_unique_id()
	for h in heroes:
		h.id = Util.get_unique_id()
		h.intent = Actions.Type.Atk
		h.target = get_first_alive_enemy()
		h.update_gui()


func _process(_delta):
	if Input.is_action_just_pressed("select"):
		reset = !reset
		if reset:
			arrow.position.y = 75
		else:
			arrow.position.y = 85
	if Input.is_action_just_pressed("start"):
		if reset:
			print("Reset")
		else:
			print("Fight")


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
