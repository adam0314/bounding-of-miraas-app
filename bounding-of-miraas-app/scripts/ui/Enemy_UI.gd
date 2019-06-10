extends CenterContainer

onready var ui_texture = find_node("EnemyTexture")
onready var ui_allowed_dice : TextureRect = find_node("AllowedDiceTex")
onready var ui_enemy_sign : TextureRect = find_node("HeartTex")
onready var ui_enemy_name = find_node("EnemyName")
onready var ui_dice = $"../../../..".find_node("EnemyDiceList")

func _ready():
	pass
	
func ui_update_enemy(enemy):
	ui_texture.texture = TextureGlobal.get_tex_for_enemy_id(enemy.id)
	ui_enemy_name.text = enemy.name
	ui_allowed_dice.texture = TextureGlobal.get_allowed_dice_for_signs(enemy.player_allowed_dice)
	ui_enemy_sign.texture = TextureGlobal.get_heart_tex_for_sign(enemy.signn)
	ui_dice.clear()
	for die in enemy.dice:
		ui_update_dice(die)
	pass

func ui_clear_enemy():
	ui_dice.clear()
	ui_texture.texture = TextureGlobal.TEX_ENEMY_DEFAULT
	ui_enemy_name.text = "Kliknij mnie!"
	ui_enemy_sign.texture = TextureGlobal.TEX_HEART_EMPTY
	ui_allowed_dice.texture = null
	pass

#func ui_format_allowed_dice(dice_types : Array) -> String:
#	var sstr = ""
#	if dice_types.find(Global.DICE_SIGNS.Positive) >= 0:
#		sstr += Global.get_bb_code_for_sign("Dodatnie", Global.DICE_SIGNS.Positive)
#	if dice_types.find(Global.DICE_SIGNS.Neutral) >= 0:
#		sstr += Global.get_bb_code_for_sign("Zwykle", Global.DICE_SIGNS.Neutral)
#	if dice_types.find(Global.DICE_SIGNS.Negative) >= 0:
#		sstr += Global.get_bb_code_for_sign("Ujemne", Global.DICE_SIGNS.Negative)
#	return sstr.rstrip(" ")

#func ui_format_enemy_sign(type) -> String:
#	match type:
#		Global.DICE_SIGNS.Negative:
#			return "Jestem " + Global.get_bb_code_for_sign("niebieski", type) + "!"
#		Global.DICE_SIGNS.Neutral:
#			return "Jestem " + Global.get_bb_code_for_sign("zwykly", type) + "!"
#		Global.DICE_SIGNS.Positive:
#			return "Jestem " + Global.get_bb_code_for_sign("pomaranczowy", type) + "!"
#	pass

func ui_update_dice(die):
	ui_dice.add_item(die.to_string(), TextureGlobal.TEX_DICE, false)
	var idx_added = ui_dice.get_item_count() - 1
	ui_dice.set_item_icon_modulate(idx_added, Global.get_color_for_sign(die.dice_sign_enum))
	pass