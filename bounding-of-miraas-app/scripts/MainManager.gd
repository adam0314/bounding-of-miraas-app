extends TabContainer

onready var player_node = $Player
onready var fight_base_node = $FightBase
onready var fight_apply_items_node = $FightApplyItems
onready var fight_result_node = $FightResult

onready var enemy_manager = get_tree().get_nodes_in_group("enemy_manager")[0]
onready var item_manager = get_tree().get_nodes_in_group("item_manager")[0]
onready var fight_manager = get_tree().get_nodes_in_group("fight_manager")[0]

onready var PLAYER_MANAGER_SCRIPT = preload("res://scripts/PlayerManager.gd")
onready var player_1_manager = PLAYER_MANAGER_SCRIPT.PlayerManager.new()
onready var player_2_manager = PLAYER_MANAGER_SCRIPT.PlayerManager.new()

const PLAYER_TAB_ID = 0
const FIGHT_BASE_TAB_ID = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# attach nodes
	randomize()
	enemy_manager.setup()
	item_manager.setup()
	
	player_1_manager.set_initial_values(
	{
		"player_name": "Smutny gracz",
		"next_player_manager": player_2_manager,
		"player_ui_node": player_node,
		"item_manager": item_manager
		})
	player_2_manager.set_initial_values(
	{
		"player_name": "Wesoly gracz",
		"next_player_manager": player_1_manager,
		"player_ui_node": player_node,
		"item_manager": item_manager
		})
	
	fight_base_node.enemy_manager = enemy_manager
#	player_1_node.this_player_tab_id = 0
#	player_1_node.next_player_tab_id = 1
#	player_1_node.fight_tab_id = 2
#	player_2_node.this_player_tab_id = 1
#	player_2_node.next_player_tab_id = 0
#	player_2_node.fight_tab_id = 3
	
	
#	fight_1_node.setup_enemies_to_button()
#	fight_2_node.setup_enemies_to_button()

	# Init game
	# Set 1st player as first in player_node
	init_game()

	pass # Replace with function body.

func init_game():
	player_node.current_player_manager = player_1_manager
	player_node.update_all_data()
	pass

func switch_tabs(val):
	match val["to_tab"]:
		"player":
			self.current_tab = PLAYER_TAB_ID
		"fight_base":
			self.current_tab = FIGHT_BASE_TAB_ID
	pass

func switch_players(next_player_manager):
	player_node.current_player_manager = next_player_manager
	player_node.update_all_data()
	pass
