extends TabContainer

var first_player_id : int
var level : int = 1

onready var player_ui_node = $Player
onready var fight_base_node = $FightBase
onready var fight_result_node = $FightResult

onready var enemy_manager = get_tree().get_nodes_in_group("enemy_manager")[0]
onready var item_manager = get_tree().get_nodes_in_group("item_manager")[0]
onready var fight_manager = get_tree().get_nodes_in_group("fight_manager")[0]

onready var PLAYER_MANAGER_SCRIPT = preload("res://scripts/PlayerManager.gd")
onready var player_1_manager = PLAYER_MANAGER_SCRIPT.PlayerManager.new()
onready var player_2_manager = PLAYER_MANAGER_SCRIPT.PlayerManager.new()

onready var start_popup = get_tree().get_nodes_in_group("start_popup")[0]
onready var top_panel_ui = get_tree().get_nodes_in_group("top_panel")[0]

const PLAYER_TAB_ID = 0
const FIGHT_BASE_TAB_ID = 1
const FIGHT_RESULT_TAB_ID = 2

const ENEMY_POWER_PER_LEVEL_INC = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	# attach nodes and shit
	randomize()
	enemy_manager.setup()
	item_manager.setup()
	
	player_1_manager.set_initial_values(
	{
		"player_id": Global.PLAYER_1_ID,
		"player_name": "Smutny gracz",
		"next_player_manager": player_2_manager,
		"player_ui_node": player_ui_node,
		"item_manager": item_manager,
		"enemy_power" : 0
		})
	player_2_manager.set_initial_values(
	{
		"player_id": Global.PLAYER_2_ID,
		"player_name": "Wesoly gracz",
		"next_player_manager": player_1_manager,
		"player_ui_node": player_ui_node,
		"item_manager": item_manager,
		"enemy_power" : 0
		})
	
	fight_base_node.fight_manager = fight_manager
	fight_result_node.fight_manager = fight_manager
	fight_manager.set_initial_values(
	{
		"fight_base_ui_node": fight_base_node,
		"fight_result_ui_node": fight_result_node,
		"enemy_manager": enemy_manager
		})
	
	start_popup.popup_and_make_bg_visible()
	yield(start_popup, "player_chosen")
	if first_player_id == Global.PLAYER_1_ID:
		init_game(player_1_manager, player_2_manager)
	elif first_player_id == Global.PLAYER_2_ID:
		init_game(player_2_manager, player_1_manager)
	else:
		Global.yeet("Wrong player chosen, what the fuck")
	pass

func init_game(first_player, second_player):
	switch_players(second_player, first_player)
	player_ui_node.init_and_start_timer()
	pass

func switch_tabs(val):
	match val["to_tab"]:
		"player":
			self.current_tab = PLAYER_TAB_ID
		"fight_base":
			fight_base_node.switch_tabs(fight_base_node.FIGHT_BASE_TAB_ID)
			self.current_tab = FIGHT_BASE_TAB_ID
			fight_base_node.update_enemy_power()
		"fight_result":
			fight_result_node.setup(val)
			self.current_tab = FIGHT_RESULT_TAB_ID
	pass

func switch_players(this_player_manager, next_player_manager):
	# swap them
	player_ui_node.current_player_manager = next_player_manager
	player_ui_node.update_all_data()
	
	enemy_manager.remove_player_enemy()
	enemy_manager.add_player_enemy(this_player_manager)
	
	fight_manager.player_manager = next_player_manager
	fight_manager.other_player_manager = this_player_manager
	fight_manager.clear_enemy()
	fight_base_node.clear_all_ui()
	pass

func stop_enemy_timer():
	player_ui_node.enemy_power_timer.stop()
	pass

func start_enemy_timer():
	player_ui_node.enemy_power_timer.start()
	pass

func end_level():
	level += 1
	if level > 3:
		top_panel_ui.set_game_end()
		return
	player_1_manager.enemy_power += ENEMY_POWER_PER_LEVEL_INC
	player_2_manager.enemy_power += ENEMY_POWER_PER_LEVEL_INC
	top_panel_ui.set_level_number(level)
	player_ui_node.ui_update_enemy_power()
	enemy_manager.clear_bosses_to_phase_1()
	pass

func _on_StartPopup_setup_player(player_id):
	first_player_id = player_id
	pass
