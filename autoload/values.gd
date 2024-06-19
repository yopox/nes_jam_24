extends Node

const all_runes = [
	Rune.Type.Blank, Rune.Type.Flex, Rune.Type.Poison, Rune.Type.Thunder, Rune.Type.Loop,
	Rune.Type.Demon, Rune.Type.Angel, Rune.Type.Curse
]

# CONSTANTS
const FLEX_BOOST: int = 50
const THUNDER_NERF: int = 30
const CURSE_NERF: int = 35
const DEMON_BOOST: int = 50
const DEMON_NERF: int = 50
const ANGEL_BOOST: int = 25
const ANGEL_HEAL: int = 5
const LOOP_NERF: int = 20
const POISON: int = 2

const MAX_DEF: int = 99
const MAX_MARKS: int = 9

const PERK_TRAINING: int = 2
const PERK_IMMUNITY: int = 2
const PERK_LONGEVITY: int = 5
const PERK_PATIENCE_NERF: int = 2
const PERK_PATIENCE_BOOST: int = 5
const PERK_GREED_NERF: int = 5
const PERK_GREED_BOOST: int = 4
const PERK_GLUTONNY: int = 5
