class PlayerManager:
	
	const INITIAL_DICE = [
		"6",
		"6",
		"6"
		]
		
	const INITIAL_HP : int = 3
	
	var player_id : int
	var player_name : String
	
	var player_ui_node : Control
	var next_player_manager
	
	var hp : int
	var dice = []
	var items = []
	
	# Nodes
	var fight_manager : Node
	var item_manager : Node
	
	
	var DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
	
	func set_initial_values(value):
		player_id = value["player_id"]
		hp = INITIAL_HP
		player_name = value["player_name"]
		next_player_manager = value["next_player_manager"]
		player_ui_node = value["player_ui_node"]
		item_manager = value["item_manager"]
		for die in INITIAL_DICE:
			add_new_die(die)
		player_ui_node.ui_needs_update_hp = true
		pass
		
	func add_new_die(input_string : String, input_item_id : int = -1):
		var die = create_new_die(input_string, input_item_id)
		dice.append(die)
		player_ui_node.ui_needs_update_dice = true
		pass
	
	func create_new_die(input_string, input_item_id):
		var die = DICE_OBJECT_SCRIPT.DiceObject.new()
		die.set_values(input_string)
		if input_item_id != -1: # die is added from an item
			die.set_item_id(input_item_id)
		return die
	
	func eval_and_add_new_die(die_value):
#		if ["+6", "6", "-6"].find(die_value) >= 0:
#			if player_has_item(12):
#			# special case - convert d6 to 3d2
#				die_value = die_value.rstrip("6") + "2"
#				add_new_die(die_value)
#				add_new_die(die_value)
#				add_new_die(die_value)
#				return
		add_new_die(die_value)
		pass
	
	func add_new_item(input_item_id):
		player_ui_node.ui_needs_update_items = true
		var item = item_manager.get_item_for_id(input_item_id)
		items.append(item)
		item_manager.erase_item_from_available(item)
		
		# Special case: if it is item 12 - change all d6 to 3 d2
#		if item.id == 12:
#			var dice_to_erase = []
#			for die in dice:
#				if die.dice_value == 6:
#					add_new_die(die.dice_sign + "2", die.item_id)
#					add_new_die(die.dice_sign + "2", die.item_id)
#					add_new_die(die.dice_sign + "2", die.item_id)
#					dice_to_erase.append(die)
#			for die in dice_to_erase:
#				dice.erase(die)
#			player_ui_node.ui_needs_update_dice = true
		if item.type == Global.ITEM_TYPES.Dice:
			#Adding dice
			for die_data in item.dice:
				add_new_die(die_data, item.id)
		pass
		
	func player_has_item(item_id) -> bool:
		for item in items:
			if item.id == item_id:
				return true
		return false
	
	func player_has_consumables() -> bool:
		for item in items:
			if item.type == Global.ITEM_TYPES.Consumable:
				return true
		return false
	
	func get_item(item_id):
		for item in items:
			if item.id == item_id:
				return item
		return {}
	
	func get_item_indexes() -> Array:
		var arr = []
		for item in items:
			arr.append(item.id)
		return arr
	
	func remove_item_by_id(item_id):
		remove_item(get_item(item_id))
		pass
	
	func remove_item(item):
		# Return the item to available pool
		item_manager.add_to_available_items(item)
		items.erase(item)
		if item.type == Global.ITEM_TYPES.Dice: # Need to delete dice as well
			var dice_to_erase = []
			for die in dice:
				if die.item_id == item.id: # die comes from that item
					dice_to_erase.append(die)
					player_ui_node.ui_needs_update_dice = true
			for die in dice_to_erase:
				dice.erase(die)
		player_ui_node.ui_needs_update_items = true
		pass
	
	func remove_items_by_id(id_arr):
		for id in id_arr:
			remove_item_by_id(id)
		pass
	
	func get_dice_by_copy():
		# This method checks if player has item 12
		
		var dice_out = [] + dice
		if player_has_item(12):
			var indexes_to_remove : Array = []
			for idx in range(dice_out.size()):
				var die = dice_out[idx]
				if die.dice_value == 6:
					indexes_to_remove.append(idx)
					dice_out.append(create_new_die(die.dice_sign + "2", die.item_id))
					dice_out.append(create_new_die(die.dice_sign + "2", die.item_id))
					dice_out.append(create_new_die(die.dice_sign + "2", die.item_id))
			for idx in indexes_to_remove:
				dice_out.remove(idx)
		return dice_out
	
	func lower_hp_by_1_and_ui_update():
		hp -= 1
		player_ui_node.ui_needs_update_hp = true
		pass
