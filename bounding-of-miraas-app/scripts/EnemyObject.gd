class EnemyObject:
	
	const DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
	
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
	
	func add_new_die(die_data):
		var d = DICE_OBJECT_SCRIPT.DiceObject.new()
		d.set_values(die_data)
		dice.append(d)
		pass
	
	func advance_phase():
		if type != Global.ENEMY_TYPE.Boss:
			print("lol you shouldnt be here")
			return
		dice = []
		phase += (phase + 1)
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
		