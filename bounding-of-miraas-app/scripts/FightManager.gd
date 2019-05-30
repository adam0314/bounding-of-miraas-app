extends Control

# Main fight manager

# Vars

var current_enemy
var ui_need_update_enemy : bool = false

# Nodes
const ENEMY_OBJECT_SCRIPT = preload("res://scripts/EnemyObject.gd")
onready var ui_enemy_container = $Mcont/Vbox/Hbox/EnemyDataContainer

func _ready():
	pass

func _process(delta):
	if ui_need_update_enemy:
		ui_need_update_enemy = false
		ui_enemy_container.ui_update_enemy(current_enemy)
		
	pass
	
func roll_and_create_enemy():
	var available_enemies_count : int = Global.ENEMIES_LIST.size()
	var random_id = randi() % available_enemies_count
	var enemy_data = Global.get_enemy_for_id(random_id)
	
	current_enemy = ENEMY_OBJECT_SCRIPT.EnemyObject.new()
	current_enemy.set_values(enemy_data)
	ui_need_update_enemy = true
	pass

func _on_RollForEnemyButton_pressed():
	roll_and_create_enemy()
	pass
