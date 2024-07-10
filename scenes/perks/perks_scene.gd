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

var border_scene = preload("res://scenes/ui/border.tscn")
var link_scene = preload("res://scenes/ui/link.tscn")

@export var cursor_sprite: Sprite2D
@onready var tree: Node2D = $Tree
@onready var name_label: Label = $Name
@onready var desc_label: Label = $Description
@onready var p1pts: Label = $Tree/P1Pts
@onready var p2pts: Label = $Tree/P2Pts

@onready var p1hp: Label = $Hero1/Hero/Hp
@onready var p1atk: Label = $Hero1/Stats/Atk
@onready var p1def: Label = $Hero1/Stats/Def

@onready var p2hp: Label = $Hero2/Hero/Hp
@onready var p2atk: Label = $Hero2/Stats/Atk
@onready var p2def: Label = $Hero2/Stats/Def

@onready var runes: RuneCountContainer = $RuneCountContainer


class Cursor:
	var p1: bool = true
	var branch: int = 0
	var perk: int = 0
	
	func get_perk() -> Perks.Type: return Perks.codes[Util.key([branch, perk])]
	
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
				var border: Border = border_scene.instantiate()
				border.position = pos(i, j, k) + Vector2(4, 4)
				branch_sprites[Util.key([i, j, k], "p")] = border
				tree.add_child(border)
				update_perk(i, j, k)
			
				if k > 0:
					var link: Link = link_scene.instantiate()
					link.position = pos(i, j, k) + Vector2(4, -4)
					branch_sprites[Util.key([i, j, k], "l")] = link
					tree.add_child(link)
					update_link(i, j, k)
	
	update_stats()
	runes.reset()


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
	cursor.perk = posmod(cursor.perk - 1, rows)


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
	var code = Util.key([i, j, k], "p")
	if not branch_sprites.has(code):
		return
	
	var border: Border = branch_sprites[code]
	border.update(Perks.perk_to_border(get_perk_state(i, j, k)))
	
	if k > 0:
		update_link(i, j, k)


func get_perk_state(i: int, j: int, k: int) -> Perks.State:
	var perk_code = Util.key([j, k])
	var perk = Perks.codes[perk_code]
	var hero = Team.hero1 if cursor.p1 else Team.hero2
	
	if hero.perks.has(perk):
		return Perks.State.Bought
	elif hero.is_perk_available(perk_code):
		return Perks.State.Available
	else:
		return Perks.State.Locked


func update_link(i: int, j: int, k: int) -> void:
	var code = Util.key([i, j, k], "l")
	if not branch_sprites.has(code):
		return 
	var link: Link = branch_sprites[code]
	link.update(
		Perks.perk_to_border(get_perk_state(i, j, k-1)),
		Perks.perk_to_border(get_perk_state(i, j, k)),
		Perks.break_before(Perks.codes[Util.key([j, k])])
	)


func buy_perk() -> void:
	var hero = Team.hero1 if cursor.p1 else Team.hero2
	hero.buy_perk(cursor.get_perk())
	for b in range(4):
		for p in range(7):
			update_perk(0 if cursor.p1 else 1, b, p)
	p1pts.text = "%s %s" % [Team.hero1.perk_points, "pts" if Team.hero1.perk_points != 1 else "pt"]
	p2pts.text = "%s %s" % [Team.hero2.perk_points, "pts" if Team.hero2.perk_points != 1 else "pt"]
	update_stats()
	runes.reset()


func update_stats() -> void:
	p1hp.text = "HP %s / %s" % [Team.hero1.HP, Team.hero1.MAX_HP]
	p2hp.text = "HP %s / %s" % [Team.hero2.HP, Team.hero2.MAX_HP]
	p1atk.text = "ATK %d" % [Team.hero1.ATK]
	p2atk.text = "ATK %d" % [Team.hero2.ATK]
	p1def.text = "DEF %d" % [Team.hero1.DEF]
	p2def.text = "DEF %d" % [Team.hero2.DEF]
