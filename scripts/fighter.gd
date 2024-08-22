class_name Fighter

enum Type { Ally, Chou, Piou }

enum Stat { HP, ATK, DEF }

var name: String
var type: Type
var stats: Stats = Stats.new()

var runes: Array[Rune.Type] = []

var id = -1

var intent = Actions.Type.Atk
var target = -1

var status: Array[Status] = []


func reset():
	id = Util.get_unique_id()
	stats.full_heal()
	status.clear()


func is_alive():
	return stats.HP > 0


func action(fight: Fight) -> Actions.Action:
	var act = Actions.Action.new()
	
	act.fighter = self
	act.type = intent
	act.target = target
	
	if type != Type.Ally:
		EnemyAI.pick_enemy_action(act, self, fight)
	
	return act


func damage(amount: int) -> void:
	if not is_alive():
		printerr("Dead fighters shouldn't be targeted")
		return

	var final_amount = amount
	for s in status:
		if s.type == Status.Type.Defense:
			# total block
			if s.value >= final_amount:
				s.value -= final_amount
				final_amount = 0
			# partial block
			if s.value < final_amount:
				final_amount -= s.value
				s.value = 0
	stats.HP -= final_amount
	await Team.message(Text.damage(self, final_amount))
	
	if stats.HP <= 0:
		stats.HP = 0
		status.clear()
		status.append(Actions.create_status(Status.Type.KO, 1))
		await Team.message(Text.ko(self))


func defend(amount: int) -> void:
	var existing = false
	var initial_def = 0
	var final_def = amount
	for s in status:
		if s.type == Status.Type.Defense:
			initial_def = s.value
			s.value += amount
			s.value = min(s.value, Values.MAX_DEF)
			final_def = s.value
			existing = true
	if not existing:
		status.append(Actions.create_status(Status.Type.Defense, amount))


func end_of_turn():
	var expired = []
	for i in range(len(status)):
		var s = status[i]
		if s.type == Status.Type.Defense:
			s.value = 0
		if s.is_expired():
			expired.append(i)
	expired.reverse()
	for i in expired:
		status.remove_at(i)


func add_mark(type: Status.Type, amount: int) -> void:
	for s in status:
		if s.type == type:
			s.value += amount
			s.value = min(s.value, Values.MAX_MARKS)
			return
	status.append(Actions.create_status(type, amount))
	

func get_status_value(type: Status.Type) -> int:
	for s in status:
		if s.type == type:
			return s.value
	return 0


func remove_status(type: Status.Type) -> void:
	var to_remove = -1
	for i in range(len(status)):
		if status[i].type == type:
			to_remove = i
			break
	if to_remove != -1:
		status.remove_at(to_remove)
