extends Node

const TEX_BACK = preload("res://textures/ui/back_button.png")
const TEX_ENEMY_DEFAULT = preload("res://textures/enemies/EnemyToken.png")
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

const TEX_DICE = preload("res://textures/dice.png")
const TEX_ITEM_PASSIVE = preload("res://textures/ui/goldToken.png")
const TEX_ITEM_CONSUMABLE = preload("res://textures/ui/rustyToken.png")

const TEX_PLAYER_1 = preload("res://textures/ui/Player1.png")
const TEX_PLAYER_2 = preload("res://textures/ui/Player2.png")

const TEX_PLAYER_1_small = preload("res://textures/ui/player1_64x64.png")
const TEX_PLAYER_2_small = preload("res://textures/ui/player2_64x64.png")

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
	return TEX_ENEMY_LIST[id]

func get_tex_for_player_id(id):
	return TEX_PLAYER_1 if id == 1 else TEX_PLAYER_2