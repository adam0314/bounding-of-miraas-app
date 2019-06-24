extends Node

# Main fight manager

# Consts

const WIN_DIE_CREATE_CHANCE = 0.3 # 30%
const MAXX_DIE_TO_ADD = 4

# Vars

var current_enemy = null
# IMPORTANT: current enemy is a COPY of enemy from enemy_manager, not a reference!

var player_dice_throws : Array
var player_score : int
var enemy_dice_throws : Array
var enemy_score : int
var selected_items_dicts : Array

var end_level = false

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
	var enemy_power : int = player_manager.enemy_power
	current_enemy = enemy_manager.get_enemy_copy_by_id_and_strengthten(id, enemy_power)
	fight_base_ui.ui_need_update_enemy = true
	pass

func update_enemy_to_power():
	if current_enemy != null:
		update_enemy(current_enemy.id)
	pass

func clear_enemy():
	current_enemy = null
	fight_base_ui.clear_enemy()

func add_selected_items_dict(dict):
	selected_items_dicts.append(dict)
	pass

func fight():
	selected_items_dicts = []
	end_level = false
	
	if current_enemy == null:
		print("no enemy")
		return
	print("fight!")
	var fighting_another_player = (current_enemy.type == Global.ENEMY_TYPE.Player)
	#commence fight!
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
		player_dice_throws = apply_item_10(player_dice_throws)
	if player_manager.player_has_item(11):
		# each odd throw -1
		player_dice_throws = apply_item_11(player_dice_throws)
	if player_manager.player_has_item(14):
		# each d2 throw *2
		player_dice_throws = apply_item_14(player_dice_throws)
	
	if fighting_another_player:
		if player_manager.player_has_item(10):
		# each even throw +1
			enemy_dice_throws = apply_item_10(enemy_dice_throws)
		if player_manager.player_has_item(11):
		# each odd throw -1
			enemy_dice_throws = apply_item_11(enemy_dice_throws)
		if player_manager.player_has_item(14):
		# each d2 throw *2
			enemy_dice_throws = apply_item_14(enemy_dice_throws)

	# Sum throws, apply item 13 if player has it

	player_score = get_throw_sum(player_dice_throws)
	if player_manager.player_has_item(13):
		player_score = apply_item_13(player_score)
	if fighting_another_player:
		enemy_score = get_throw_sum(enemy_dice_throws)
		if other_player_manager.player_has_item(13):
			enemy_score = apply_item_13(enemy_score)
	
	# End of passives
	
	# Print throws
	ui_print_throws()
	
	# now, loop after confirm button is pressed
	fight_base_ui.end_fight = false
	var used_item_18 = false
	var other_player_used_item_18 = false
	while true:
		yield(fight_base_ui, "use_item_or_end_fight")
		if fight_base_ui.end_fight == true:
			print("end fight")
			break
		print("use item")
		# Start of actives
		
		if not fighting_another_player:
			for dict in selected_items_dicts:
				if dict["id"] == 17:
					var after17 = apply_item_17(player_dice_throws, player_score)
					player_dice_throws = after17["throws"]
					player_score = after17["score"]
				if dict["id"] == 16:
					player_score = apply_item_16(player_score)
				if dict["id"] == 15:
					player_score = apply_item_15(player_score)
				ui_print_throws()
				if dict["id"] == 18:
					used_item_18 = true
				dict["player_manager"].remove_item_by_id(dict["id"])
				dict["id"] = -1 #easier than deleting
		else:
			# Here we have to differentiate, which player chose which items
			for dict in selected_items_dicts:
				if dict["player_manager"].player_id == player_manager.player_id:
					# current player chose that item
					if dict["id"] == 17:
						var after17 = apply_item_17(player_dice_throws, player_score)
						player_dice_throws = after17["throws"]
						player_score = after17["score"]
					if dict["id"] == 16:
						player_score = apply_item_16(player_score)
					if dict["id"] == 15:
						player_score = apply_item_15(player_score)
					ui_print_throws()
					if dict["id"] == 18:
						used_item_18 = true
					if dict["id"] > -1:
						player_manager.remove_item_by_id(dict["id"])
					dict["id"] = -1 #easier than deleting
				else:
					# other player
					if dict["id"] == 17:
						var after17 = apply_item_17(enemy_dice_throws, enemy_score, true)
						enemy_dice_throws = after17["throws"]
						enemy_score = after17["score"]
					if dict["id"] == 16:
						enemy_score = apply_item_16(enemy_score)
					if dict["id"] == 15:
						enemy_score = apply_item_15(enemy_score)
					ui_print_throws()
					if dict["id"] == 18:
						other_player_used_item_18 = true
					if dict["id"] > -1:
						other_player_manager.remove_item_by_id(dict["id"])
					dict["id"] = -1 #easier than deleting
		
		# End of actives
	# End of choosing loop
	
	# Calculate outcome
		
	var win = calculate_fight_outcome()
	if win:
		# special case: if it was boss, update that bithh
		if current_enemy.type == Global.ENEMY_TYPE.Boss:
			if current_enemy.phase == 3:
				# todo: end current level
				end_level = true
			enemy_manager.advance_phase(current_enemy)
		# if win, 30% chance of receiving random dice
		var die_data = roll_for_die_and_add()
		
		# if fighting player, he lowers hp by 1 - ONLY if no item is taken
		# This is handled in Fight result ui node
		
		# navigate to fight result tab
		fight_base_ui.get_parent().switch_tabs({
			"to_tab": "fight_result",
			"win": true,
			"has_item_19": player_manager.player_has_item(19),
			"created_die": die_data,
			"fighting_another_player": fighting_another_player,
			"other_player_can_lose_hp" : (not other_player_used_item_18)})
	else: # lose
		# navigate to fight result tab
		if not used_item_18:
			if current_enemy.type == Global.ENEMY_TYPE.Boss:
				# boss takes 2 hp
				player_manager.lower_hp_by_2_and_ui_update()
			else:
				player_manager.lower_hp_by_1_and_ui_update()
		fight_base_ui.get_parent().switch_tabs({
			"to_tab": "fight_result",
			"win": false,
			"has_item_18": used_item_18})
		# lost
	clear_enemy()
	fight_base_ui.clear_all_ui()
	if end_level:
		get_tree().get_nodes_in_group("main")[0].end_level()
	pass

