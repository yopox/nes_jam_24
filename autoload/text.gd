extends Node


func wait(fighter: Fighter) -> String:
	return "%s waits." % fighter.name


func attack(fighter: Fighter, target: Fighter) -> String:
	return "%s attacks %s!" % [fighter.name, target.name]


func defend(fighter: Fighter, target: Fighter) -> String:
	if fighter == target:
		return "%s is defending." % fighter.name
	else:
		return "%s defends %s." % [fighter.name, target.name]


func damage(fighter: Fighter, amount: int) -> String:
	return "%s takes %s damage!" % [fighter.name, amount]


func ko(fighter: Fighter) -> String:
	return "%s is K.O!" % fighter.name


func perk_text(perk: Perks.Type):
	match perk:
		Perks.Type.Humility:
			return ["Humility", "Unlock 1 angel rune."]
		Perks.Type.Diligence:
			return ["Diligence", "Improve angel runes (+1% HP heal)."]
		Perks.Type.Patience:
			return ["Patience", "Decrease attack, Increase HP."]
		Perks.Type.Chastity:
			return ["Chastity", "Reduce skull effect by 5%."]
		Perks.Type.Charity:
			return ["Charity", "One rune slot must stay empty."]
		Perks.Type.Temperance:
			return ["Temperance", "Double action power if no runes are equipped."]
		Perks.Type.Gratitude:
			return ["Gratitude", "Revive once with 10% HP."]

		Perks.Type.Pride:
			return ["Pride", "Unlock 1 demon rune."]
		Perks.Type.Lust:
			return ["Lust", "Improve demon runes (+5% attack)."]
		Perks.Type.Gluttony:
			return ["Gluttony", "Unlock skull rune, attack boost."]
		Perks.Type.Greed:
			return ["Greed", "Decrease HP, attack boost."]
		Perks.Type.Envy:
			return ["Envy", "Draw one more rune each turn."]
		Perks.Type.Sloth:
			return ["Sloth", "Auto shield 5% HP each turn."]
		Perks.Type.Wrath:
			return ["Wrath", "Heal 2% on enemy kill."]

		Perks.Type.Musculation:
			return ["Musculation", "Unlock 1 flex rune."]
		Perks.Type.Training:
			return ["Training", "Attack boost."]
		Perks.Type.Voltage:
			return ["Voltage", "Unlock 1 Thunder rune."]
		Perks.Type.Endurance:
			return ["Endurance", "Flex runes give +5% action power."]
		Perks.Type.Strategy:
			return ["Strategy", "Unlock 1 Loop rune."]


		Perks.Type.Longevity:
			return ["Longevity", "HP boost."]
		Perks.Type.Immunity:
			return ["Immunity", "Defense boost."]
		Perks.Type.Simplicity:
			return ["Simplicity", "Blank runes give +10% action power."]
		Perks.Type.Barricade:
			return ["Barricade", "Keep 10% block each turn."]
		Perks.Type.Regeneration:
			return ["Regeneration", "Heal 2% HP at the beginning of each turn."]


func perk_name(perk: Perks.Type, hero: Fighter) -> String:
	var texts = perk_text(perk)
	var cost = Perks.costs[perk]
	var point = "pts" if cost != 1 else "pt"
	var owned = 0 if not hero.perks.has(perk) else hero.perks[perk]
	var quantity = Perks.quantities[perk]
	var max_owned = str(quantity) if quantity >= 0 else "inf"
	return "%s • %s %s • %s / %s" % [texts[0], cost, point, owned, max_owned]


func perk_description(perk: Perks.Type) -> String:
	return perk_text(perk)[1]


func room_name(type: Room.Type) -> String:
	match type:
		Room.Type.None: return ""
		Room.Type.Fight: return "Fight"
		Room.Type.Boss: return "Boss"
		Room.Type.Inn: return "Inn"
		Room.Type.Event: return "Unknown Event"
		Room.Type.Shop: return "Shop"
		_:
			printerr("Missing Room Name")
			return "Missing Room Name"
