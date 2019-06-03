extends TabContainer

onready var player_1_node = $Gracz1
onready var fight_1_node = $Walka1
onready var player_2_node = $Gracz2
onready var fight_2_node = $Walka2

onready var enemy_manager = get_tree().get_nodes_in_group("enemy_manager")[0]
onready var item_manager = get_tree().get_nodes_in_group("item_manager")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	# attach nodes
	randomize()
	fight_1_node.player_manager = player_1_node
	fight_1_node.enemy_manager = enemy_manager
	fight_2_node.enemy_manager = enemy_manager
	player_1_node.fight_manager = fight_1_node
	fight_2_node.player_manager = player_2_node
	player_2_node.fight_manager = fight_2_node
	player_1_node.item_manager = item_manager
	player_2_node.item_manager = item_manager
	
	player_1_node.find_node("LabelPlayerName").text = "Smutny gracz"
	player_2_node.find_node("LabelPlayerName").text = "Wesoly gracz"
	player_1_node.this_player_tab_id = 0
	player_1_node.next_player_tab_id = 1
	player_1_node.fight_tab_id = 2
	player_2_node.this_player_tab_id = 1
	player_2_node.next_player_tab_id = 0
	player_2_node.fight_tab_id = 3
	
	enemy_manager.setup()
	item_manager.setup()
	fight_1_node.setup_enemies_to_button()
	fight_2_node.setup_enemies_to_button()
	pass # Replace with function body.

func switch_tabs(tab_id):
	self.current_tab = tab_id
	pass
