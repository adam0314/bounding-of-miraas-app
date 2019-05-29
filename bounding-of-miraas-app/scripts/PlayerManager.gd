extends Control

# Main player data control manager

# Constants

const INITIAL_DICE = [
	"6",
	"8-",
	"20+"
	]
	
# Control vars

var gui_needs_update_dice = false

# Stats

var hp : int # TODO maybe change it to float
var dice = []
var items = []

# Nodes
var DICE_OBJECT_SCRIPT = preload("res://scripts/DiceObject.gd")
var DICE_GUI_NODE = preload("res://scenes/DiceGraphic.tscn")
onready var dice_gui_node = $PlayerData/PlayerDicesContainer/ScrollContainer/DirectDiceContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for die in INITIAL_DICE:
		add_new_die(die)
	pass # Replace with function body
	
func _process(delta):
	if gui_needs_update_dice:
		update_dices()
	pass
	
func update_dices():
	gui_needs_update_dice = false;
	var gui_dice = dice_gui_node.get_children()
	if gui_dice.size() == 0:
		# Special case on initialization
		for die in dice:
			var d = DICE_GUI_NODE.instance()
			d.set_nodes_and_parameters(die)
			dice_gui_node.add_child(d)
	elif gui_dice.size() < dice.size():
		# new dice will be added
		for ind in range(gui_dice.size(), dice.size()):
			print("adding die")
			var d = DICE_GUI_NODE.instance()
			d.set_nodes_and_parameters(dice[ind])
			dice_gui_node.add_child(d)
			
	# TODO: Handle deletion
	pass	
	
func add_new_die(input_string):
	var die = DICE_OBJECT_SCRIPT.DiceObject.new()
	die.set_values(input_string)
	dice.append(die)
	gui_needs_update_dice = true

func _on_PopupDice_popup_add_new_dice(die_value):
	add_new_die(die_value)
	pass
