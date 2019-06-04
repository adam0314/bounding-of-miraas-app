extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var enemy_timer = get_parent().get_node("LabelTimer/EnemyTimer")
onready var main_manager = get_node("../../..").find_node("MainTabContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PauseButton_pressed():
	print("pause not working yet")
	pass # Replace with function body.
