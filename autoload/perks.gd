extends Node

enum State { Bought, Available, Locked }

enum Type {
	Humility, Diligence, Patience, Chastity, Charity, Temperance, Gratitude,
	Pride, Lust, Gluttony, Greed, Envy, Sloth, Wrath,
	Musculation, Training, Voltage, Endurance, Strategy,
	Longevity, Immunity, Simplicity, Barricade, Regeneration,
}

var codes := {
	"0-0": Type.Humility, "0-1": Type.Diligence, "0-2": Type.Patience, "0-3": Type.Chastity, "0-4": Type.Charity, "0-5": Type.Temperance, "0-6": Type.Gratitude,
	"1-0": Type.Pride, "1-1": Type.Lust, "1-2": Type.Gluttony, "1-3": Type.Greed, "1-4": Type.Envy, "1-5": Type.Sloth, "1-6": Type.Wrath,
	"2-0": Type.Musculation, "2-1": Type.Training, "2-2": Type.Voltage, "2-3": Type.Endurance, "2-4": Type.Strategy,
	"3-0": Type.Longevity, "3-1": Type.Immunity, "3-2": Type.Simplicity, "3-3": Type.Barricade, "3-4": Type.Regeneration,
}

var costs := {
	Type.Humility: 2,
	Type.Diligence: 1,
	Type.Patience: 0,
	Type.Chastity: 1,
	Type.Charity: 0,
	Type.Temperance: 3,
	Type.Gratitude: 2,

	Type.Pride: 2,
	Type.Lust: 1,
	Type.Gluttony: 0,
	Type.Greed: 0,
	Type.Envy: 3,
	Type.Sloth: 4,
	Type.Wrath: 1,

	Type.Musculation: 1,
	Type.Training: 1,
	Type.Voltage: 3,
	Type.Endurance: 2,
	Type.Strategy: 4,


	Type.Longevity: 1,
	Type.Immunity: 1,
	Type.Simplicity: 2,
	Type.Barricade: 2,
	Type.Regeneration: 3,
}

var quantities := {
	Type.Humility: -1,
	Type.Diligence: -1,
	Type.Patience: -1,
	Type.Chastity: 5,
	Type.Charity: 1,
	Type.Temperance: 1,
	Type.Gratitude: 5,

	Type.Pride: -1,
	Type.Lust: -1,
	Type.Gluttony: 9,
	Type.Greed: -1,
	Type.Envy: 1,
	Type.Sloth: 2,
	Type.Wrath: 10,

	Type.Musculation: 1,
	Type.Training: -1,
	Type.Voltage: 2,
	Type.Endurance: -1,
	Type.Strategy: 4,


	Type.Longevity: -1,
	Type.Immunity: -1,
	Type.Simplicity: -1,
	Type.Barricade: 3,
	Type.Regeneration: 2,
}

func unlocked(perk: Type, perks: Dictionary) -> bool:
	match perk:
		Type.Humility:
			return not perks.has(Type.Pride)
		Type.Pride:
			return not perks.has(Type.Humility)
		
		Type.Musculation, Type.Longevity, Type.Immunity:
			return true
		
		Type.Diligence, Type.Patience, Type.Chastity:
			return perks.has(Type.Humility)
		Type.Charity:
			return perks.has(Type.Diligence) \
				and perks.has(Type.Patience) \
				and perks.has(Type.Chastity)
		Type.Temperance, Type.Gratitude:
			return perks.has(Type.Charity)
		
		Type.Lust:
			return perks.has(Type.Pride)
		Type.Gluttony, Type.Greed, Type.Envy:
			return perks.has(Type.Lust)
		Type.Sloth, Type.Wrath:
			return perks.has(Type.Gluttony) \
				and perks.has(Type.Greed) \
				and perks.has(Type.Envy)
		
		Type.Training:
			return perks.has(Type.Musculation)
		Type.Voltage, Type.Endurance:
			return perks.has(Type.Training)
		Type.Strategy:
			return perks.has(Type.Voltage) \
				and perks.has(Type.Endurance)
		
		Type.Simplicity, Type.Barricade:
			return perks.has(Type.Longevity) \
				and perks.has(Type.Immunity)
		Type.Regeneration:
			return perks.has(Type.Simplicity) \
				and perks.has(Type.Barricade)
		
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


func bought(perk: Perks.Type, stats: Stats) -> void:
	match perk:
		Perks.Type.Training:
			stats.ATK += Values.PERK_TRAINING
		Perks.Type.Longevity:
			stats.MAX_HP += Values.PERK_LONGEVITY
			stats.HP += Values.PERK_LONGEVITY
		Perks.Type.Immunity:
			stats.DEF += Values.PERK_IMMUNITY
			
		Perks.Type.Patience:
			stats.ATK -= Values.PERK_PATIENCE_NERF
			stats.HP += Values.PERK_PATIENCE_BOOST
			stats.MAX_HP += Values.PERK_PATIENCE_BOOST
		Perks.Type.Greed:
			stats.MAX_HP -= Values.PERK_GREED_NERF
			stats.HP = max(1, stats.HP - Values.PERK_GREED_NERF)
			stats.ATK += Values.PERK_GREED_BOOST
			
		Perks.Type.Gluttony:
			stats.ATK += Values.PERK_GLUTONNY
			Team.runes.append(Rune.Type.Curse)
		
		Perks.Type.Humility:
			Team.runes.append(Rune.Type.Angel)
		Perks.Type.Pride:
			Team.runes.append(Rune.Type.Demon)
		Perks.Type.Musculation:
			Team.runes.append(Rune.Type.Flex)
		Perks.Type.Voltage:
			Team.runes.append(Rune.Type.Thunder)
		Perks.Type.Strategy:
			Team.runes.append(Rune.Type.Loop)


func perk_to_border(state: State) -> Border.State:
	match state:
		State.Bought:
			return Border.State.White
		State.Available:
			return Border.State.Gray
		State.Locked, _:
			return Border.State.Dark
