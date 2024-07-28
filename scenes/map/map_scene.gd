class_name MapScene extends Node2D

@onready var graph: Node2D = $Graph
@onready var room_name: Label = $RoomName

@onready var p1_stats: StatsText = $P1Stats
@onready var p2_stats: StatsText = $P2Stats

var room_node = preload("res://scenes/map/room_node.tscn")
var link_scene = preload("res://scenes/ui/link.tscn")

var room_nodes := {}
var door_nodes := {}

var dx = (Values.WIDTH - 16 * Values.MAP_WIDTH) / 2 + 8


func _ready():
	p1_stats.set_fighter(Team.hero1)
	p2_stats.set_fighter(Team.hero2)
	update_name()
	update_map()
	update_links()
	set_selected(Progress.map.selected)


func _process(delta):
	move()


func update_map() -> void:
	var changed = false
	var map: Map = Progress.map
	
	for room: Room in map.rooms.values():
		var x = room.x
		var y = room.y
		
		var key = Util.key([y, x])
		if not room_nodes.has(key):
			var r = room_node.instantiate()
			r.room = room
			r.position.x = room.x * 16 + dx
			r.position.y = room.y * 16
			graph.add_child(r)
			room_nodes[key] = r
		
		var key_r = Util.key([y, x + 1])
		if room.right_door and map.rooms.has(key_r):
			var room_r: Room = map.rooms[key_r]
			if room.visited and not room_r.open:
				changed = room_r.open_room()
			elif not room.open and room_r.visited:
				changed = room.open_room()
		
		var key_b = Util.key([y + 1, x])
		if room.bottom_door and map.rooms.has(key_b):
			var room_b: Room = map.rooms[key_b]
			if room.visited and not room_b.open:
				changed = room_b.open_room()
			elif not room.open and room_b.visited:
				changed = room.open_room()
	
	for room: RoomNode in room_nodes.values():
		room.update()
	
	if changed:
		update_map()


func update_links() -> void:
	var map: Map = Progress.map
	
	for room_node: RoomNode in room_nodes.values():
		var room = room_node.room
		var x = room.x
		var y = room.y
			
		var key_r = Util.key([y, x + 1])
		if room.right_door and map.rooms.has(key_r):
			var door_key = Util.key([y, x + 1], "r")
			if not door_nodes.has(door_key):
				init_door(door_key, x, y, false)
			var link: Link = door_nodes[door_key]
			var room_r: RoomNode = room_nodes[key_r]
			link.update_weak(room_r.border_state(), room_node.border_state())
		
		var key_b = Util.key([y + 1, x])
		if room.bottom_door and map.rooms.has(key_b):
			var door_key = Util.key([y + 1, x], "b")
			if not door_nodes.has(door_key):
				init_door(door_key, x, y, true)
			var link: Link = door_nodes[door_key]
			var room_b: RoomNode = room_nodes[key_b]
			link.update_weak(room_node.border_state(), room_b.border_state())


func init_door(key: String, x: int, y: int, vertical: bool) -> void:
	var door: Link = link_scene.instantiate()
	door.position.x = x * 16 + (0 if vertical else 8) + dx
	door.position.y = y * 16 + (8 if vertical else 0)
	if not vertical: door.rotation = PI / 2
	door_nodes[key] = door
	graph.add_child(door)


func set_selected(value: Vector2i) -> void:
	var map: Map = Progress.map
	
	for room: RoomNode in room_nodes.values():
		room.border.blink(false)
		
	var key = Util.key([value.y, value.x])
	if map.rooms.has(key):
		var room: RoomNode = room_nodes[key]
		room.border.blink(true)
	
	map.selected = value


func move() -> void:
	var check = false
	var check_r: bool = true
	var pos_check: Vector2i = Progress.map.selected
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
	var map: Map = Progress.map
	if not map.rooms.has(key): return

	var room: Room = map.rooms[key]
	if (check_r and room.right_door) or (not check_r and room.bottom_door):
		set_selected(map.selected + dpos)
	
	update_name()


func update_name() -> void:
	var map: Map = Progress.map
	var room: Room = map.rooms[Util.key([map.selected.y, map.selected.x])]
	if room.open:
		room_name.text = Text.room_name(room.type)
	else:
		room_name.text = Text.locked_room()


func _on_action_box_selected(first):
	if first:
		# TODO: Proceed to event
		pass
	else:
		var manager: Manager = get_parent().get_parent()
		manager.change_scene(Manager.Scenes.Perks)
