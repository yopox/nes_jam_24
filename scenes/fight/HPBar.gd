class_name HPBar extends Node2D

@onready var outline: ColorRect = $BarOutline
@onready var missing: ColorRect = $HPMissing
@onready var hp: ColorRect = $HP


func update(fighter_hp: int, fighter_max_hp: int) -> void:
	var width = outline.size.x - 2
	if fighter_hp < 1:
		hp.size.x = 0
	else:
		var ratio: float = 1.0 * fighter_hp / fighter_max_hp
		hp.size.x = ceili(width * ratio)
		if ratio < 0.2:
			hp.color = Util.RED
		elif ratio <= 0.5:
			hp.color = Util.ORANGE
		else:
			hp.color = Util.GREEN
