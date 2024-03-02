extends Control

var ReadyButton
var BackButton
var PlayerOneReadyClicked:bool
var PlayerTwoReadyClicked:bool

var ready_players
var NetworkController


# Called when the node enters the scene tree for the first time.
func _ready():
	self.NetworkController = get_parent().get_node("NetworkControl")
	if multiplayer.is_server():
		ready_players = [false, false]
	
	ReadyButton = $ReadyButton
	ReadyButton.connect("pressed", _On_Ready_Button_Pressed)
	
	BackButton = $BackButton
	BackButton.connect("pressed", _Back_Button_Pressed)
	
	var PlayerOneReady = $LobbyBoard/PlayerOneStatus/PlayerOneReady
	var PlayerTwoReady = $LobbyBoard/PlayerOneStatus/PlayerTwoReady

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (PlayerOneReadyClicked && PlayerTwoReadyClicked):
		await get_tree().create_timer(2).timeout
		print("both players ready")
	
func _Back_Button_Pressed():
	if (!PlayerOneReadyClicked):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	
func _On_Ready_Button_Pressed():
	player_ready.rpc(multiplayer.get_unique_id())
	print("Ready")
	
@rpc("any_peer", "call_local", "reliable")
func player_unready(peer_id):
	#TODO Player unready
	print("player unready " , peer_id)

	
@rpc("any_peer", "call_local", "reliable")
func player_ready(peer_id):
	print("player ready", peer_id)
	if multiplayer.is_server():
		if peer_id == 1:
			ready_players[0] = true
		else: 
			ready_players[1] = true
			
		print(ready_players)
		for i in range(0, ready_players.size()-1):
			set_player_ready_status.rpc(i, ready_players[i])
		if (ready_players[0] && ready_players [1]):
			start_game.rpc()
			print("TODO: Start game")

@rpc("authority", "reliable")
func set_player_ready_status(player_id, status):
	print("set_player_ready ", player_id, " ", status)
	var readyText = ""
	if (status):
		readyText = "Ready"
	if (player_id == 0):
		$LobbyBoard/PlayerOneStatus/PlayerOneReady.text = readyText
	else:
		$LobbyBoard/PlayerTwoStatus/PlayerTwoReady.text = readyText
	

@rpc("authority", "reliable")
func start_game():
	#TODO: Start the game
	#get_tree().change_scene_to_file()
	pass
