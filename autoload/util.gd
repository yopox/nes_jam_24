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


func get_unique_id():
	unique_id += 1
	return unique_id


func distinct(n: int, from: int, to: int) -> Array:
	var drafted = []
	
	if to - from < n:
		printerr("Can't generate distinct numbers: too short interval")
		return []
	
	while len(drafted) < n:
		var i = -1
		while i < 0 or i in drafted:
			i = randi_range(from, to)
		drafted.append(i)
	
	return drafted
