extends Timer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const TIMEOUT : int = 179 # 3 minutes
onready var timer_label = get_parent()
onready var enemy_power_label = get_parent().get_parent().get_node("LabelEnemyPower")
var countdown : int = TIMEOUT
var enemy_power : int = 0
signal minute_has_passed()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("timeout", self, "_timeout")
	self.wait_time = 1
	self.start()
	update_counter(TIMEOUT)
	pass # Replace with function body.

func _timeout():
	countdown -= 1
	if countdown < 0:
		enemy_power += 1
		countdown = TIMEOUT
		emit_signal("minute_has_passed")
	update_counter(countdown)
	pass
	
func update_counter(time_left):
	var textt = ""
	var seconds : int = time_left % 60
	var minutes : int = floor(float(time_left) / 60.0)
	timer_label.text = str(minutes) + ":" + (("0" + str(seconds)) if seconds <= 9 else str(seconds))
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
