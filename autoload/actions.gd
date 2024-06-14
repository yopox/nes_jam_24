extends Node

enum Type { Atk, Spl, Def }


class Action:
	var type: Actions.Type
	var fighter: Fighter
	var target: int

	var target_all: bool = false
	var poison: int = 0
	var times: int = 1
	var power: float = 1.0
	var angel: int = 0
	var demon: int = 0	
	
	func _to_string() -> String:
		return "%s %s -> %s / power %s" % [type, fighter.name, target, power]


func boost_mult(percentage: int) -> float:
	return 1 + percentage / 100.0


func nerf_mult(percentage: int) -> float:
	return 1 - percentage / 100.0


func apply_rune(action: Action, rune: Rune.Type):
	match rune:
		Rune.Type.Flex:
			action.power *= boost_mult(Values.FLEX_BOOST)
		Rune.Type.Curse:
			action.power *= nerf_mult(Values.CURSE_NERF)
		Rune.Type.Poison:
			action.poison += Values.POISON
		Rune.Type.Thunder:
			action.power *= nerf_mult(Values.THUNDER_NERF)
			action.target_all = true
		Rune.Type.Loop:
			action.power *= nerf_mult(Values.LOOP_NERF)
			action.times += 1
		Rune.Type.Demon:
			action.demon += 1
			if action.type == Actions.Type.Def:
				action.power *= nerf_mult(Values.DEMON_NERF)
		Rune.Type.Angel:
			action.angel += 1
			if action.type == Actions.Type.Atk:
				action.power *= boost_mult(Values.ANGEL_BOOST)


func resolve_action(action: Action) -> void:
	var fighter = action.fighter
	var targets : Array[Fighter] = [Team.fight.get_fighter_by_id(action.target)]
	
	for _i in range(action.times):
		for target in targets:
			if not target.is_alive():
				if len(target) == 1:
					await Team.message("%s waits." % fighter.name)
				continue
			match action.type:
				Type.Atk:
					var atk = fighter.ATK * action.power
					# Demon: consume marks
					var demon = fighter.get_status_value(Status.Type.Demon)
					if action.demon > 0:
						atk = atk * boost_mult(demon * Values.DEMON_BOOST)
						fighter.remove_status(Status.Type.Demon)
					# Angel: add a mark
					if action.angel > 0:
						fighter.add_mark(Status.Type.Angel, action.angel)
					# Apply damage
					var damage = ceili(atk)
					await Team.message("%s attacks %s!" % [fighter.name, target.name])
					if damage > 0:
						await target.damage(damage)
				Type.Def:
					var def = action.fighter.DEF * action.power
					# Demon: add a mark
					if action.demon > 0:
						fighter.add_mark(Status.Type.Demon, action.demon)
					# Angel: consume marks
					var angel = fighter.get_status_value(Status.Type.Angel)					
					if action.angel > 0:
						fighter.remove_status(Status.Type.Angel)
						fighter.heal(angel * Values.ANGEL_HEAL)
					await target.defend(def)


func create_status(type: Status.Type, value: int) -> Status:
	var s = Status.new()
	s.type = type
	s.value = value
	return s