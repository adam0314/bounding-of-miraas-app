extends Node

# vars

var enemies = []
var enemy_power : int

# consts

const ENEMY_POWER_INCREMENT : int = 1
const CHANCE_FOR_DICE_SIGN : float = 0.9
const DIE_TO_ADD : String = "6"
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
	
func strengthten_enemies():
	print("buff!")
	for enemy in enemies:
		if enemy.type != Global.ENEMY_TYPE.Player: #not adding dice to player
			var die_to_add = DIE_TO_ADD
			var use_enemy_type_for_die : bool = (randf() <= CHANCE_FOR_DICE_SIGN)
			if use_enemy_type_for_die:
				die_to_add = Global.get_stringsign_for_sign(enemy.type) + die_to_add
			else:
				var other_signs : Array = Global.DICE_SIGNS.duplicate().values()
				other_signs.erase(enemy.type)
				die_to_add = Global.get_stringsign_for_sign(other_signs[0] if randf() < 0.5 else other_signs[1]) + die_to_add
			enemy.add_new_die(die_to_add)
	pass

func _on_EnemyTimer_minute_has_passed():
	enemy_power += ENEMY_POWER_INCREMENT
	strengthten_enemies()
	pass # Replace with function body.
