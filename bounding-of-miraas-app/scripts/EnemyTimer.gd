extends Timer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var TIMEOUT : int = Global.ENEMY_POWER_TIMEOUT # 2 minutes by default
onready var timer_label = get_parent()
var countdown : int = TIMEOUT
var enemy_power : int = 0
signal time_has_passed()

# Called when the node enters the scene tree for the first time.
#func _ready():
#
#	pass # Replace with function body.

func init_and_start_timer():
	self.connect("timeout", self, "_timeout")
	self.wait_time = 1
	self.start()
	update_counter()
	pass

func _timeout():
	countdown -= 1
	if countdown < 0:
		enemy_power += 1
		countdown = TIMEOUT
		emit_signal("time_has_passed")
	update_counter()
	pass
	
func update_counter():
	var seconds : int = countdown % 60
	var minutes : int = floor(float(countdown) / 60.0)
	timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
