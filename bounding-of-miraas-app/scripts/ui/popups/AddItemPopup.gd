extends AcceptDialog

var popup_layer
signal popup_add_new_item(item_id)
onready var player_ui_node = $"../../.."
onready var ui_option_button : OptionButton = $MarginContainer/OptionButton

func _ready():
	self.connect("popup_add_new_item", player_ui_node, "_on_PopupItem_popup_add_new_item")
	popup_layer = get_popup_layer()
	pass

func _on_ButtonAddItem_pressed():
	if popup_layer == null:
		popup_layer = get_popup_layer()
	popup_layer.visible = true
	clear_and_add_items_to_button()
	popup()
	pass # Replace with function body.

func clear_and_add_items_to_button():
	ui_option_button.clear()
	for item in player_ui_node.current_player_manager.item_manager.available_items:
		ui_option_button.add_item(str(item["id"]) + " " + item["name"], item["id"])
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
