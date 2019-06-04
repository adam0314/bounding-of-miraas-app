class DiceObject:

	var dice_value : int
	var dice_sign_enum : int
	var dice_sign : String
	var item_id : int = -1
	
	func set_values(input_str : String):
		if input_str.begins_with("+"):
			dice_value = int(input_str.trim_prefix("+"))
			dice_sign_enum = Global.DICE_SIGNS.Positive
			dice_sign = "+"
		elif input_str.begins_with("-"):
			dice_value = int(input_str.trim_prefix("-"))
			dice_sign_enum = Global.DICE_SIGNS.Negative
			dice_sign = "-"
		else:
			dice_value = int(input_str)
			dice_sign_enum = Global.DICE_SIGNS.Neutral
			dice_sign = ""
		pass
	
	func set_item_id(id):
		item_id = id
		pass
		
	func to_string() -> String:
		return str(dice_sign) + str(dice_value)
	
	func to_int_val() -> int:
		if dice_sign_enum == Global.DICE_SIGNS.Negative:
			return dice_value * (-1)
		else:
			return dice_value
		
	func throw() -> int:
		var throw_value = (randi() % dice_value) + 1
		if dice_sign_enum == Global.DICE_SIGNS.Negative:
			return throw_value * (-1)
		else:
			return throw_value
			
	func throw_return_with_sign() -> Dictionary:
		var throw_value = (randi() % dice_value) + 1
		if dice_sign_enum == Global.DICE_SIGNS.Negative:
			return {"value": throw_value * (-1), "sign": dice_sign_enum, "dice_val" : dice_value}
		else:
			return {"value": throw_value, "sign": dice_sign_enum, "dice_val" : dice_value}