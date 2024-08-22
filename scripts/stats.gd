class_name Stats

var MAX_HP: int = 100:  set = _set_max_hp
var HP: int = MAX_HP: set = _set_hp
var ATK: int = 10
var DEF: int = 5

var perk_points = 10
var perks = {}

signal stats_changed(stats: Stats)


func _set_max_hp(value: int):
	MAX_HP = value
	stats_changed.emit(self)


func _set_hp(value: int):
	HP = value
	stats_changed.emit(self)


func full_heal() -> void: HP = MAX_HP


func hp_geq(percent: int) -> bool: return HP / MAX_HP * 100 >= percent


func heal(percent: int) -> void:
	HP += percent / 100.0 * MAX_HP
	HP = min(HP, MAX_HP)


func is_perk_available(code: String) -> bool:
	return Perks.unlocked(Perks.codes[code], perks)


func buy_perk(perk: Perks.Type) -> void:
	var cost = Perks.costs[perk]
	if not Perks.unlocked(perk, perks):
		return
	var max_owned = Perks.quantities[perk]
	if max_owned != -1 and perks.has(perk) and perks[perk] >= Perks.quantities[perk]:
		return

	if perk == Perks.Type.Patience and ATK < Values.PERK_PATIENCE_NERF + 1:
		return
	if perk == Perks.Type.Greed and \
		(HP < Values.PERK_GREED_NERF + 1) or (MAX_HP < Values.PERK_GREED_NERF + 1):
		return

	if perk_points >= cost:
		perk_points -= cost
		if perks.has(perk):
			perks[perk] += 1
		else:
			perks[perk] = 1
		Perks.bought(perk, self)
		stats_changed.emit(self)
