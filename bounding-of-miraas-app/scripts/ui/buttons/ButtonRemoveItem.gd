extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DirectItemContainer_nothing_selected():
	disabled = true
	pass # Replace with function body.


func _on_DirectItemContainer_item_selected(index):
	disabled = false
	pass # Replace with function body.


func _on_ButtonRemoveItem_pressed():
	disabled = true
	pass # Replace with function body.
