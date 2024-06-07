class_name Slots extends Node2D

@onready var cursor_sprite: Sprite2D = $Cursor
@onready var cursor_sprite_2: Sprite2D = $Cursor2
@onready var fight: Fight = get_parent()

var rune = preload("res://scenes/fight/rune.tscn")

var runes = {
	"enemies": [],
	"p1": [],
	"p2": [],
	"hand": [],
}
var cursor_p = ["hand", 0]
var cursor_s = ["hand", 0]

enum State { RuneSelect, RuneSwitch, P1Action, P1Target, P2Action, P2Target }
var state = State.RuneSelect

func _init():
	var hand = Team.draft_runes()
	for i in range(6):
		var pos = rune_pos("hand", i)
		var r := instantiate_rune(pos.x, pos.y, false, hand[i])
		add_child(r)
		runes["hand"].append(r)
	
	for i in range(3):
		var pos = rune_pos("p2", i)
		var r = instantiate_rune(pos.x, pos.y, true)
		add_child(r)
		runes["p2"].append(r)
		
	for i in range(3):
		var pos = rune_pos("p1", i)
		var r = instantiate_rune(pos.x, pos.y, true)
		add_child(r)
		runes["p1"].append(r)


func _ready():
	update_cursor()


func selected_rune() -> Rune:
	return runes[cursor_p[0]][cursor_p[1]]


func _process(_delta):
	if Input.is_action_just_pressed("a"):
		fight.a(state)
		match state:
			State.RuneSelect:
				if selected_rune().locked or selected_rune().empty:
					pass
				else:
					state = State.RuneSwitch
					cursor_s[0] = cursor_p[0]
					cursor_s[1] = cursor_p[1]
					update_cursor()
			State.RuneSwitch:
				var new = selected_rune()
				if new.locked:
					pass
				else:
					state = State.RuneSelect
					var old: Rune = runes[cursor_s[0]][cursor_s[1]]
					var old_pos = old.position
					old.position = new.position
					new.position = old_pos
					runes[cursor_s[0]][cursor_s[1]] = new
					runes[cursor_p[0]][cursor_p[1]] = old
					update_cursor()
	if Input.is_action_just_pressed("up"):
		up()
	elif Input.is_action_just_pressed("down"):
		down()
	elif Input.is_action_just_pressed("right"):
		right()
	elif Input.is_action_just_pressed("left"):
		left()


func up():
	match state:
		State.P1Action:
			state = State.RuneSelect
			cursor_p[0] = "hand"
			cursor_p[1] = 0
		State.P1Target:
			state = State.P1Action
		State.P2Action:
			state = State.P1Target
		State.P2Target:
			state = State.P2Action
		State.RuneSelect, State.RuneSwitch:
			match cursor_p[0]:
				"p1":
					cursor_p[0] = "hand"
					cursor_p[1] = 0
				"p2":
					cursor_p[0] = "p1"
				"hand":
					cursor_p[0] = "p2"
					cursor_p[1] = 0
	update_cursor()


func down():
	match state:
		State.P1Action:
			state = State.P1Target
		State.P1Target:
			state = State.P2Action
		State.P2Action:
			state = State.P2Target
		State.P2Target:
			state = State.RuneSelect
			cursor_p[0] = "hand"
			cursor_p[1] = 0
		State.RuneSelect, State.RuneSwitch:
			match cursor_p[0]:
				"p1":
					cursor_p[0] = "p2"
				"p2":
					cursor_p[0] = "hand"
					cursor_p[1] = 0
				"hand":
					cursor_p[0] = "p1"
					cursor_p[1] = 0
	update_cursor()


func right():
	if cursor_p[0] == "p1" and cursor_p[1] == len(runes["p1"]) - 1 and state == State.RuneSelect:
		state = State.P1Action
	elif cursor_p[0] == "p2" and cursor_p[1] == len(runes["p2"]) - 1 and state == State.RuneSelect:
		state = State.P2Action
	else:
		if state in [State.P1Action, State.P1Target]:
			state = State.RuneSelect
			cursor_p = ["p1", 0]
		elif state in [State.P2Action, State.P2Target]:
			state = State.RuneSelect
			cursor_p = ["p2", 0]			
		else:
			cursor_p[1] = posmod(cursor_p[1] + 1, len(runes[cursor_p[0]]))
	update_cursor()


func left():
	if cursor_p[0] == "p1" and cursor_p[1] == 0 and state == State.RuneSelect:
		state = State.P1Action
	elif cursor_p[0] == "p2" and cursor_p[1] == 0 and state == State.RuneSelect:
		state = State.P2Action
	else:
		if state in [State.P1Action, State.P1Target]:
			state = State.RuneSelect
			cursor_p = ["p1", len(runes["p1"]) - 1]
		elif state in [State.P2Action, State.P2Target]:
			state = State.RuneSelect
			cursor_p = ["p2", len(runes["p2"]) - 1]	
		else:
			cursor_p[1] = posmod(cursor_p[1] - 1, len(runes[cursor_p[0]]))
	update_cursor()


func update_cursor():
	match state:
		State.P1Action, State.P1Target:
			cursor_sprite.position = Vector2(10, 21)
		State.P2Action, State.P2Target:
			cursor_sprite.position = Vector2(10, 53)
		State.RuneSelect, State.RuneSwitch:
			var pos = rune_pos(cursor_p[0], cursor_p[1])
			cursor_sprite.position = pos + Vector2(0, 16)
			cursor_sprite_2.visible = state == State.RuneSwitch
			cursor_sprite_2.position = rune_pos(cursor_s[0], cursor_s[1]) + Vector2(0, 16)
	
	match state:
		State.RuneSelect:
			fight.set_status(selected_rune().description())
		State.RuneSwitch:
			fight.set_status("Move to?")
	
	fight.update_state(state)


func rune_pos(row, i) -> Vector2:
	match row:
		"p1":
			return Vector2(48 + 24 * i, 4)
		"p2":
			return Vector2(48 + 24 * i, 36)
		"hand":
			return Vector2(-96 + 24 * i, 80)
	
	printerr("Unknown rune pos: [" + row + ", " + str(i) + "]")
	return Vector2(-16, -16)


func instantiate_rune(x, y, empty, type = Rune.Type.Blank) -> Rune:
	var r = rune.instantiate() as Rune
	r.empty = empty
	r.position.x = x
	r.position.y = y
	r.type = type
	return r
