extends AcceptDialog

var popup_layer
signal popup_add_new_item(item_id)
onready var player_manager = $"../../.."

func _ready():
	self.connect("popup_add_new_item", player_manager, "_on_PopupItem_popup_add_new_item")
	popup_layer = get_popup_layer()
	register_text_enter($MarginContainer/LineEdit)
	pass

func _on_ButtonAddItem_pressed():
	if popup_layer == null:
		popup_layer = get_popup_layer()
	popup_layer.visible = true
	popup()
	pass # Replace with function body.

func get_popup_layer():
	return get_parent()

func get_text_edit():
	return $MarginContainer/LineEdit

func _on_PopupItem_popup_hide():
	popup_layer.visible = false
	pass # Replace with function body.


func _on_PopupItem_confirmed():
	var item_id = get_text_edit().text
	
	# TODO: Add some validation for its value
	
	# if validation = success
	emit_signal("popup_add_new_item", int(item_id))
	pass # Replace with function body.
