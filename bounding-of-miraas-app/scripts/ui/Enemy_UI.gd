extends CenterContainer

onready var ui_texture = find_node("EnemyTexture")
onready var ui_allowed_dice = find_node("EnemyAllowedDice")
onready var ui_enemy_name = find_node("EnemyName")
onready var ui_dice = $"../../../..".find_node("EnemyDiceList")

const TEXTURE_DICE = preload("res://textures/dice.png")

func _ready():
	pass
	
func ui_update_enemy(enemy):
	ui_texture.modulate = Global.get_color_for_sign(enemy.type)
	ui_enemy_name.text = enemy.name
	ui_allowed_dice.bbcode_text = ui_format_allowed_dice(enemy.player_allowed_dice)
	ui_dice.clear()
	for die in enemy.dice:
		ui_update_dice(die)
	pass

func ui_format_allowed_dice(dice_types : Array) -> String:
	var sstr = ""
	if dice_types.find(Global.DICE_SIGNS.Positive) >= 0:
		sstr += Global.get_bb_code_for_sign("Dodatnie", Global.DICE_SIGNS.Positive)
	if dice_types.find(Global.DICE_SIGNS.Neutral) >= 0:
		sstr += Global.get_bb_code_for_sign("Zwykle", Global.DICE_SIGNS.Neutral)
	if dice_types.find(Global.DICE_SIGNS.Negative) >= 0:
		sstr += Global.get_bb_code_for_sign("Ujemne", Global.DICE_SIGNS.Negative)
	return sstr.rstrip(" ")

func ui_update_dice(die):
	ui_dice.add_item(die.to_string(), TEXTURE_DICE)
	var idx_added = ui_dice.get_item_count() - 1
	ui_dice.set_item_icon_modulate(idx_added, Global.get_color_for_sign(die.dice_sign_enum))
	pass