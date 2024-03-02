extends Control

var BackButton
var SubmitButton
var AddressInput
# Called when the node enters the scene tree for the first time.
func _ready():
	BackButton = $BackButton
	BackButton.connect("pressed", _Back_Button_Pressed)
	
	SubmitButton = $SubmitButton
	SubmitButton.connect("pressed", _Submit_Button_Pressed)
	
	AddressInput = $AddressInput
	AddressInput.connect("text_submitted", _Address_Submitted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _Back_Button_Pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	
func _Submit_Button_Pressed():
	_Address_Submitted(AddressInput.text)
	
func _Address_Submitted(new_text):
	print(new_text)
	
	if (new_text == "100"):
		get_tree().change_scene_to_file("res://MainMenu/Lobby.tscn")
