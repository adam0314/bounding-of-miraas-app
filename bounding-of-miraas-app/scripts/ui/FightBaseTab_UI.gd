extends Control

# Base fight ui tab

# Consts

const FIGHT_BASE_TAB_ID = 0
const FIGHT_APPLY_ITEMS_TAB_ID = 1

# Vars

var ui_need_update_enemy : bool = false
var player_dice_throws : Array
var player_throw_sum : int

var actually_fighting : bool = false
var end_fight : bool = false

# Nodes
var fight_manager : Node

onready var ui_change_enemy_popup : PopupPanel = find_node("PopupChangeEnemy")
onready var ui_enemy_container = find_node("EnemyDataContainer")
onready var enemy_option_button : OptionButton = find_node("EnemyName")

onready var ui_fight_tab : TabContainer = find_node("FightTabCont")
onready var ui_player_texture : TextureRect = find_node("PlayerTexture")
onready var ui_enemy_texture : TextureRect = find_node("EnemyMiniTexture")

onready var ui_player_throws : RichTextLabel = find_node("PlayerThrowsLabel")
onready var ui_enemy_throws : RichTextLabel = find_node("EnemyThrowsLabel")
onready var ui_player_score : Label = find_node("PlayerSumLabel")
onready var ui_enemy_score : Label = find_node("EnemySumLabel")

onready var ui_add_items_popup : PopupPanel = find_node("PopupAddItems")
onready var ui_confirm_button : TextureButton = find_node("ConfirmButton")

# signals

signal use_item_or_end_fight()

func _ready():
	pass

func switch_tabs(id):
	ui_fight_tab.current_tab = id
	pass	

func fire_popup_change_enemy():
	ui_change_enemy_popup.setup_everything(fight_manager.enemy_manager)
	pass

func fire_popup_add_items(id : int):
	if fight_manager.player_manager.player_id == id:
		ui_add_items_popup.setup_everything(fight_manager.player_manager)
	else:
		ui_add_items_popup.setup_everything(fight_manager.other_player_manager)
	pass

func _process(delta):
	if ui_need_update_enemy:
		ui_need_update_enemy = false
		ui_enemy_container.ui_update_enemy(fight_manager.current_enemy)
		if fight_manager.current_enemy.type == Global.ENEMY_TYPE.Player:
			ui_enemy_texture.texture = TextureGlobal.get_tex_for_enemy_id(fight_manager.current_enemy.id)
		else:
			ui_enemy_texture.texture = TextureGlobal.TEX_ENEMY_DEFAULT_SMALL
	pass
	
func update_enemy(id): #going up
	fight_manager.update_enemy(id)
	pass

func clear_enemy(): #coming from up
	ui_enemy_container.ui_clear_enemy()
	ui_enemy_texture.texture = TextureGlobal.TEX_ENEMY_DEFAULT
	pass

func clear_all_ui():
	actually_fighting = false
	if fight_manager.player_manager.player_id == 1:
		ui_player_texture.texture = TextureGlobal.TEX_PLAYER_1_small
	else:
		ui_player_texture.texture = TextureGlobal.TEX_PLAYER_2_small
	pass
	ui_enemy_texture.texture = TextureGlobal.TEX_ENEMY_DEFAULT
	ui_fight_tab.current_tab = 0

func clear_throws():
	ui_player_throws.bbcode_text = ""
	ui_enemy_throws.bbcode_text = ""
	ui_player_score.text = ""
	ui_enemy_score.text = ""
	pass

func print_throws(throws_data):
	ui_player_throws.bbcode_text = format_throws(throws_data["player_throws"])
	ui_enemy_throws.bbcode_text = format_throws(throws_data["enemy_throws"])
	ui_player_score.text = "=" + str(throws_data["player_score"])
	ui_enemy_score.text = "=" + str(throws_data["enemy_score"])
	pass

func format_throws(throws) -> String:
	var sstr = ""
	for throw in throws:
		sstr += (Global.get_bb_code_for_sign(str(throw["value"]), throw["sign"]) + " ")
	return sstr.rstrip(" ")

func commence_fight():
	actually_fighting = true
	switch_tabs(FIGHT_APPLY_ITEMS_TAB_ID)
	pass

func _on_ButtonBackToPlayer_pressed():
	get_parent().switch_tabs({"to_tab": "player"})
	pass # Replace with function body.

func _on_Pcont_gui_input(event):
	if event is InputEventMouseButton and (not actually_fighting):
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("clicked!")
			fire_popup_change_enemy()
	pass # Replace with function body.


func _on_ButtonFight_pressed():
	fight_manager.fight()
	pass

func _on_Player1AddItem_pressed():
	fire_popup_add_items(1)
	pass # Replace with function body.


func _on_Player2AddItem_pressed():
	fire_popup_add_items(2)
	pass # Replace with function body.


func _on_ConfirmButton_pressed():
	end_fight = true
	emit_signal("use_item_or_end_fight")
	pass # Replace with function body.
