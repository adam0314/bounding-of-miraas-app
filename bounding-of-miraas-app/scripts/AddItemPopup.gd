extends AcceptDialog

var popup_layer
signal popup_add_new_item(item_id)
onready var player_manager = $"../../.."
onready var ui_option_button : OptionButton = $MarginContainer/OptionButton

func _ready():
	self.connect("popup_add_new_item", player_manager, "_on_PopupItem_popup_add_new_item")
	popup_layer = get_popup_layer()
	register_text_enter($MarginContainer/LineEdit)
	pass

func _on_ButtonAddItem_pressed():
	if popup_layer == null:
		popup_layer = get_popup_layer()
	popup_layer.visible = true
	add_items_to_button_if_needed()
	popup()
	pass # Replace with function body.

func add_items_to_button_if_needed():
	if ui_option_button.get_item_count() == Global.ITEMS_LIST.size(): #already added
		return
	for item in Global.ITEMS_LIST:
		ui_option_button.add_item(str(item[0]) + " " + item[2], item[0])
	pass

func get_popup_layer():
	return get_parent()

func _on_PopupItem_popup_hide():
	popup_layer.visible = false
	pass # Replace with function body.


func _on_PopupItem_confirmed():
	var item_id = ui_option_button.get_selected_id()
	
	# TODO: Add some validation for its value
	
	# if validation = success
	emit_signal("popup_add_new_item", item_id)
	pass # Replace with function body.
