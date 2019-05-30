extends TabContainer

onready var player_node = $Gracz
onready var fight_node = $Walka

# Called when the node enters the scene tree for the first time.
func _ready():
	# attach nodes
	randomize()
	fight_node.player_manager = player_node
	player_node.fight_manager = fight_node
	pass # Replace with function body.
