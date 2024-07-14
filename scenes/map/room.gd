class_name Room extends Node2D

@onready var border: Border = $Border
@onready var sprite: Sprite2D = $Sprite
var atlas: AtlasTexture

var x: int
var y: int
var right_door = true
var bottom_door = true

var visited = false
var open = false

enum Type { None, Fight, Boss, Shop, Inn, Event }
@export var type: Type = Type.None


func _ready():
	sprite.texture = sprite.texture.duplicate()
	atlas = sprite.texture


func randomize() -> void:
	type = Type.values().pick_random()


func update():
	border.update(border_state())
	update_sprite()


func border_state() -> Border.State:
	if visited: return Border.State.White
	if open: return Border.State.Gray
	return Border.State.Dark


func update_sprite() -> void:
	sprite.visible = open and type != Type.None
	match type:
		Type.None: pass
		Type.Event: atlas.region.position.x = 8 * 0
		Type.Fight: atlas.region.position.x = 8 * 1
		Type.Boss: atlas.region.position.x = 8 * 2
		Type.Inn: atlas.region.position.x = 8 * 3
		Type.Shop: atlas.region.position.x = 8 * 4
		

func open_room() -> bool:
	open = true
	if type == Room.Type.None:
		visited = true
	return true
