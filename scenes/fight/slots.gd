extends Node2D

@onready
var cursor_sprite: Sprite2D = $Cursor

var rune = preload("res://scenes/fight/rune.tscn")

var runes = {
	"hand": [],
	"p1": [],
	"p2": [],
	"enemies": [],
}
var cursor = ["hand", 0]


func _init():
	for i in range(6):
		var pos = rune_pos("hand", i)
		var r = instantiate_rune(pos.x, pos.y, true)
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


func _process(delta):
	if Input.is_action_just_pressed("up"):
		match cursor[0]:
			"hand":
				cursor[0] = "p2"
				cursor[1] = 0
			"p1":
				cursor[0] = "hand"
				cursor[1] = 0
			"p2":
				cursor[0] = "p1"
		update_cursor()
	elif Input.is_action_just_pressed("down"):
		match cursor[0]:
			"hand":
				cursor[0] = "p1"
				cursor[1] = 0
			"p1":
				cursor[0] = "p2"
			"p2":
				cursor[0] = "hand"
				cursor[1] = 0
		update_cursor()
	elif Input.is_action_just_pressed("right"):
		cursor[1] = posmod(cursor[1] + 1, len(runes[cursor[0]]))
		update_cursor()
	elif Input.is_action_just_pressed("left"):
		cursor[1] = posmod(cursor[1] - 1, len(runes[cursor[0]]))
		update_cursor()


func update_cursor():
	var pos = rune_pos(cursor[0], cursor[1])
	cursor_sprite.position = pos + Vector2(0, 16)


func rune_pos(row, i) -> Vector2:
	match row:
		"hand":
			return Vector2(-96 + 24 * i, 80)
		"p1":
			return Vector2(48 + 24 * i, 4)
		"p2":
			return Vector2(48 + 24 * i, 36)
			
	printerr("Unknown rune pos: [" + row + ", " + str(i) + "]")
	return Vector2(-16, -16)


func instantiate_rune(x, y, empty, type = Rune.Type.Blank) -> Rune:
	var r = rune.instantiate() as Rune
	r.empty = empty
	r.position.x = x
	r.position.y = y
	return r
