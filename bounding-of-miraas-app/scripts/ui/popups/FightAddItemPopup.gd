extends PopupPanel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fight_base_ui_node = get_node("../..")
onready var ui_items : ItemList = find_node("ItemList")

var player_manager_who_fired_this_popup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_everything(player_manager):
	player_manager_who_fired_this_popup = player_manager
	var items = []
	for item in player_manager.items:
		if item.type == Global.ITEM_TYPES.Consumable:
			items.append(item)
	if ui_items == null:
		ui_items = find_node("ItemList")
	ui_items.clear()
	for item in items:
		ui_items.add_item(item.name + ": " + item.effect, TextureGlobal.TEX_ITEM_CONSUMABLE)
		var idx_added = ui_items.get_item_count() - 1
		ui_items.set_item_metadata(idx_added, item.id)
	popup()
	pass

func _on_ButtonConfirmItems_pressed():
	var selected_idxs = ui_items.get_selected_items()
	if selected_idxs.size() == 0:
		# nothing was selected
		hide()
		return
	else:
		var item_id_arr = []
		for idx in selected_idxs:
			item_id_arr.append(ui_items.get_item_metadata(idx))
		# these items are used, so we need to remove them
		player_manager_who_fired_this_popup.remove_items_by_id(item_id_arr)
		fight_base_ui_node.fight_manager.set_selected_items(item_id_arr)
		hide()
	pass