func roll_for_die_and_add() -> String:
	# rolls for a die and adds to player
	# die has values between 2 and MAX_DIE_TO_ADD
	var die_data = ""
	if current_enemy.type == Global.ENEMY_TYPE.Normal:
		# only normal enemies drop dice
		if randf() <= WIN_DIE_CREATE_CHANCE:
			var siggnn = ["", "-", "+"][randi() % 3]
			randomize()
			var max_die_to_add = MAXX_DIE_TO_ADD - 1
			var die_value_randomized = randi() % max_die_to_add
			var die_value = str(die_value_randomized + 2)
			die_data = siggnn + die_value 
			player_manager.add_new_die(die_data)
	return die_data

func get_throw_sum(throws) -> int:
	var sum = 0
	for t in throws:
		sum += t["value"]
	return sum

func apply_item_10(throws):
	# each even throw +1
	for throw in throws:
		if int(abs(throw["value"])) % 2 == 0:
			throw["value"] += 1
	return throws

func apply_item_11(throws):
	# each odd throw -1
	for throw in throws:
		if int(abs(throw["value"])) % 2 == 1:
			throw["value"] -= 1
	return throws

func apply_item_14(throws):
	# each d2 throw *2
	for throw in throws:
		if throw["dice_val"] == 2:
			throw["value"] *= 2
	return throws

func apply_item_13(score):
	if int(abs(score)) % 2 == 0:
		score *= 2
	else:
		score /= 2
	return score
	
func apply_item_15(score):
	score = int(abs(score))
	return score

func apply_item_16(score):
	score = score * -1
	return score

func apply_item_17(throws, score, use_other_player_manager = false):
	# Simulate rolling one die
	# Takes sign from enemy
	throws = []
	var sim_die_value : int = 0
	for die in (other_player_manager.dice if use_other_player_manager else player_manager.dice):
		sim_die_value += die.to_int_val()
	var result = (randi() % sim_die_value) + 1
	if current_enemy.signn == Global.DICE_SIGNS.Negative:
		throws.append({"value": result * (-1), "sign": current_enemy.signn, "dice_val" : sim_die_value})
	else:
		throws.append({"value": result, "sign": current_enemy.signn, "dice_val" : sim_die_value})
	score = get_throw_sum(throws)
	return {"throws": throws, "score": score}

func ui_print_throws():
	fight_base_ui.print_throws({
		"player_throws": player_dice_throws,
		"player_score": player_score,
		"enemy_throws": enemy_dice_throws,
		"enemy_score": enemy_score
	})
	pass

func calculate_fight_outcome() -> bool:
	if current_enemy.signn == Global.DICE_SIGNS.Negative:
		return player_score <= enemy_score
	else:
		return player_score >= enemy_score
	pass