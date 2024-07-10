class_name Border extends Sprite2D

enum State { Dark, Gray, White }

@export var state: State = State.White
var atlas: AtlasTexture


func _ready():
	texture = texture.duplicate()
	atlas = texture as AtlasTexture
	update(state)


func update(s: State) -> void:
	state = s
	match s:
		State.Dark:
			atlas.region.position.x = 12 * 2
		State.Gray:
			atlas.region.position.x = 12 * 1
		State.White:
			atlas.region.position.x = 12 * 0
