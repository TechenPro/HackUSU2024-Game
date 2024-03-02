extends Node3D

const TILE_SIZE := 3
const HEX_FILE = preload("res://Assets/HexPillar.obj")
const MARBLE_TEX = preload("res://Assets/Marble.tres")

var server: ServerWorld
var client: PlayerWorld

var world_map

func _ready():	
	if multiplayer.is_server():
		server = ServerWorld.new()
		add_child(server)
		server.World_Updated.connect(world_updated)
		
	client = PlayerWorld.new()
	add_child(client)
	
	print(multiplayer.get_unique_id(), " requesting world state")
	get_world_state.rpc_id(1)
	
	
func on_world_state_requested():
	get_world_state.rpc()
	
	
@rpc("any_peer", "call_remote", "reliable")
func get_world_state():
	print("World state request received from: ", multiplayer.get_remote_sender_id())
	if multiplayer.is_server():
		var new_state = server.get_world_state()
		print(multiplayer.get_unique_id(), " Sending ", new_state, " to all")
		world_updated.rpc(new_state)


@rpc("authority", "call_remote", "reliable")
func world_updated(ws:WorldState):
	print(multiplayer.get_unique_id(), " recieved world update: ", ws)
	if not client.world_map:
		client.init_world(ws)
	else:
		client.world_updated(ws)
		
