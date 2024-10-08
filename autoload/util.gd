extends Node

const BLUE = Color("#56cfde")
const ACID_GREEN = Color("#62b824")
const GREEN = Color("#277b30")
const ORANGE = Color("#faaa39")
const RED = Color("#ee1841")
const DARK_RED = Color("#a51140")
const YELLOW = Color("#ffe86b")
const WHITE = Color("#ffffff")
const GRAY = Color("#aaa4a5")

var unique_id = 0

signal confirm()


func _input(event):
	if event.is_action_pressed("a"):
		confirm.emit()


func get_unique_id() -> int:
	unique_id += 1
	return unique_id


func distinct(n: int, from: int, to: int) -> Array:
	var drafted = []
	
	if to < from:
		return []
	
	if to - from < n:
		for i in range(from, to + 1):
			drafted.append(i)
	
	else:
		while len(drafted) < n:
			var i = -1
			while i < 0 or i in drafted:
				i = randi_range(from, to)
			drafted.append(i)
	
	return drafted


func min_by_hp(fighters: Array) -> Fighter:
	if fighters.is_empty():
		return null
	
	var min_fighter = fighters[0] as Fighter
	for fighter: Fighter in fighters:
		if fighter.stats.HP < min_fighter.stats.HP:
			min_fighter = fighter
	
	return min_fighter


func max_by_hp(fighters: Array) -> Fighter:
	if fighters.is_empty():
		return null
	
	var max_fighter = fighters[0] as Fighter
	for fighter: Fighter in fighters:
		if fighter.stats.HP > max_fighter.stats.HP:
			max_fighter = fighter
	
	return max_fighter


func wait(amount: float):
	await get_tree().create_timer(amount).timeout


func key(parts: Array[int], prefix: String = "") -> String:
	var k = prefix
	for i in range(len(parts)):
		k += ("-" if not prefix.is_empty() or i > 0 else "") + str(parts[i])
	return k


func get_weights(table) -> Array:
	var w = 0
	var weights = []
	for i in range(len(table)):
		w += table[i][1]
		weights.append([table[i][0], w])
	return weights


func expand_weights(table) -> Array:
	var e = []
	for elem in table:
		for i in range(elem[1]):
			e.append(elem[0])
	return e
