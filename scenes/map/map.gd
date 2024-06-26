class_name Map extends Node2D

@onready var graph: Node2D = $Graph

var room_node = preload("res://scenes/map/room.tscn")
var layout := {}
var map := {}
var doors := {}


func _ready():
	gen_map()


func _process(delta):
	if Input.is_action_just_pressed("a"):
		layout.clear()
		map.clear()
		doors.clear()
		for c in graph.get_children():
			c.free()
		gen_map()


func gen_map() -> void:
	layout.clear()
	while not is_layout_valid(): gen_layout()
	var dx = (Values.WIDTH - 16 * Values.MAP_WIDTH) / 2 + 8
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key(y, x)
			if not layout.has(key): continue
			var room: Room = room_node.instantiate()
			room.position.x = x * 16 + dx
			room.position.y = y * 16
			room.right_door = layout.has(Util.key(y, x + 1))
			room.bottom_door = layout.has(Util.key(y + 1, x))
			graph.add_child(room)
			map[key] = room
	update_links()


func gen_layout():
	layout.clear()
	
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			layout[Util.key(y, x)] = null
	
	for _i in range(4):
		var layout2 = layout.duplicate()
		for y in range(Values.MAP_HEIGHT):
			for x in range(Values.MAP_WIDTH):
				var key = Util.key(y, x)
				var n = neighbors(x, y, layout2)
				if match("11111111", n) and randf() < 0.15:
					layout.erase(key)
				elif match(".1.11.1.", n) and randf() < 0.45:
					layout[key] = null
				elif match("11111000", n) and randf() < 0.05:
					layout.erase(key)
				elif match("00011111", n) and randf() < 0.05:
					layout.erase(key)
				elif n.contains("0") and randf() < 0.05:
					layout.erase(key)
				elif not n.contains("0") and randf() < 0.1:
					layout.erase(key)
				
				if match("01101000", n):
					layout.erase(key)
				elif match("11010000", n):
					layout.erase(key)
				elif match("00010110", n):
					layout.erase(key)
				elif match("00001011", n):
					layout.erase(key)


func update_links() -> void:
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key(y, x)
			if not map.has(key): continue
			var room: Room = map[key]
			
			var key_r = Util.key(y, x + 1)
			if room.right_door and map.has(key_r):
				var door_key = "r-%s" % key_r
				if not doors.has(door_key):
					init_door(door_key, x, y, false)
			
			var key_b = Util.key(y + 1, x)
			if room.bottom_door and map.has(key_b):
				var door_key = "b-%s" % key_b
				if not doors.has(door_key):
					init_door(door_key, x, y, true)


func init_door(key: String, x: int, y: int, vertical: bool) -> void:
	var door: Sprite2D = NodeUtil.create_link()
	door.position.x = (x + 1) * 16 + (0 if vertical else 8)
	door.position.y = y * 16 + (8 if vertical else 0)
	if not vertical: door.rotation = PI / 2
	doors[key] = door
	graph.add_child(door)


func neighbors(x: int, y: int, dict: Dictionary) -> String:
	var s = ""
	for d in [[y-1, x-1], [y-1, x], [y-1, x+1], \
			  [y , x-1],            [y, x+1], \
			  [y+1, x-1], [y+1, x], [y+1, x+1]]:
		s += "1" if dict.has(Util.key(d[0], d[1])) else "0"
	return s


func match(pattern: String, neighbors: String) -> bool:
	for i in range(len(pattern)):
		if pattern[i] == ".": continue
		if pattern[i] != neighbors[i]: return false
	return true


func is_layout_valid() -> bool:
	if layout.keys().size() == 0: return false
	
	# Flood fill
	layout[layout.keys()[0]] = 1
	
	var changed = true
	while changed:
		changed = false
		for y in range(Values.MAP_HEIGHT):
			for x in range(Values.MAP_WIDTH):
				var key = Util.key(y, x)
				if layout.has(key) and layout[key] == 1:
					var k_up = Util.key(y - 1, x)
					for k in [Util.key(y - 1, x), Util.key(y + 1, x), Util.key(y, x - 1), Util.key(y, x + 1)]:
						if layout.has(k) and layout[k] != 1:
							changed = true
							layout[k] = 1
	
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key(y, x)
			if layout.has(key) and layout[key] == null:
				layout.erase(key)

	return layout.keys().size() > Values.MAP_MIN_ROOMS and layout.keys().size() < Values.MAP_MAX_ROOMS
