extends Node3D

const TILE_SIZE := 3
const HEX_FILE = preload("res://Assets/HexPillar.obj")
const MARBLE_TEX = preload("res://Assets/Marble.tres")

var server: ServerWorld

func _ready():
	server = ServerWorld.new()
	
	add_child(server)
	print(server.world_map.get_coord_list())
	for coord in server.world_map.get_coord_list():
		var x = TILE_SIZE * (sqrt(3)*coord[0] + sqrt(3)/2*coord[1])
		var y = TILE_SIZE * (1.5 * coord[1])
		var tile = MeshInstance3D.new()
		tile.mesh = HEX_FILE
		add_child(tile)
		tile.translate(Vector3(x, 0, y))
		tile.rotate(Vector3(1,0,0), deg_to_rad(90))
		tile.rotate(Vector3(0,1,0), deg_to_rad(30))
		tile.material_override = MARBLE_TEX

	
