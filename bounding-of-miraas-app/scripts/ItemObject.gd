class ItemObject:
	
	var id : int
	var name : String
	var type : int
	var effect : String
	var dice : Array
	
	func set_values(input_val):
		id = input_val["id"]
		name = input_val["name"]
		type = input_val["type"]
		if type != Global.ITEM_TYPES.Dice:
			effect = input_val["effect"]
		else:
			effect = PoolStringArray(input_val["dice"]).join(" ")
			dice = input_val["dice"]
	
	func to_string() -> String:
		return name