extends CenterContainer

onready var ui_texture = $Hbox/Vbox/EnemyTexture
onready var ui_dice = $Hbox/Vbox/EnemyDice
onready var ui_allowed_dice = $Hbox/EnemyAllowedDice

func _ready():
	pass
	
func ui_update_enemy(enemy):
	ui_texture.modulate = Global.get_color_for_sign(enemy.enemy_type)
	ui_dice.text = ui_format_text_dice(enemy.enemy_dice)
	ui_allowed_dice.bbcode_text = ui_format_allowed_dice(enemy.player_allowed_dice)
	pass
	
func ui_format_text_dice(dice) -> String:
	var sstr = ""
	for die in dice:
		sstr += die.to_string() + " "
	return sstr.rstrip(" ")
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