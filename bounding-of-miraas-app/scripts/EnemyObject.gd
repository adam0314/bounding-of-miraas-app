class EnemyObject:
	
	const DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
	
	const STR_DIE_PER_ENEMY_POWER : int = 6
	const STR_CHANCE_FOR_DICE_SIGN : float = 0.9
	const STR_MAX_DIE_TO_ADD : int = 30
	
	var id : int
	var signn : int
	var name : String
	var dice : Array
	var player_allowed_dice : Array
	var type : int
	var phase : int
	
	func set_values(input_val : Dictionary):
		id = input_val["id"]
		signn = input_val["sign"]
		name = input_val["name"]
		player_allowed_dice = [] + input_val["allowed_dice"]
		dice = []
		type = input_val["type"]
		if type == Global.ENEMY_TYPE.Boss:
			phase = input_val["phase"]
		for die_val in input_val["dice"]:
			var d = DICE_OBJECT_SCRIPT.DiceObject.new()
			d.set_values(die_val)
			dice.append(d)
		pass
	
	func set_values_by_copy(input_enemy):
		id = input_enemy.id
		signn = input_enemy.signn
		name = input_enemy.name
		player_allowed_dice = [] + input_enemy.player_allowed_dice
		dice = []
		type = input_enemy.type
		if type == Global.ENEMY_TYPE.Boss:
			phase = input_enemy.phase
		for input_die in input_enemy.dice:
			var d = DICE_OBJECT_SCRIPT.DiceObject.new()
			d.set_values(input_die.to_string())
			dice.append(d)
		pass
	
	func add_new_die(die_data):
		var d = DICE_OBJECT_SCRIPT.DiceObject.new()
		d.set_values(die_data)
		dice.append(d)
		pass
	
	func advance_phase(reset = false):
		if type != Global.ENEMY_TYPE.Boss:
			print("lol you shouldnt be here")
			return
		dice = []
		phase += 1
		if phase == 2:
			for die_val in Global.get_enemy_for_id(id)["dice_phase_2"]:
				var d = DICE_OBJECT_SCRIPT.DiceObject.new()
				d.set_values(die_val)
				dice.append(d)
		if phase == 3:
			for die_val in Global.get_enemy_for_id(id)["dice_phase_3"]:
				var d = DICE_OBJECT_SCRIPT.DiceObject.new()
				d.set_values(die_val)
				dice.append(d)
		if reset:
			phase = 1
			dice = []
			for die_val in Global.get_enemy_for_id(id)["dice"]:
				var d = DICE_OBJECT_SCRIPT.DiceObject.new()
				d.set_values(die_val)
				dice.append(d)
	
	# Adds dice: at least a d2, and to a total value of enemy_power * 6
	func strengthten(enemy_power : int):
		if enemy_power == 0:
			return
		print("buff!")
		var total_die_to_add = enemy_power * STR_DIE_PER_ENEMY_POWER
		while total_die_to_add > 0:
			var available_die_values = range(2, min(total_die_to_add + 1, STR_MAX_DIE_TO_ADD + 1), 2)
			var die_to_add = available_die_values[randi() % available_die_values.size()]
			total_die_to_add -= die_to_add
			die_to_add = str(die_to_add)
			var use_enemy_type_for_die : bool = (randf() <= STR_CHANCE_FOR_DICE_SIGN)
			if use_enemy_type_for_die:
				die_to_add = Global.get_stringsign_for_sign(signn) + die_to_add
			else:
				var other_signs : Array = Global.DICE_SIGNS.duplicate().values()
				other_signs.erase(signn)
				die_to_add = Global.get_stringsign_for_sign(other_signs[0] if (randi() % 2) == 1 else other_signs[1]) + die_to_add
			add_new_die(die_to_add)
		pass
		