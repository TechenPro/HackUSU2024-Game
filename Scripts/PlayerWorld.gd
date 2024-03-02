class_name PlayerWorld extends Node

#var world_state: WorldState
var world_map:TerrainMap

signal Request_World_State

const TILE_SIZE := 3
const HEX_FILE = preload("res://Assets/HexPillar.obj")
const MARBLE_TEX = preload("res://Assets/Marble.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Player instantiated: ", multiplayer.get_unique_id())
	Request_World_State.emit()


func init_world(init_state: WorldState):
	print("init_world")
	load_map()
	
func load_map():
	if not world_map:
		Request_World_State.emit()
		return
		
	var coord_list = world_map.get_coord_list()
	print(coord_list)
		
	for coord in coord_list:
		var x = TILE_SIZE * (sqrt(3)*coord[0] + sqrt(3)/2*coord[1])
		var y = TILE_SIZE * (1.5 * coord[1])
		var tile = MeshInstance3D.new()
		tile.mesh = HEX_FILE
		add_child(tile)
		tile.translate(Vector3(x, 0, y))
		tile.rotate(Vector3(1,0,0), deg_to_rad(90))
		tile.rotate(Vector3(0,1,0), deg_to_rad(30))
		tile.material_override = MARBLE_TEX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func world_updated(new_state: WorldState):
	#TODO: update world
	world_map = new_state.world_map
	print(new_state)
	
	

	

