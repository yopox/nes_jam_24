extends Node

var hero1: Fighter = load("res://scenes/fight/hero.tscn").instantiate()
var hero2: Fighter = load("res://scenes/fight/hero.tscn").instantiate()

var runes: Array[Rune.Type] = []
var fight: Fight

func _init():
	reset_runes()
	

func reset_runes():
	runes.clear()
	for i in range(6):
		runes.append(Rune.Type.Blank)
	for i in range(2):
		runes.append(Rune.Type.Flex)


func draft_runes() -> Array[Rune.Type]:
	var drafted_i = Util.distinct(6, 0, len(runes) - 1)
	drafted_i.sort()
	drafted_i.reverse()
	var drafted: Array[Rune.Type] = []
	for i in drafted_i:
		drafted.append(runes[i])
	return drafted


func message(text: String, confirm: bool = true) -> void:
	fight.status.text = ""
	for c in text:
		fight.status.text += c
		await Util.wait(0.009)
	if confirm:
		await Util.confirm
		await Util.wait(0.01)
