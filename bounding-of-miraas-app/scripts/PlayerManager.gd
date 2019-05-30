extends Control

# Main player data control manager

# Constants

const INITIAL_DICE = [
	"6",
	"-8",
	"+20"
	]
	
const INITIAL_HP : int = 5
	
# Control vars

var gui_needs_update_dice = false
var gui_needs_update_items = false

# Stats

var hp : int # TODO maybe change it to float
var dice = []
var items = []

# Nodes
var fight_manager : Control

onready var hp_node = $PlayerData/PlayerHealthContainer/HBoxContainer/HpSpinBox

var DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
var DICE_GUI_NODE = preload("res://scenes/DiceGraphic.tscn")
onready var dice_gui_node = $PlayerData/PlayerDicesContainer/ScrollContainer/DirectDiceContainer

var ITEM_OBJECT_SCRIPT = preload("res://scripts/ItemObject.gd")
var ITEM_GUI_NODE = preload("res://scenes/ItemGraphic.tscn")
onready var item_gui_node = $PlayerData/PlayerItemsContainer/ScrollContainer/DirectItemContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = INITIAL_HP
	gui_update_hp()
	for die in INITIAL_DICE:
		add_new_die(die)
	pass # Replace with function body
	
func _process(delta):
	if gui_needs_update_dice:
		gui_update_dices()
	if gui_needs_update_items:
		gui_update_items()
	pass
	
func gui_update_dices():
	gui_needs_update_dice = false;
	var gui_dice = dice_gui_node.get_children()
	if gui_dice.size() == 0:
		# Special case on initialization
		for die in dice:
			var d = DICE_GUI_NODE.instance()
			d.set_nodes_and_parameters(die)
			dice_gui_node.add_child(d)
	else:
		# TODO : this is kinda inefficient
		for ui_die in gui_dice:
			ui_die.queue_free()
		# new dice will be added
		for die in dice:
			print("adding die")
			var d = DICE_GUI_NODE.instance()
			d.set_nodes_and_parameters(die)
			dice_gui_node.add_child(d)
			
	# TODO: Handle deletion
	pass
	
func gui_update_items():
	gui_needs_update_items = false;
	var gui_items = item_gui_node.get_children()
	if gui_items.size() < items.size():
		# new items will be added
		for ind in range(gui_items.size(), items.size()):
			print("adding item")
			var it = ITEM_GUI_NODE.instance()
			it.set_nodes_and_parameters(items[ind])
			item_gui_node.add_child(it)
			
	# TODO: Handle deletion
	pass

func gui_update_hp():
	hp_node.value = hp
	pass
	
func add_new_die(input_string : String):			
	var die = DICE_OBJECT_SCRIPT.DiceObject.new()
	die.set_values(input_string)
	dice.append(die)
	gui_needs_update_dice = true
	pass

func _on_PopupDice_popup_add_new_dice(die_value):
	if ["+6", "6", "-6"].find(die_value) >= 0:
		if player_has_item(12):
		# special case - convert d6 to 3d2
			die_value = die_value.rstrip("6") + "2"
			add_new_die(die_value)
			add_new_die(die_value)
			add_new_die(die_value)
			return
	add_new_die(die_value)
	pass

func add_new_item(input_item_id):
	var item = ITEM_OBJECT_SCRIPT.ItemObject.new()
	item.set_values(Global.get_item_values_for_id(input_item_id))
	items.append(item)
	gui_needs_update_items = true
	
	# Special case: if it is item 12 - change all d6 to 3 d2
	if input_item_id == 12:
		for die in dice:
			if die.dice_value == 6:
				add_new_die(die.dice_sign + "2")
				add_new_die(die.dice_sign + "2")
				add_new_die(die.dice_sign + "2")
				dice.erase(die)
				gui_needs_update_dice = true
	pass
	
func player_has_item(item_id) -> bool:
	for item in items:
		if item.item_id == item_id:
			return true
	return false

func player_has_consumables() -> bool:
	for item in items:
		if item.item_type == Global.ITEM_TYPES.Consumable:
			return true
	return false

func get_item(item_id):
	for item in items:
		if item.item_id == item_id:
			return item
	return {}

func remove_item(item):
	items.erase(item)
	gui_needs_update_items = true
	pass
	
func _on_PopupItem_popup_add_new_item(item_id):
	add_new_item(item_id)
	pass

func _on_HpSpinBox_value_changed(value):
	hp = int(floor(value))
	pass # Replace with function body.
