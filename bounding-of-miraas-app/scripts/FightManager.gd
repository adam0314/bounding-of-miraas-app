extends Control

# Main fight manager

# Vars

var current_enemy = null
var ui_need_update_enemy : bool = false
var player_dice_throws : Array
var player_throw_sum : int

# Nodes
var player_manager : Control
var enemy_manager : Node
const ENEMY_OBJECT_SCRIPT = preload("res://scripts/EnemyObject.gd")
onready var ui_enemy_container = $Mcont/Vbox/Hbox/EnemyDataContainer
onready var ui_fight_log : RichTextLabel = $Mcont/Vbox/Hbox2/PanelContainer/FightLog
onready var ui_item_list : ItemList = $Mcont/Vbox/Hbox2/VBoxContainer/CenterContainer2/ItemList
onready var ui_fight_button : Button = $Mcont/Vbox/Hbox/EnemyRandomizeButtonContainer/VBoxContainer/CenterContainer2/FightButton
onready var enemy_option_button : OptionButton = find_node("EnemyName")

func _ready():
	pass

func setup_enemies_to_button():
	for id in enemy_manager.get_enemies_id():
		enemy_option_button.add_item(str(id))
	pass

func _process(delta):
	if ui_need_update_enemy:
		ui_need_update_enemy = false
		ui_enemy_container.ui_update_enemy(current_enemy)
	pass
	
func update_enemy(id):
	current_enemy = enemy_manager.enemies[id]
	ui_need_update_enemy = true
	pass

func fight():
	if current_enemy == null:
		print("no enemy")
		return
	
	ui_fight_button.disabled = true
		
	#player throws
	player_dice_throws = []
	for die in player_manager.dice:
		#print("throw player die " + die.get_string_representation()) 
		if current_enemy.player_allowed_dice.find(die.dice_sign_enum) >= 0:
			#throwing only dice which are allowed by enemy
			player_dice_throws.append(die.throw_return_with_sign())
	#enemy throws
	var enemy_dice_throws = []
	for die in current_enemy.enemy_dice:
		enemy_dice_throws.append(die.throw_return_with_sign())
	
	# Clear log
	
	ui_fight_log.clear_log()
	
	# Print initial throws
	
	ui_fight_log.print_line("Rzuty gracza:")
	ui_fight_log.print_throws(player_dice_throws, get_throw_sum(player_dice_throws))
	
	# Apply items to throws
	
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
	
	player_throw_sum = get_throw_sum(player_dice_throws)
	if player_manager.player_has_item(13):
		apply_item_13()
	var enemy_throw_sum = get_throw_sum(enemy_dice_throws)
	ui_fight_log.print_line("Rzuty gracza po uzyciu pasywek:")
	ui_fight_log.print_throws(player_dice_throws, player_throw_sum)
	ui_fight_log.print_line("Rzuty wroga:")
	ui_fight_log.print_throws(enemy_dice_throws, enemy_throw_sum)
	
	# Use consumables if needed
	# Consumable #17 has to re_roll player throws
	
	gui_update_consumable_items()
	if player_manager.player_has_consumables():
		ui_fight_log.print_line("Wybierz uzywki z listy")
		yield($Mcont/Vbox/Hbox2/VBoxContainer/CenterContainer/UseItemButton, "pressed")
		
		var chosen_consumables : Array = get_selected_consumable_items()
		if chosen_consumables.size() > 0:
			if contains_item(chosen_consumables, 17):
				# sum all dice and throw as one, sign inferred from enemy
				apply_item_17()
			if contains_item(chosen_consumables, 15):
				# absolute value of sum
				apply_item_15()
			if contains_item(chosen_consumables, 16):
				# value of sum * -1
				apply_item_16()
			for item in chosen_consumables:
				player_manager.remove_item(item)
		else:
			ui_fight_log.print_line("Nie wybrano zadnej uzywki")
		
	
	# Get outcome and use passives after fight (19)
	
	ui_fight_log.print_line("\nOstateczny rzut gracza:")
	ui_fight_log.print_throws(player_dice_throws, player_throw_sum)
	ui_fight_log.print_line("Rzut wroga:")
	ui_fight_log.print_throws(enemy_dice_throws, enemy_throw_sum)
	
	var win : bool = calculate_fight_outcome(enemy_throw_sum)
	if win:
		ui_fight_log.print_line("Wygrywasz!")
		if player_manager.player_has_item(19):
			ui_fight_log.print_line("Otrzymujesz 1 monete (przedmiot 500+ <19>)")
	else:
		ui_fight_log.print_line("Przegrana")
		if player_manager.player_has_item(18):
			ui_fight_log.print_line("Nie tracisz zdrowia (przedmiot Duzo promili <18>)")
	
	ui_fight_button.disabled = false
	
	pass

