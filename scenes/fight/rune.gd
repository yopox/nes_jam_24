class_name Rune extends Node2D

enum Type { Blank, Flex, Poison, Thunder, Demon, Angel, Curse, Loop }

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
		Type.Curse:
			texture.region.position.x = 16 * 5
		Type.Demon:
			texture.region.position.x = 16 * 6
		Type.Angel:
			texture.region.position.x = 16 * 7
		Type.Loop:
			texture.region.position.x = 16 * 8


func description() -> String:
	if empty:
		return "Empty slot"
	match type:
		Type.Blank:
			return "[Blank] No effect"
		Type.Flex:
			return "[Flex] POW +%s%%" % Values.FLEX_BOOST
		Type.Poison:
			return "[Poison] Applies %s poison" % Values.POISON
		Type.Thunder:
			return "[Thunder] Action power -%s%%, targets the team" % Values.THUNDER_NERF
		Type.Curse:
			return "[Curse] POW -%s%%" % Values.CURSE_NERF
		Type.Demon:
			return "[Demon] ATK: +%s%% / mark DEF: -%s%%, +1 mark" % [Values.DEMON_BOOST, Values.DEMON_NERF]
		Type.Angel:
			return "[Angel] ATK: +%s%%, +1 mark DEF: heal %s%% / mark" % [Values.ANGEL_BOOST, Values.ANGEL_HEAL]
		Type.Loop:
			return "[Loop] POW -%s%%, repeats the action" % Values.LOOP_NERF
	printerr("No description for the rune type")
	return ""
