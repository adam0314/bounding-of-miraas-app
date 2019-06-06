extends Node

# Main fight manager

# Vars

var current_enemy = null
var player_dice_throws : Array
var player_score : int
var enemy_dice_throws : Array
var enemy_score : int
var selected_items_dicts : Array

# Nodes
var player_manager
var other_player_manager
var enemy_manager : Node
var fight_base_ui : Control
var fight_result_ui : Control

func _ready():
	pass

func set_initial_values(val):
	enemy_manager = val["enemy_manager"]
	fight_base_ui = val["fight_base_ui_node"]
	fight_result_ui = val["fight_result_ui_node"]
	pass
	
func update_enemy(id):
	current_enemy = enemy_manager.enemies[id]
	fight_base_ui.ui_need_update_enemy = true
	pass

func clear_enemy():
	current_enemy = null
	fight_base_ui.clear_enemy()

func add_selected_items_dict(dict):
	selected_items_dicts.append(dict)
	pass

func fight():
	# for now only supports fighting normal enemies - not players
	selected_items_dicts = []
	
	if current_enemy == null:
		print("no enemy")
		return
	print("fight!")
	# else: commence fight!
	fight_base_ui.commence_fight()
	
	#player throws
	player_dice_throws = []
	var player_dice = player_manager.get_dice_by_copy() # asserts for item 12
	for die in player_dice:
		#print("throw player die " + die.get_string_representation()) 
		if current_enemy.player_allowed_dice.find(die.dice_sign_enum) >= 0:
			#throwing only dice which are allowed by enemy
			player_dice_throws.append(die.throw_return_with_sign())
	#enemy throws
	enemy_dice_throws = []
	enemy_score = 0
	for die in current_enemy.dice:
		enemy_dice_throws.append(die.throw_return_with_sign())
	enemy_score = get_throw_sum(enemy_dice_throws)
	
	# apply passives
	
	if player_manager.player_has_item(10):
		# each even throw +1
		apply_item_10()
	if player_manager.player_has_item(11):
		# each odd throw -1
		apply_item_11()
	if player_manager.player_has_item(14):
		# each d2 throw *2
		apply_item_14()

	# Sum throws, apply item 13 if player has it

	player_score = get_throw_sum(player_dice_throws)
	if player_manager.player_has_item(13):
		apply_item_13()
	
	# End of passives
	
	# Print throws
	ui_print_throws()
	
	# now, loop after confirm button is pressed
	fight_base_ui.end_fight = false
	var used_item_18 = false
	while true:
		yield(fight_base_ui, "use_item_or_end_fight")
		if fight_base_ui.end_fight == true:
			print("end fight")
			break
		print("use item")
		# Start of actives
		for dict in selected_items_dicts:
			if dict["id"] == 17:
				apply_item_17()
			if dict["id"] == 16:
				apply_item_16()
			if dict["id"] == 15:
				apply_item_15()
			ui_print_throws()
			if dict["id"] == 18:
				used_item_18 = true
			dict["player_manager"].remove_item_by_id(dict["id"])
			dict["id"] = -1 #easier than deleting
		
		# End of actives
	var win = calculate_fight_outcome()
	if win:
		# navigate to fight result tab
		fight_base_ui.get_parent().switch_tabs({
			"to_tab": "fight_result",
			"win": true,
			"has_item_18": used_item_18,
			"has_item_19": player_manager.player_has_item(19)})
	else:
		# navigate to fight result tab
		if not used_item_18:
			player_manager.lower_hp_by_1_and_ui_update()
		fight_base_ui.get_parent().switch_tabs({
			"to_tab": "fight_result",
			"win": false,
			"has_item_18": used_item_18,
			"has_item_19": player_manager.player_has_item(19)})
		# lost
	# Clear up after a fight and switch tabs
	#fight_base_ui.get_parent().switch_tabs({"to_tab": "fight_result"})
	#fight_base_ui.get_parent().switch_tabs({"to_tab": "player"})
	clear_enemy()
	fight_base_ui.clear_all_ui()
	pass

func get_throw_sum(throws) -> int:
	var sum = 0
	for t in throws:
		sum += t["value"]
	return sum

func apply_item_10():
	# each even throw +1
	for throw in player_dice_throws:
		if int(abs(throw["value"])) % 2 == 0:
			throw["value"] += 1
	pass

func apply_item_11():
	# each odd throw -1
	for throw in player_dice_throws:
		if int(abs(throw["value"])) % 2 == 1:
			throw["value"] -= 1
	pass

func apply_item_14():
	# each d2 throw *2
	for throw in player_dice_throws:
		if throw["dice_val"] == 2:
			throw["value"] *= 2
	pass

func apply_item_13():
	if int(abs(player_score)) % 2 == 0:
		player_score *= 2
	else:
		player_score /= 2
	pass
	
func apply_item_15():
	player_score = int(abs(player_score))
	pass

func apply_item_16():
	player_score = player_score * -1
	pass

func apply_item_17():
	# Simulate rolling one die
	# Takes sign from enemy
	player_dice_throws = []
	var sim_die_value : int = 0
	for die in player_manager.dice:
		sim_die_value += die.to_int_val()
	var result = (randi() % sim_die_value) + 1
	if current_enemy.type == Global.DICE_SIGNS.Negative:
		player_dice_throws.append({"value": result * (-1), "sign": current_enemy.type, "dice_val" : sim_die_value})
	else:
		player_dice_throws.append({"value": result, "sign": current_enemy.type, "dice_val" : sim_die_value})
	player_score = get_throw_sum(player_dice_throws)
	pass

func ui_print_throws():
	fight_base_ui.print_throws({
		"player_throws": player_dice_throws,
		"player_score": player_score,
		"enemy_throws": enemy_dice_throws,
		"enemy_score": enemy_score
	})
	pass


func calculate_fight_outcome() -> bool:
	if current_enemy.type == Global.DICE_SIGNS.Negative:
		return player_score <= enemy_score
	else:
		return player_score >= enemy_score
	pass