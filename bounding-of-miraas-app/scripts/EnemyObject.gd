class EnemyObject:
	
	const DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
	
	var id : int
	var type : int
	var name : String
	var dice : Array
	var player_allowed_dice : Array
	
	func set_values(input_val : Dictionary):
		id = input_val["id"]
		type = input_val["type"]
		name = input_val["name"]
		player_allowed_dice = [] + input_val["allowed_dice"]
		dice = []
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