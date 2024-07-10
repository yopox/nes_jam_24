class_name Link extends Sprite2D

var atlas: AtlasTexture = texture


func _init():
	texture = texture.duplicate()
	atlas = texture as AtlasTexture


func update(from: Border.State, to: Border.State, disconnected_dark: bool = false) -> void:
	match [from, to]:
		[Border.State.White, Border.State.White]:
			atlas.region.position.x = 4 * 0
		[Border.State.White, Border.State.Gray]:
			atlas.region.position.x = 4 * 1
		[Border.State.Gray, Border.State.White]:
			atlas.region.position.x = 4 * 2
		[Border.State.Gray, Border.State.Gray]:
			atlas.region.position.x = 4 * 3
		[Border.State.White, Border.State.Dark]:
			atlas.region.position.x = 4 * 5
		[Border.State.Gray, Border.State.Dark]:
			atlas.region.position.x = 4 * 6
		[Border.State.Dark, Border.State.Dark]:
			atlas.region.position.x = 4 * 4
			if disconnected_dark:
				atlas.region.position.x = 4 * 7
