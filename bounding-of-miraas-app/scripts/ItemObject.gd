class ItemObject:
	
	var id : int
	var name : String
	var type : int
	var effect : String
	var dice : Array
	var usable_in_fight : bool
	
	func set_values(input_val: Dictionary):
		id = input_val["id"]
		name = input_val["name"]
		type = input_val["type"]
		if type != Global.ITEM_TYPES.Dice:
			effect = input_val["effect"]
		else:
			effect = PoolStringArray(input_val["dice"]).join(" ")
			dice = input_val["dice"]
		if input_val.has("usable_in_fight"):
			usable_in_fight = input_val["usable_in_fight"]
		else:
			usable_in_fight = true
	
	func to_string() -> String:
		return name