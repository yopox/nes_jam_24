extends Node


func create_link() -> Sprite2D:
	var link = Sprite2D.new()
	var link_t = AtlasTexture.new()
	link_t.atlas = load("res://assets/perk_connections.png")
	link_t.region.size.x = 4
	link_t.region.size.y = 4
	link.texture = link_t
	return link
