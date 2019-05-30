class EnemyObject:
	
	const DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
	
	var enemy_id : int
	var enemy_type : int
	var enemy_name : String
	var enemy_dice : Array
	var player_allowed_dice : Array
	
	func set_values(input_val : Dictionary):
		enemy_id = input_val["id"]
		enemy_type = input_val["type"]
		enemy_name = input_val["name"]
		player_allowed_dice = [] + input_val["allowed_dice"]
		enemy_dice = []
		for die_val in input_val["dice"]:
			var d = DICE_OBJECT_SCRIPT.DiceObject.new()
			d.set_values(die_val)
			enemy_dice.append(d)
		pass