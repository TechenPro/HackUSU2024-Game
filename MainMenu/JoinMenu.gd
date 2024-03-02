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
	
func _Address_Submitted(str):
	var address = verify_address(str)
	if address == "-1":
		return
	var NetworkManager = get_parent().get_node("NetworkManager")
	NetworkManager.join_game(address)
	
	if (str == "100"):
		get_tree().change_scene_to_file("res://MainMenu/Lobby.tscn")
		
func verify_address(str):
	if str == "":
		return str
	var regex = RegEx.new()
	regex.compile("^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$")
	var result = regex.search(str)
	if not result:
		print("Invalid IP Address!", str)
		return -1
	var blocks = [int(result.get_string(1)),
		int(result.get_string(2)),
		int(result.get_string(3)),
		int(result.get_string(4))]
		
	for block in blocks:
		if block < 0 or block > 255:
			return null
	
	return str
	
