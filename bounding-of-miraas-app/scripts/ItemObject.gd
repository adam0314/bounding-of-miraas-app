class ItemObject:
	
	var item_id : int
	var item_type : int
	var item_effect_description : String
	
	func set_values(input_array):
		item_id = input_array[0]
		item_type = input_array[1]
		item_effect_description = input_array[2]