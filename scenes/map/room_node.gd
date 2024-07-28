class_name RoomNode extends Node2D

@onready var border: Border = $Border
@onready var sprite: Sprite2D = $Sprite
var atlas: AtlasTexture

var room: Room = Room.new()


func _ready():
	sprite.texture = sprite.texture.duplicate()
	atlas = sprite.texture


func update():
	border.update(border_state())
	update_sprite()


func border_state() -> Border.State:
	if room.visited: return Border.State.White
	if room.open: return Border.State.Gray
	return Border.State.Dark


func update_sprite() -> void:
	sprite.visible = room.open and room.type != Room.Type.None
	match room.type:
		Room.Type.None: pass
		Room.Type.Event: atlas.region.position.x = 8 * 0
		Room.Type.Fight: atlas.region.position.x = 8 * 1
		Room.Type.Boss: atlas.region.position.x = 8 * 2
		Room.Type.Inn: atlas.region.position.x = 8 * 3
		Room.Type.Shop: atlas.region.position.x = 8 * 4
