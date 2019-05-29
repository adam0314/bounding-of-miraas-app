extends AcceptDialog

var popup_layer

func _ready():
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


func _on_PopupItem_popup_hide():
	popup_layer.visible = false
	pass # Replace with function body.


func _on_PopupItem_confirmed():
	pass # Replace with function body.
