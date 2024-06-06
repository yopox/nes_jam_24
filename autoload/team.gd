extends Node

var runes = []


func _init():
	reset_runes()
	

func reset_runes():
	runes.clear()
	for i in range(8):
		runes.append(Rune.Type.Blank)
	for i in range(2):
		runes.append(Rune.Type.Flex)


func draft_runes() -> Array[Rune.Type]:
	var drafted_i = Util.distinct(6, 0, len(runes) - 1)
	var drafted: Array[Rune.Type] = []
	for i in drafted_i:
		drafted.append(runes[i])
	return drafted
