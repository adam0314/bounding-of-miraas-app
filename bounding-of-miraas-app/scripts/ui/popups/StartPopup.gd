extends Popup
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal setup_player(player)
signal player_chosen()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func popup_and_make_bg_visible():
	popup()
	pass

func _on_Player1Button_pressed():
	emit_signal("setup_player", Global.PLAYER_1_ID)
	emit_signal("player_chosen")
	hide()
	pass # Replace with function body.


func _on_Player2Button_pressed():
	emit_signal("setup_player", Global.PLAYER_2_ID)
	emit_signal("player_chosen")
	hide()
	pass # Replace with function body.
