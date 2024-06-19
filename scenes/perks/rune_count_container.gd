class_name RuneCountContainer extends HBoxContainer

var rune_count = preload("res://scenes/perks/rune_count.tscn")


func reset():
	var runes = []
	for r in Values.all_runes:
		var count = Team.runes.count(r)
		if count > 0:
			runes.append([r, count])
	
	while get_child_count() < len(runes):
		var rc: RuneCount = rune_count.instantiate()
		add_child(rc)
	
	for i in range(get_child_count()):
		if i >= len(runes):
			get_children()[i].queue_free()
	
	for i in range(len(runes)):
		var rc: RuneCount = get_child(i)
		rc.rune.type = runes[i][0]
		rc.rune.empty = false
		rc.rune.update_sprite()
		rc.label.text = str(runes[i][1])
