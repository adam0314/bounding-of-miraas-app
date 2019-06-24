extends PopupPanel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fight_base_ui_node = get_node("../..")
onready var ui_enemies : ItemList = find_node("ItemList")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_everything(enemy_manager):
	if ui_enemies == null:
		ui_enemies = find_node("ItemList")
	ui_enemies.clear()
	for enemy in enemy_manager.enemies:
		ui_enemies.add_item(str(enemy.id) + ": " + enemy.name, TextureGlobal.get_tex_for_enemy_id(enemy.id))
		var idx_added = ui_enemies.get_item_count() - 1
		ui_enemies.set_item_metadata(idx_added, enemy.id)
	popup()
	pass


func _on_ButtonConfirm_pressed():
	var selected_idx = ui_enemies.get_selected_items()
	if selected_idx.size() == 0:
		# nothing was selected
		return
	else:
		var enemy_id = ui_enemies.get_item_metadata(selected_idx[0])
		hide()
		fight_base_ui_node.update_enemy(enemy_id)
	pass # Replace with function body.
	
func _on_Panel_focus_exited():
	hide()
	pass # Replace with function body.

func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			hide()
	pass # Replace with function body.
