extends Node

enum Type {
	Humility, Diligence, Patience, Chastity, Charity, Temperance, Gratitude,
	Pride, Lust, Gluttony, Greed, Envy, Sloth, Wrath,
	Musculation, Training, Voltage, Endurance, Strategy,
	Longevity, Immunity, Simplicity, Barricade, Regeneration,
}

var codes = {
	"0-0": Type.Humility, "0-1": Type.Diligence, "0-2": Type.Patience, "0-3": Type.Chastity, "0-4": Type.Charity, "0-5": Type.Temperance, "0-6": Type.Gratitude,
	"1-0": Type.Pride, "1-1": Type.Lust, "1-2": Type.Gluttony, "1-3": Type.Greed, "1-4": Type.Envy, "1-5": Type.Sloth, "1-6": Type.Wrath,
	"2-0": Type.Musculation, "2-1": Type.Training, "2-2": Type.Voltage, "2-3": Type.Endurance, "2-4": Type.Strategy,
	"3-0": Type.Longevity, "3-1": Type.Immunity, "3-2": Type.Simplicity, "3-3": Type.Barricade, "3-4": Type.Regeneration,
}


func unlocked(perk: Type, perks: Dictionary) -> bool:
	match perk:
		Type.Humility:
			return perks.find_key(Type.Pride) == null
		Type.Pride:
			return perks.find_key(Type.Humility) == null
		
		Type.Musculation, Type.Longevity, Type.Immunity:
			return true
		
		Type.Diligence, Type.Patience, Type.Chastity:
			return perks.find_key(Type.Humility) != null
		Type.Charity:
			return perks.find_key(Type.Diligence) != null \
				and perks.find_key(Type.Patience) != null \
				and perks.find_key(Type.Chastity) != null
		Type.Temperance, Type.Gratitude:
			return perks.find_key(Type.Charity) != null
		
		Type.Lust:
			return perks.find_key(Type.Pride) != null
		Type.Gluttony, Type.Greed, Type.Envy:
			return perks.find_key(Type.Lust) != null
		Type.Sloth, Type.Wrath:
			return perks.find_key(Type.Gluttony) != null \
				and perks.find_key(Type.Greed) != null \
				and perks.find_key(Type.Envy) != null
		
		Type.Training:
			return perks.find_key(Type.Musculation) != null
		Type.Voltage, Type.Endurance:
			return perks.find_key(Type.Training) != null
		Type.Strategy:
			return perks.find_key(Type.Voltage) != null \
				and perks.find_key(Type.Endurance) != null
		
		Type.Simplicity, Type.Barricade:
			return perks.find_key(Type.Longevity) != null \
				and perks.find_key(Type.Immunity) != null
		Type.Regeneration:
			return perks.find_key(Type.Simplicity) != null \
				and perks.find_key(Type.Barricade) != null
		
		_:
			printerr("Type not found in unlocked")
			return true


func break_before(perk: Type) -> bool:
	match perk:
		Type.Diligence, Type.Charity, Type.Temperance:
			return true
		Type.Lust, Type.Gluttony, Type.Sloth:
			return true
		Type.Training, Type.Strategy:
			return true
		Type.Simplicity, Type.Regeneration:
			return true
		_:
			return false
