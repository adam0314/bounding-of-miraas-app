extends Panel

onready var main_container = get_tree().get_nodes_in_group("main")[0]
onready var pause_popup = get_tree().get_nodes_in_group("pause_popup")[0]

func _on_PauseButton_pressed():
	main_container.stop_enemy_timer()
	pause_popup.popup()
	pass