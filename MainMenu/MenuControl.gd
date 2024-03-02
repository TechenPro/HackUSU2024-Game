extends Control

var JoinButton
var HostButton
var RulesButton
# Called when the node enters the scene tree for the first time.
func _ready():
	JoinButton = $JoinButton
	JoinButton.connect("pressed", _Join_Button_Pressed)
	HostButton = $HostButton
	HostButton.connect("pressed", _Host_Button_Pressed)
	RulesButton = $RulesButton
	RulesButton.connect("pressed", _Rules_Button_Pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _Join_Button_Pressed():
	get_tree().change_scene_to_file("res://MainMenu/JoinMenu.tscn")

	
func _Host_Button_Pressed():
	var NetworkManager = get_parent().get_node("NetworkManager")
	NetworkManager.create_game()
	get_tree().change_scene_to_file("res://MainMenu/Lobby.tscn")
	
func _Rules_Button_Pressed():
	pass
