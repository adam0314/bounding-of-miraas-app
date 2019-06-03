extends Node

# vars

var enemies = []
var enemy_power : int

# consts

const ENEMY_POWER_INCREMENT : int = 2

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
	
func get_enemies_id() -> Array:
	var arr = []
	for enemy in enemies:
		arr.append(enemy.enemy_id)
	return arr
	
func strengthten_enemies():
	print("buff!")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_EnemyTimer_minute_has_passed():
	enemy_power += ENEMY_POWER_INCREMENT
	strengthten_enemies()
	pass # Replace with function body.
