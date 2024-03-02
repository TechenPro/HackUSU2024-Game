extends Node3D

const TILE_SIZE := 3
const HEX_FILE = preload("res://Assets/HexPillar.obj")
const MARBLE_TEX = preload("res://Assets/Marble.tres")

var server: ServerWorld
var camera: Camera3D
var VWIDTH
var VHEIGHT
var pan_speed=20
var pan_h_max = 0
var pan_v_max = 0
var pan_h_min = 0
var pan_v_min = 0

func _ready():
	server = ServerWorld.new()
	camera = get_child(0)
	on_resize()
	get_tree().get_root().size_changed.connect(on_resize) 

	add_child(server)
var client: PlayerWorld

var world_map

func _ready():
	client = PlayerWorld.new()
	add_child(client)
		
	if multiplayer.is_server():
		server = ServerWorld.new()
		add_child(server)
		
	load_map.rpc(server.world_map)

@rpc("any_peer", "call_local", "reliable")
func load_map():
	print(server.world_map.get_coord_list())
	for coord in server.world_map.get_coord_list():
		var x = TILE_SIZE * (sqrt(3)*coord[0] + sqrt(3)/2*coord[1])
		var y = TILE_SIZE * (1.5 * coord[1])

		pan_h_max = max(x/3, pan_h_max)
		pan_v_max = max(y/3, pan_v_max)
		pan_h_min = min(x, pan_h_min)
		pan_v_min = min(y, pan_v_min)

		var tile = MeshInstance3D.new()
		tile.mesh = HEX_FILE
		add_child(tile)
		tile.translate(Vector3(x, 0, y))
		tile.rotate(Vector3(1,0,0), deg_to_rad(90))
		tile.rotate(Vector3(0,1,0), deg_to_rad(30))
		tile.material_override = MARBLE_TEX

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x > VWIDTH*.75:
		camera.h_offset += _delta*pan_speed
	elif mouse_pos.x < VWIDTH*.25:
		camera.h_offset += -_delta*pan_speed
	if mouse_pos.y > VHEIGHT*.75:
		camera.v_offset += -_delta*pan_speed
	elif mouse_pos.y < VHEIGHT*.25:
		camera.v_offset += _delta*pan_speed
	camera.h_offset = clamp(camera.h_offset, pan_h_min, pan_h_max)
	camera.v_offset = clamp(camera.v_offset, pan_v_min, pan_v_max)

func on_resize():
	var view = get_viewport().get_visible_rect().size
	VWIDTH = view.x
	VHEIGHT = view.y
	print(VWIDTH)
