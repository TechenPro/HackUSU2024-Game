extends Node

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT:int = 7777
const MAX_CLIENTS:int = 2	
var SERVER_IP = "127.0.0.1"

var players = {}
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
	print("hosting game on port ", PORT)
	multiplayer.multiplayer_peer = peer
	print(multiplayer.multiplayer_peer)
	
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
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			players_loaded = 0
			#start game
			print("TODO: Start Game")
			
func _on_player_connected(id):
	_register_player.rpc_id(id)
	print("Player %d connected", id)
	
@rpc("any_peer", "reliable")
func _register_player():
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_id
	player_connected.emit(new_player_id)
	print("registered player: %d", new_player_id)
	
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	print("Player %d disconnected", id)
	
func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = peer_id
	player_connected.emit(peer_id)
	print("I connected ok, my id is: %d", peer_id)
	
func _on_connected_fail():
	print("A Player failed to connect")
	multiplayer.multiplayer_peer = null
	
func _on_server_disconnected():
	print("Server disconnected")
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
