extends Timer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer_label = get_parent()
onready var enemy_power_label = get_parent().get_parent().get_node("LabelEnemyPower")
var countdown : int = 60
var enemy_power : int = 0
signal minute_has_passed()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("timeout", self, "_timeout")
	self.wait_time = 1
	self.start()
	pass # Replace with function body.

func _timeout():
	countdown -= 1
	if countdown < 0:
		enemy_power += 2
		countdown = 60
		emit_signal("minute_has_passed")
		enemy_power_label.text = "+" + str(enemy_power)
	update_counter(countdown)
	pass
	
func update_counter(time_left):
	timer_label.text = str(time_left)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
