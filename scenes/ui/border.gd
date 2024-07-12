class_name Border extends Sprite2D

enum State { Dark, Gray, White }

@export var state: State = State.White
var atlas: AtlasTexture

@onready var anim: AnimatedSprite2D = $Sprite2D

func _ready():
	texture = texture.duplicate()
	atlas = texture as AtlasTexture
	anim.visible = false
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


func blink(b: bool) -> void:
	anim.visible = b
