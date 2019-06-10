extends PopupPanel

onready var main_container = get_tree().get_nodes_in_group("main")[0]

func _on_UnpauseButton_pressed():
	main_container.start_enemy_timer()
	hide()
	pass