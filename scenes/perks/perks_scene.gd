extends Node2D

@export var p1_angel: Node2D
@export var p1_demon: Node2D
@export var p1_atk: Node2D
@export var p1_def: Node2D

@export var p2_angel: Node2D
@export var p2_demon: Node2D
@export var p2_atk: Node2D
@export var p2_def: Node2D

var branches
var branch_sprites = {}

@export var cursor_sprite: Sprite2D

enum PerkState { Bought, Available, Locked }

class Cursor:
	var p1: bool = true
	var branch: int = 0
	var perk: int = 0
	
var cursor = Cursor.new()


func _ready():
	branches = [
		[p1_angel, p1_demon, p1_atk, p1_def],
		[p2_angel, p2_demon, p2_atk, p2_def],
	]
	
	for i in range(2):
		for j in range(4):
			var perks = 5
			if j < 2:
				perks = 7
			for k in range(perks):
				var border = Sprite2D.new()
				var t = AtlasTexture.new()
				t.atlas = load("res://assets/perk_borders.png")
				t.region.size.x = 12
				t.region.size.y = 12
				border.texture = t
				border.position = pos(i, j, k) + Vector2(4, 4)
				branch_sprites["p-%s-%s-%s" % [i, j, k]] = border
				update_perk(i, j, k)
				add_child(border)
			
				if k > 0:
					var link = Sprite2D.new()
					var link_t = AtlasTexture.new()
					link_t.atlas = load("res://assets/perk_connections.png")
					link_t.region.size.x = 4
					link_t.region.size.y = 4
					link.texture = link_t
					link.position = pos(i, j, k) + Vector2(4, -4)
					branch_sprites["l-%s-%s-%s" % [i, j, k]] = link
					update_link(i, j, k)
					add_child(link)


func _process(delta):
	if Input.is_action_just_pressed("up"):
		up()
		update_cursor()
	if Input.is_action_just_pressed("down"):
		down()
		update_cursor()
	if Input.is_action_just_pressed("left"):
		left()
		update_cursor()
	if Input.is_action_just_pressed("right"):
		right()
		update_cursor()

func down():
	if cursor.branch < 2:
		cursor.perk = posmod(cursor.perk + 1, 7)
	else:
		cursor.perk = posmod(cursor.perk + 1, 5)


func up():
	if cursor.branch < 2:
		cursor.perk = posmod(cursor.perk - 1, 7)
	else:
		cursor.perk = posmod(cursor.perk - 1, 5)


func right():
	cursor.branch += 1
	if cursor.branch == 4:
		cursor.p1 = not cursor.p1
		cursor.branch = 0
	if cursor.branch >= 2 and cursor.perk >= 5:
		cursor.perk = 4


func left():
	cursor.branch -= 1
	if cursor.branch == -1:
		cursor.p1 = not cursor.p1
		cursor.branch = 3
	if cursor.branch >= 2 and cursor.perk >= 5:
		cursor.perk = 4


func update_cursor():
	if cursor.p1:
		cursor_sprite.position = pos(0, cursor.branch, cursor.perk)
	else:
		cursor_sprite.position = pos(1, cursor.branch, cursor.perk)


func pos(perso: int, branch: int, perk: int) -> Vector2:
	return branches[perso][branch].position + Vector2(0, 16 * perk)


func update_perk(i: int, j: int, k: int) -> void:
	var node: Sprite2D = branch_sprites["p-%s-%s-%s" % [i, j, k]]
	match get_perk_state(i, j, k):
		PerkState.Bought:
			node.texture.region.position.x = 12 * 0
		PerkState.Available:
			node.texture.region.position.x = 12 * 1
		PerkState.Locked:
			node.texture.region.position.x = 12 * 2


func get_perk_state(i: int, j: int, k: int) -> PerkState:
	var perk_code = "%s-%s" % [j, k]	
	var bought := false
	if i == 0:
		bought = Team.hero1.perks.find_key(perk_code) != null
	else:
		bought = Team.hero2.perks.find_key(perk_code) != null
	if bought:
		return PerkState.Bought
	if not bought:
		var available: bool
		if i == 0:
			available = Team.hero1.is_perk_available(perk_code)
		else:
			available = Team.hero2.is_perk_available(perk_code)
		if available:
			return PerkState.Available
	return PerkState.Locked


func update_link(i: int, j: int, k: int) -> void:
	var node: Sprite2D = branch_sprites["l-%s-%s-%s" % [i, j, k]]
	match [get_perk_state(i, j, k-1), get_perk_state(i, j, k)]:
		[PerkState.Bought, PerkState.Bought]:
			node.texture.region.position.x = 4 * 0
		[PerkState.Bought, PerkState.Available]:
			node.texture.region.position.x = 4 * 1
		[PerkState.Available, PerkState.Bought]:
			node.texture.region.position.x = 4 * 2
		[PerkState.Available, PerkState.Available]:
			node.texture.region.position.x = 4 * 3
		[PerkState.Bought, PerkState.Locked]:
			node.texture.region.position.x = 4 * 5
		[PerkState.Available, PerkState.Locked]:
			node.texture.region.position.x = 4 * 6
		[PerkState.Locked, PerkState.Locked]:
			node.texture.region.position.x = 4 * 4
			if Perks.break_before(Perks.codes["%s-%s" % [j, k]]):
				node.texture.region.position.x = 4 * 7
