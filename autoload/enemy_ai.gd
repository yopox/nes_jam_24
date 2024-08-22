extends Node


func pick_enemy_action(action: Actions.Action, fighter: Fighter, fight: Fight) -> void:
	match fighter.type:
		
		Fighter.Type.Chou:
			if fighter.stats.hp_geq(50):
				action.type = Actions.Type.Atk
				action.target = fight.get_random_ally().id
			else:
				action.type = Actions.Type.Def
				action.target = fighter.id
		
		Fighter.Type.Piou:
			action.type = Actions.Type.Def
			action.target = fight.get_weakest_enemy().id
		
		_:
			printerr("No AI for enemy %" % fighter.type)
