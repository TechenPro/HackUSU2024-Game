extends Node3D

const TILE_SIZE := 3
const HEX_FILE = preload("res://Assets/HexPillar.obj")
const MARBLE_TEX = preload("res://Assets/Marble.tres")

var server: ServerWorld
var client: PlayerWorld
var camera: Camera3D
var VWIDTH
var VHEIGHT
var pan_speed=20
var pan_h_max = 0
var pan_v_max = 0
var pan_h_min = 0
var pan_v_min = 0

func _ready():
	camera = get_child(0)
	on_resize()
	get_tree().get_root().size_changed.connect(on_resize)
	client = PlayerWorld.new()
	add_child(client)
		
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
		world_updated.rpc(str(new_state))


@rpc("any_peer", "call_remote", "reliable")
#func world_updated(ws:WorldState):
func world_updated(ws:String):
	print(multiplayer.get_unique_id(), " recieved world update: ", ws)
	if not client.world_map:
		#client.init_world(ws)
		pass
	else:
		#client.world_updated(ws)
		pass
		
