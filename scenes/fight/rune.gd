class_name Rune extends Node2D

enum Type { Blank, Flex, Poison, Thunder, Demon, Angel, Skull, Loop }

@export var empty = false
@export var type: Type = Type.Blank
var locked := false

@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	sprite.texture = sprite.texture.duplicate()
	update_sprite()


func update_sprite():
	var texture := sprite.texture as AtlasTexture
	if empty:
		texture.region.position = Vector2(0, texture.region.position.y)
		return
	match type:
		Type.Blank:
			texture.region.position.x = 16 * 1
		Type.Flex:
			texture.region.position.x = 16 * 2
		Type.Poison:
			texture.region.position.x = 16 * 3
		Type.Thunder:
			texture.region.position.x = 16 * 4
		Type.Skull:
			texture.region.position.x = 16 * 5
		Type.Demon:
			texture.region.position.x = 16 * 6
		Type.Angel:
			texture.region.position.x = 16 * 7
		Type.Loop:
			texture.region.position.x = 16 * 8
