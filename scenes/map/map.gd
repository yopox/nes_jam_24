class_name Map extends Node2D

@onready var graph: Node2D = $Graph

var selected: Vector2i = Vector2i.ZERO: set = _set_selected

var room_node = preload("res://scenes/map/room.tscn")
var link_scene = preload("res://scenes/ui/link.tscn")

var layout := {}
var map := {}
var doors := {}

var dx = (Values.WIDTH - 16 * Values.MAP_WIDTH) / 2 + 8


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
	
	move()	


func gen_map() -> void:
	layout.clear()
	while not is_layout_valid(): gen_layout()
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key([y, x])
			if not layout.has(key): continue
			var room: Room = room_node.instantiate()
			room.x = x
			room.y = y
			room.position.x = x * 16 + dx
			room.position.y = y * 16
			room.right_door = layout.has(Util.key([y, x + 1]))
			room.bottom_door = layout.has(Util.key([y + 1, x]))
			graph.add_child(room)
			map[key] = room
	remove_links()
	var starting: Room = map[map.keys().pick_random()]
	starting.visited = true
	starting.open = true
	starting.update()
	selected.x = starting.x
	selected.y = starting.y
	update_map()
	update_links()


func gen_layout():
	layout.clear()
	
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			layout[Util.key([y, x])] = null
	
	for _i in range(4):
		var layout2 = layout.duplicate()
		for y in range(Values.MAP_HEIGHT):
			for x in range(Values.MAP_WIDTH):
				var key = Util.key([y, x])
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


func remove_links() -> void:
	for y in range(Values.MAP_HEIGHT):
			for x in range(Values.MAP_WIDTH):
				var a = Util.key([y, x])
				var b = Util.key([y, x + 1])
				var c = Util.key([y + 1, x])
				if map.has(a) and map.has(b) and map.has(c):
					if map[a].right_door and map[a].bottom_door and map[b].bottom_door and map[c].right_door:
						var r = randf()
						if r < 0.15: map[a].right_door = false
						elif r < 0.30: map[a].bottom_door = false
						elif r < 0.45: map[b].bottom_door = false
						elif r < 0.60: map[c].right_door = false


func update_map() -> void:
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key([y, x])
			if not map.has(key): continue
			var room: Room = map[key]
			
			var key_r = Util.key([y, x + 1])
			if room.right_door and map.has(key_r):
				var room_r: Room = map[key_r]
				if room.visited and not room_r.open:
					room_r.open = true
				elif not room.open and room_r.visited:
					room.open = true
			
			var key_b = Util.key([y + 1, x])
			if room.bottom_door and map.has(key_b):
				var room_b: Room = map[key_b]
				if room.visited and not room_b.open:
					room_b.open = true
				elif not room.open and room_b.visited:
					room.open = true
		
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key([y, x])
			if not map.has(key): continue
			var room: Room = map[key]
			room.update()


func update_links() -> void:
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key([y, x])
			if not map.has(key): continue
			var room: Room = map[key]
			
			var key_r = Util.key([y, x + 1])
			if room.right_door and map.has(key_r):
				var door_key = "r-%s" % key_r
				if not doors.has(door_key):
					init_door(door_key, x, y, false)
				var link: Link = doors[door_key]
				var room_r: Room = map[key_r]
				link.update_weak(room_r.border_state(), room.border_state())
			
			var key_b = Util.key([y + 1, x])
			if room.bottom_door and map.has(key_b):
				var door_key = "b-%s" % key_b
				if not doors.has(door_key):
					init_door(door_key, x, y, true)
				var link: Link = doors[door_key]
				var room_b: Room = map[key_b]
				link.update_weak(room.border_state(), room_b.border_state())


func init_door(key: String, x: int, y: int, vertical: bool) -> void:
	var door: Link = link_scene.instantiate()
	door.position.x = x * 16 + (0 if vertical else 8) + dx
	door.position.y = y * 16 + (8 if vertical else 0)
	if not vertical: door.rotation = PI / 2
	doors[key] = door
	graph.add_child(door)


func neighbors(x: int, y: int, dict: Dictionary) -> String:
	var s = ""
	for d in [[y-1, x-1], [y-1, x], [y-1, x+1], \
			  [y , x-1],            [y, x+1], \
			  [y+1, x-1], [y+1, x], [y+1, x+1]]:
		s += "1" if dict.has(Util.key([d[0], d[1]])) else "0"
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
				var key = Util.key([y, x])
				if layout.has(key) and layout[key] == 1:
					var k_up = Util.key([y - 1, x])
					for k in [Util.key([y - 1, x]), Util.key([y + 1, x]), Util.key([y, x - 1]), Util.key([y, x + 1])]:
						if layout.has(k) and layout[k] != 1:
							changed = true
							layout[k] = 1
	
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key([y, x])
			if layout.has(key) and layout[key] == null:
				layout.erase(key)

	return layout.keys().size() > Values.MAP_MIN_ROOMS and layout.keys().size() < Values.MAP_MAX_ROOMS


func _set_selected(value: Vector2i) -> void:
	for m in map.values():
		m.border.blink(false)
		
	var key = Util.key([value.y, value.x])
	if map.has(key):
		var room: Room = map[key]
		room.border.blink(true)
	
	selected = value


func move() -> void:
	var check = false
	var check_r: bool = true
	var pos_check: Vector2i = selected
	var dpos: Vector2i = Vector2i.ZERO
	if Input.is_action_just_pressed("right"):
		check = true
		dpos.x = 1
	elif Input.is_action_just_pressed("down"):
		check = true
		check_r = false
		dpos.y = 1
	elif Input.is_action_just_pressed("left"):
		check = true
		pos_check.x -= 1
		dpos.x = -1
	elif Input.is_action_just_pressed("up"):
		check = true
		pos_check.y -= 1
		check_r = false
		dpos.y = -1
	
	if not check: return
	
	var key = Util.key([pos_check.y, pos_check.x])
	if not map.has(key): return

	var room: Room = map[key]
	if (check_r and room.right_door) or (not check_r and room.bottom_door):
		selected = selected + dpos
