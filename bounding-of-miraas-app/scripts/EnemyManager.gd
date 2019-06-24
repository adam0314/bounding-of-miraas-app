extends Node

# vars

var enemies = []
var enemy_power : int

# consts

const PLAYER_ENEMY_BASE_ID = 200

# nodes and scripts

const ENEMY_OBJECT_SCRIPT = preload("res://scripts/EnemyObject.gd")
var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup():
	enemy_power = 0
	load_enemies()
	pass

func load_enemies():
	for enemy_data in Global.ENEMIES_LIST:
		var enemy = ENEMY_OBJECT_SCRIPT.EnemyObject.new()
		enemy.set_values(enemy_data)
		enemies.append(enemy)
	pass

func remove_player_enemy():
	for enemy in enemies:
		if enemy.type == Global.ENEMY_TYPE.Player:
			enemies.erase(enemy)
	pass

func add_player_enemy(player_manager):
	var player_enemy = ENEMY_OBJECT_SCRIPT.EnemyObject.new()
	player_enemy.set_values({
		"id": PLAYER_ENEMY_BASE_ID + player_manager.player_id,
		"dice": player_manager.get_dice_to_string(),
		"sign": Global.DICE_SIGNS.Neutral,
		"name": player_manager.player_name,
		"allowed_dice": [Global.DICE_SIGNS.Neutral, Global.DICE_SIGNS.Positive, Global.DICE_SIGNS.Negative],
		"type": Global.ENEMY_TYPE.Player
	})
	enemies.append(player_enemy)
	pass
	
func get_enemies_id() -> Array:
	var arr = []
	for enemy in enemies:
		arr.append(enemy.enemy_id)
	return arr

func get_enemy_by_id(id):
	for enemy in enemies:
		if enemy.id == id:
			return enemy
	return {}

func get_enemy_copy_by_id_and_strengthten(id, enemy_power):
	var enemy_original = get_enemy_by_id(id)
	var enemy_copy = ENEMY_OBJECT_SCRIPT.EnemyObject.new()
	enemy_copy.set_values_by_copy(enemy_original)
	if enemy_copy.type != Global.ENEMY_TYPE.Player:
		enemy_copy.strengthten(enemy_power)
	return enemy_copy

func advance_phase(input_enemy):
	for enemy in enemies:
		if (enemy.id == input_enemy.id) and (enemy.type == Global.ENEMY_TYPE.Boss):
			enemy.advance_phase()
			return
	pass

func clear_bosses_to_phase_1():
	for enemy in enemies:
		if enemy.type == Global.ENEMY_TYPE.Boss:
			enemy.advance_phase(true)
	pass
