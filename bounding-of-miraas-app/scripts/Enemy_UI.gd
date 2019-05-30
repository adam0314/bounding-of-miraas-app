extends CenterContainer

onready var ui_texture = $Vbox/EnemyTexture
onready var ui_name = $Vbox/EnemyName
onready var ui_dice = $Vbox/EnemyDice

func _ready():
	pass
	
func ui_update_enemy(enemy):
	ui_texture.modulate = Global.get_color_for_sign(enemy.enemy_type)
	ui_name.text = enemy.enemy_name
	ui_dice.text = ui_format_text_dice(enemy.enemy_dice)
	pass
	
func ui_format_text_dice(dice) -> String:
	var sstr = ""
	for die in dice:
		sstr += str(die.dice_value) + die.dice_sign + " "
	return sstr.rstrip(" ")
	pass