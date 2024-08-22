class_name Map extends Node

var layout := {}
var rooms := {}
var selected = Vector2i.ZERO


func gen() -> void:
	layout.clear()
	while not is_layout_valid(): gen_layout()
	for y in range(Values.MAP_HEIGHT):
		for x in range(Values.MAP_WIDTH):
			var key = Util.key([y, x])
			if not layout.has(key): continue
			var room: Room = Room.new()
			room.x = x
			room.y = y
			room.right_door = layout.has(Util.key([y, x + 1]))
			room.bottom_door = layout.has(Util.key([y + 1, x]))
			room.randomize()
			rooms[key] = room
	remove_links()
	
	selected = assign_rooms()
	var starting: Room = rooms[Util.key([selected.y, selected.x])]
	starting.open = true
	starting.visited = true


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


func neighbors(x: int, y: int, dict: Dictionary) -> String:
	var s = ""
	for d in [[y-1, x-1], [y-1, x], [y-1, x+1], \
			  [y , x-1],            [y, x+1], \
			  [y+1, x-1], [y+1, x], [y+1, x+1]]:
		s += "1" if dict.has(Util.key([d[0], d[1]])) else "0"
	return s


func match_pattern(pattern: String, neighbors: String) -> bool:
	for i in range(len(pattern)):
		if pattern[i] == ".": continue
		if pattern[i] != neighbors[i]: return false
	return true


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
				if match_pattern("11111111", n) and randf() < 0.15:
					layout.erase(key)
				elif match_pattern(".1.11.1.", n) and randf() < 0.45:
					layout[key] = null
				elif match_pattern("11111000", n) and randf() < 0.05:
					layout.erase(key)
				elif match_pattern("00011111", n) and randf() < 0.05:
					layout.erase(key)
				elif n.contains("0") and randf() < 0.05:
					layout.erase(key)
				elif not n.contains("0") and randf() < 0.1:
					layout.erase(key)
				
				if match_pattern("01101000", n):
					layout.erase(key)
				elif match_pattern("11010000", n):
					layout.erase(key)
				elif match_pattern("00010110", n):
					layout.erase(key)
				elif match_pattern("00001011", n):
					layout.erase(key)


func remove_links() -> void:
	for y in range(Values.MAP_HEIGHT):
			for x in range(Values.MAP_WIDTH):
				var a = Util.key([y, x])
				var b = Util.key([y, x + 1])
				var c = Util.key([y + 1, x])
				if rooms.has(a) and rooms.has(b) and rooms.has(c):
					if rooms[a].right_door and rooms[a].bottom_door and rooms[b].bottom_door and rooms[c].right_door:
						var r = randf()
						if r < 0.15: rooms[a].right_door = false
						elif r < 0.30: rooms[a].bottom_door = false
						elif r < 0.45: rooms[b].bottom_door = false
						elif r < 0.60: rooms[c].right_door = false


func assign_rooms() -> Vector2i:
	# TODO: Ensure that boss rooms are far enough from the start
	var room_types: Array = Util.expand_weights(Values.MAP_ROOMS)
	room_types.shuffle()
	var start_found = null
	var room_keys = rooms.keys().duplicate()
	room_keys.shuffle()
	for key in room_keys:
		if room_types.is_empty(): break
		var room = rooms[key]
		room.type = room_types.pop_back()
		if start_found == null and room.type == Room.Type.None:
			start_found = Vector2i(room.x, room.y)
	return start_found


func selected_room() -> Room:
	return rooms[Util.key([selected.y, selected.x])]
