extends Control

var current_player_manager

var ui_needs_update_dice : bool = false
var ui_needs_update_items : bool = false
var ui_needs_update_hp : bool = false

# Nodes

onready var player_name_ui = find_node("LabelPlayerName")
onready var hp_ui : SpinBox = find_node("HpSpinBox")
onready var dice_ui : ItemList = find_node("DirectDiceContainer")
onready var items_ui : ItemList = find_node("DirectItemContainer")
		
func _process(delta):
	if ui_needs_update_dice:
		ui_update_dice()
	if ui_needs_update_items:
		ui_update_items()
	if ui_needs_update_hp:
		ui_update_hp()
	pass

func update_all_data():
	ui_update_dice()
	ui_update_hp()
	ui_update_items()
	ui_update_player_name()

func ui_update_player_name():
	player_name_ui.text = current_player_manager.player_name
	pass

func ui_update_dice():
	ui_needs_update_dice = false
	if dice_ui.get_item_count() == 0:
		# Special case on initialization
		for die in current_player_manager.dice:
			dice_ui.add_item_and_its_data(die)
	else:
		# TODO : this is kinda inefficient
		dice_ui.clear()
		# new dice will be added
		for die in current_player_manager.dice:
			print("ui adding die")
			dice_ui.add_item_and_its_data(die)
	pass
#
func ui_update_items():
	ui_needs_update_items = false;
	var ui_items_count = items_ui.get_item_count()
	# delete ones if necessary
	for idx in range(ui_items_count):
		var ui_item_id = items_ui.get_item_metadata(idx)
		if current_player_manager.get_item_indexes().find(ui_item_id) == -1: # gui has item, player does not
			print("ui delete item")
			items_ui.remove_item(idx)
	# add new ones if necessary
	for item in current_player_manager.items:
		if not ui_has_item(item):
		# new item will be added
			print("gui adding item")
			items_ui.add_item_and_its_data(item)

	# TODO: Handle deletion
	pass

func ui_has_item(item) -> bool:
	var ui_items_count = items_ui.get_item_count()
	for idx in range(ui_items_count):
		if items_ui.get_item_metadata(idx) == item.id:
			return true
	return false

func ui_update_hp():
	hp_ui.value = current_player_manager.hp
	pass

func _on_PopupItem_popup_add_new_item(item_id):
	current_player_manager.add_new_item(item_id)
	pass

func _on_HpSpinBox_value_changed(value):
	current_player_manager.hp = int(floor(value))
	pass # Replace with function body.


func _on_ButtonFightEnemy_pressed():
	get_parent().switch_tabs({"to_tab": "fight_base"})
	pass # Replace with function body.


func _on_ButtonEndTurn_pressed():
	get_parent().switch_players(current_player_manager.next_player_manager)
	pass # Replace with function body.

func _on_PopupDice_popup_add_new_dice(val):
	current_player_manager.add_new_die(val)
	pass


func _on_ButtonRemoveItem_pressed():
	var selected_idxs = items_ui.get_selected_items()
	for idx in selected_idxs:
		var item_id = items_ui.get_item_metadata(idx)
		current_player_manager.remove_item_by_id(item_id)
	pass # Replace with function body.
