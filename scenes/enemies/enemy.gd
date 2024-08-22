@icon("res://assets/icons/node_2D/icon_skull.png")
class_name Enemy extends Node

@export var enemy_rune_nodes: Array[Rune] = []

@onready var sprite = $Sprite2D
@onready var stats: StatsNode = $Stats

var fighter: Fighter


func _ready():
	var texture: AtlasTexture = sprite.texture
	texture.atlas = texture.atlas.duplicate()


func set_enemy(type: Fighter.Type, level: int) -> void:
	var texture: AtlasTexture = sprite.texture
	match type:
		Fighter.Type.Piou:
			texture.region.position.x = 0
		Fighter.Type.Chou:
			texture.region.position.x = 32
	
	fighter = Fighter.new()
	fighter.type = type
	fighter.name = str(type)
	fighter.runes = get_enemy_runes(type)
	
	stats.reset(fighter)
	fighter.stats.stats_changed.connect(stats.stats_changed)
	


func end_of_turn() -> void:
	fighter.end_of_turn()


func clear_enemy_runes():
	for i in range(len(enemy_rune_nodes)):
		enemy_rune_nodes[i].empty = true
		await Util.wait(0.035)
		enemy_rune_nodes[i].update_sprite()


func draft_enemy_runes():
	var draft: Array = Util.distinct(len(enemy_rune_nodes), 0, len(fighter.runes) - 1)
	draft.sort()
	draft.reverse()
	for i in range(len(draft)):
		enemy_rune_nodes[i].empty = false
		enemy_rune_nodes[i].type = fighter.runes[draft[i]]
		await Util.wait(0.1)
		enemy_rune_nodes[i].update_sprite()


func get_enemy_runes(type: Fighter.Type) -> Array[Rune.Type]:
	return [Rune.Type.Blank, Rune.Type.Blank, Rune.Type.Flex]
