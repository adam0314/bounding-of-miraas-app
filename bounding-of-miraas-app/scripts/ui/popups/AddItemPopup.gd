extends Popup

var popup_layer
signal popup_add_new_item(item_id)
onready var player_ui_node = $"../../.."
onready var ui_item_list : ItemList = find_node("ItemList")

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
	ui_item_list.clear()
	for item in player_ui_node.current_player_manager.item_manager.available_items:
		ui_item_list.add_item(str(item.id) + ": " + item.name, TextureGlobal.get_tex_for_item_type(item.type))
		ui_item_list.set_item_metadata(ui_item_list.get_item_count() - 1, item.id)
		ui_item_list.set_item_tooltip(ui_item_list.get_item_count() - 1, item.effect)
	pass

func get_popup_layer():
	return get_parent()

func _on_PopupItem_popup_hide():
	popup_layer.visible = false
	pass # Replace with function body.

func _on_ButtonOk_pressed():
	if ui_item_list.get_selected_items().size() > 0:
		var selected_item_idx = ui_item_list.get_selected_items()[0]
		var item_id = ui_item_list.get_item_metadata(selected_item_idx)
		emit_signal("popup_add_new_item", item_id)
		hide()
	else:
		return
		#Global.yeet("What the fuck nigga, no item selected")
	pass # Replace with function body.


func _on_PopupItem_focus_exited():
	
	pass # Replace with function body.
