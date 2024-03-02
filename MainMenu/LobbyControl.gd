extends Control

var ReadyButton
var BackButton
var PlayerOneReadyClicked
var PlayerTwoReadyClicked


# Called when the node enters the scene tree for the first time.
func _ready():
	ReadyButton = $ReadyButton
	ReadyButton.connect("pressed", _Ready_Button_Pressed)
	
	BackButton = $BackButton
	BackButton.connect("pressed", _Back_Button_Pressed)
	

	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (PlayerOneReadyClicked && PlayerTwoReadyClicked):
		await get_tree().create_timer(2).timeout
		print("both players ready")
	
func _Back_Button_Pressed():
	if (!PlayerOneReadyClicked):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	
func _Ready_Button_Pressed():
	var PlayerOneReady = $LobbyBoard/PlayerOneStatus/PlayerOneReady
	PlayerOneReady.text = "Ready"
	PlayerOneReadyClicked = true;
	
	print("Ready")
