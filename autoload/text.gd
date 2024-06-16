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
