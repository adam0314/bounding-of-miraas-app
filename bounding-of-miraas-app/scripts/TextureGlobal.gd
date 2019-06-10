extends Node

const TEX_BACK = preload("res://textures/ui/back_button.png")
const TEX_ENEMY_DEFAULT = preload("res://textures/enemies/EnemyToken.png")
const TEX_ENEMY_DEFAULT_SMALL = preload("res://textures/enemies/EnemyToken_small.png")
const TEX_ENEMY_LIST = [
preload("res://textures/enemies/000.png"),
preload("res://textures/enemies/001.png"),
preload("res://textures/enemies/002.png"),
preload("res://textures/enemies/003.png"),
preload("res://textures/enemies/004.png"),
preload("res://textures/enemies/005.png"),
preload("res://textures/enemies/006.png"),
preload("res://textures/enemies/007.png"),
]
const TEX_BOSS_01 = preload("res://textures/enemies/boss01.png")

const TEX_DICE = preload("res://textures/ui/Dices.png")
const TEX_ITEM_PASSIVE = preload("res://textures/ui/goldToken.png")
const TEX_ITEM_CONSUMABLE = preload("res://textures/ui/rustyToken.png")

const TEX_PLAYER_1 = preload("res://textures/ui/Player1.png")
const TEX_PLAYER_2 = preload("res://textures/ui/Player2.png")

const TEX_PLAYER_1_small = preload("res://textures/ui/player1_64x64.png")
const TEX_PLAYER_2_small = preload("res://textures/ui/player2_64x64.png")

const TEX_HEART_EMPTY = preload("res://textures/ui/Heart contour.png")
const TEX_HEART_NEGATIVE = preload("res://textures/ui/Heart blue.png")
const TEX_HEART_NEUTRAL = preload("res://textures/ui/Heart .png")
const TEX_HEART_POSITIVE = preload("res://textures/ui/Heart orange.png")

const TEX_ALLOWED_DICE = [
preload("res://textures/ui/allowed_dice/Col 2.png"),
preload("res://textures/ui/allowed_dice/Col 1.png"),
preload("res://textures/ui/allowed_dice/Col 12.png"),
preload("res://textures/ui/allowed_dice/Col 3.png"),
preload("res://textures/ui/allowed_dice/Col 23.png"),
preload("res://textures/ui/allowed_dice/Col 13.png"),
preload("res://textures/ui/allowed_dice/Col 123.png")
]

func get_allowed_dice_for_signs(signs : Array):
	var idx : int = -1
	if signs.find(Global.DICE_SIGNS.Negative) > -1:
		idx += 4
	if signs.find(Global.DICE_SIGNS.Neutral) > -1:
		idx += 2
	if signs.find(Global.DICE_SIGNS.Positive) > -1:
		idx += 1
	return TEX_ALLOWED_DICE[idx]
	pass

func get_heart_tex_for_sign(signn):
	match signn:
		Global.DICE_SIGNS.Negative:
			return TEX_HEART_NEGATIVE
		Global.DICE_SIGNS.Neutral:
			return TEX_HEART_NEUTRAL
		Global.DICE_SIGNS.Positive:
			return TEX_HEART_POSITIVE
	pass

func get_tex_for_item_type(type):
	match type:
		Global.ITEM_TYPES.Dice:
			return TEX_DICE
		Global.ITEM_TYPES.Passive:
			return TEX_ITEM_PASSIVE
		Global.ITEM_TYPES.Consumable:
			return TEX_ITEM_CONSUMABLE
	pass

func get_tex_for_enemy_id(id):
	if id < 100:
		return TEX_ENEMY_LIST[id]
	elif id < 200:
		return TEX_BOSS_01
	elif id == 201:
		return TEX_PLAYER_1_small
	elif id == 202:
		return TEX_PLAYER_2_small
	else:
		return {} # TODO error

func get_tex_for_player_id(id):
	return TEX_PLAYER_1 if id == 1 else TEX_PLAYER_2