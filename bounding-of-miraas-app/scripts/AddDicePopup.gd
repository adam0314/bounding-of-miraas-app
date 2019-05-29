extends AcceptDialog

var popup_layer
signal popup_add_new_dice(die_value)
onready var player_manager = $"../../.."

func _ready():
	self.connect("popup_add_new_dice", player_manager, "_on_PopupDice_popup_add_new_dice")
	popup_layer = get_popup_layer()
	register_text_enter($MarginContainer/LineEdit)
	pass

func _on_ButtonAddDice_pressed():
	if popup_layer == null:
		popup_layer = get_popup_layer()
	popup_layer.visible = true
	get_text_edit().text = ""
	popup()
	pass

func get_popup_layer():
	return get_parent()
	
func get_text_edit():
	return $MarginContainer/LineEdit

func _on_PopupDice_popup_hide():
	popup_layer.visible = false
	pass


func _on_PopupDice_confirmed():
	var die_value = get_text_edit().text
	
	# TODO: Add some validation for its value
	
	# if validation = success
	emit_signal("popup_add_new_dice", die_value)
	pass
