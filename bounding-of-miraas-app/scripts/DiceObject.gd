class DiceObject:

	var dice_value : int
	var dice_sign_enum : int
	var dice_sign : String
	
	func set_values(input_str):
		if input_str.ends_with("+"):
			dice_value = int(input_str.trim_suffix("+"))
			dice_sign_enum = Global.DICE_SIGNS.Positive
			dice_sign = "+"
		elif input_str.ends_with("-"):
			dice_value = int(input_str.trim_suffix("-"))
			dice_sign_enum = Global.DICE_SIGNS.Negative
			dice_sign = "-"
		else:
			dice_value = int(input_str)
			dice_sign_enum = Global.DICE_SIGNS.Neutral
			dice_sign = ""
		pass