func contains_item(items, item_id) -> bool:
	for item in items:
		if item.id == item_id:
			return true
	return false

func get_throw_sum(throws) -> int:
	var sum = 0
	for t in throws:
		sum += t["value"]
	return sum

func gui_update_consumable_items():
	ui_item_list.clear()
	for item in player_manager.items:
		if item.type == Global.ITEM_TYPES.Consumable:
			print("add consumable")
			ui_item_list.add_item(str(item.id))
	pass

func get_selected_consumable_items() -> Array:
	var items = []
	for index in ui_item_list.get_selected_items():
		items.append(player_manager.get_item(int(ui_item_list.get_item_text(index))))
	return items
	
func apply_item_10():
	# each even throw +1
	for throw in player_dice_throws:
		if int(abs(throw["value"])) % 2 == 0:
			throw["value"] += 1
	ui_fight_log.print_line("Uzywasz przedmiotu Kupione lajki (10)")
	pass
	
func apply_item_11():
	# each odd throw -1
	for throw in player_dice_throws:
		if int(abs(throw["value"])) % 2 == 1:
			throw["value"] -= 1
	ui_fight_log.print_line("Uzywasz przedmiotu Pozytywna reforma (11)")
	pass

func apply_item_14():
	# each d2 throw *2
	for throw in player_dice_throws:
		if throw["dice_val"] == 2:
			throw["value"] *= 2
	ui_fight_log.print_line("Uzywasz przedmiotu Sztuczka z moneta (14)")
	pass
	
func apply_item_13():
	if int(abs(player_throw_sum)) % 2 == 0:
		player_throw_sum *= 2
	else:
		player_throw_sum /= 2
	ui_fight_log.print_line("Uzywasz przedmiotu Loteria (13)")
	pass

func apply_item_15():
	player_throw_sum = int(abs(player_throw_sum))
	ui_fight_log.print_line("Uzywasz przedmiotu Jestes zwyciezca (15)")
	pass

func apply_item_16():
	player_throw_sum = player_throw_sum * -1
	ui_fight_log.print_line("Uzywasz przedmiotu Punkt widzenia (16)")
	pass

func apply_item_17():
	# Simulate rolling one die
	# Takes sign from enemy
	player_dice_throws = []
	var sim_die_value : int = 0
	for die in player_manager.dice:
		sim_die_value += die.to_int_val()
	var result = (randi() % sim_die_value) + 1
	if current_enemy.enemy_type == Global.DICE_SIGNS.Negative:
		player_dice_throws.append({"value": result * (-1), "sign": current_enemy.enemy_type, "dice_val" : sim_die_value})
	else:
		player_dice_throws.append({"value": result, "sign": current_enemy.enemy_type, "dice_val" : sim_die_value})
	player_throw_sum = get_throw_sum(player_dice_throws)
	ui_fight_log.print_line("Uzywasz przedmiotu All in (17)")
	pass

func calculate_fight_outcome(enemy_throw_sum):
	if current_enemy.enemy_type == Global.DICE_SIGNS.Negative:
		return player_throw_sum <= enemy_throw_sum
	else:
		return player_throw_sum >= enemy_throw_sum
	pass

func _on_FightButton_pressed():
	fight()
	pass # Replace with function body.


func _on_ButtonBackToPlayer_pressed():
	get_parent().switch_tabs(player_manager.this_player_tab_id)
	pass # Replace with function body.


func _on_ButtonEndTurn_pressed():
	get_parent().switch_tabs(player_manager.next_player_tab_id)
	pass # Replace with function body.

func _on_EnemyName_item_selected(ID):
	update_enemy(ID)
	pass # Replace with function body.
