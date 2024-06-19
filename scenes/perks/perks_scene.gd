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
@onready var tree: Node2D = $Tree
@onready var name_label: Label = $Name
@onready var desc_label: Label = $Description
@onready var p1pts: Label = $Tree/P1Pts
@onready var p2pts: Label = $Tree/P2Pts

enum PerkState { Bought, Available, Locked }

class Cursor:
	var p1: bool = true
	var branch: int = 0
	var perk: int = 0
	
	func get_perk() -> Perks.Type: return Perks.codes["%s-%s" % [branch, perk]]
	
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
				tree.add_child(border)
			
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
					tree.add_child(link)


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
	if Input.is_action_just_pressed("a"):
		buy_perk()
		update_cursor()

func down():
	var rows = 7 if cursor.branch < 2 else 5
	cursor.perk = posmod(cursor.perk + 1, rows)


func up():
	var rows = 7 if cursor.branch < 2 else 5
	cursor.perk = posmod(cursor.perk - 1, 7)


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
	var hero_i = 0 if cursor.p1 else 1
	cursor_sprite.position = pos(hero_i, cursor.branch, cursor.perk)
	name_label.text = Text.perk_name(cursor.get_perk(), Team.hero1 if cursor.p1 else Team.hero2)
	desc_label.text = Text.perk_description(cursor.get_perk())


func pos(perso: int, branch: int, perk: int) -> Vector2:
	return branches[perso][branch].position + Vector2(0, 16 * perk)


func update_perk(i: int, j: int, k: int) -> void:
	var code = "p-%s-%s-%s" % [i, j, k]
	if not branch_sprites.has(code):
		return
	var node: Sprite2D = branch_sprites[code]
	match get_perk_state(i, j, k):
		PerkState.Bought:
			node.texture.region.position.x = 12 * 0
		PerkState.Available:
			node.texture.region.position.x = 12 * 1
		PerkState.Locked:
			node.texture.region.position.x = 12 * 2
	
	if k > 0:
		update_link(i, j, k)


func get_perk_state(i: int, j: int, k: int) -> PerkState:
	var perk_code = "%s-%s" % [j, k]
	var perk = Perks.codes[perk_code]
	var hero = Team.hero1 if cursor.p1 else Team.hero2
	
	if hero.perks.has(perk):
		return PerkState.Bought
	elif hero.is_perk_available(perk_code):
		return PerkState.Available
	else:
		return PerkState.Locked


func update_link(i: int, j: int, k: int) -> void:
	var code = "l-%s-%s-%s" % [i, j, k]
	if not branch_sprites.has(code):
		return 
	var node: Sprite2D = branch_sprites[code]
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


func buy_perk() -> void:
	var hero = Team.hero1 if cursor.p1 else Team.hero2
	hero.buy_perk(cursor.get_perk())
	for b in range(4):
		for p in range(7):
			update_perk(0 if cursor.p1 else 1, b, p)
	p1pts.text = "%s %s" % [Team.hero1.perk_points, "pts" if Team.hero1.perk_points != 1 else "pt"]
	p2pts.text = "%s %s" % [Team.hero2.perk_points, "pts" if Team.hero2.perk_points != 1 else "pt"]
