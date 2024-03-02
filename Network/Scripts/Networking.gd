extends Node

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT:int = 7777
const MAX_CLIENTS:int = 2	
var SERVER_IP = "127.0.0.1"

var players = []
var players_loaded = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	
func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CLIENTS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	self.players.append(multiplayer.get_unique_id())
	print("hosting game on port ", PORT)
	print(multiplayer.multiplayer_peer)
	print(self.players)
	
	player_connected.emit(1)
	
func join_game(address = ""):
	if address.is_empty():
		address = SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	print("joining ", address)
	multiplayer.multiplayer_peer = peer
		
func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null
	
# when host ready, call Networking.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)
	
# peers call this when they have loaded the game scene
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	print("Players loaded: ", players_loaded)
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			players_loaded = 0
			#start game
			print("TODO: Start Game")
			
func _on_player_connected(id):
	self.players.append(id)
	print("Player connected: ", id)
	print(self.players)
	#_register_player.rpc_id(id)
	
@rpc("any_peer", "reliable")
func _register_player():
	var new_player_id = multiplayer.get_remote_sender_id()
	self.players.append(new_player_id)
	print("registered player: ", new_player_id)
	print("All registered players: ", players)
	player_connected.emit(new_player_id)
	
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	print("Player disconnected: ", id)
	print(players)
	
func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	self.players.append(peer_id)
	print("I connected ok, my id is: ", peer_id)
	print(players)
	player_connected.emit(peer_id)
	get_tree().change_scene_to_file("res://MainMenu/Lobby.tscn")
	
func _on_connected_fail():
	print("You failed to connect")
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	
func _on_server_disconnected():
	print("Server disconnected")
	multiplayer.multiplayer_peer = null
	players.clear()
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	server_disconnected.emit()
