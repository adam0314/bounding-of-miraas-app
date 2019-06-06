extends PopupPanel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fight_base_ui_node = get_node("../..")
onready var ui_items : ItemList = find_node("ItemList")

var player_manager_using_item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_everything(player_manager):
	player_manager_using_item = player_manager
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
		for idx in selected_idxs:
			fight_base_ui_node.fight_manager.add_selected_items_dict({
			"id": ui_items.get_item_metadata(idx),
			"player_manager": player_manager_using_item
			})
		# these items are used, so we need to remove them
		fight_base_ui_node.emit_signal("use_item_or_end_fight")
		hide()
	pass
