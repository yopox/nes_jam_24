extends Node


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
