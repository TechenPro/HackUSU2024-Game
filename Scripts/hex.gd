extends Node3D

const TILE_SIZE := 1.5
const HEX_FILE = preload("res://Assets/hex_pillar.glb")

@export var grid_size := 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_grid()

func _generate_grid():
	var tile_index := 0
	for x in range(grid_size):
		var tile_coordinate := Vector2.ZERO
		tile_coordinate.x = x * TILE_SIZE * cos(deg_to_rad(30))
		tile_coordinate.y = 0 if x%2 == 0 else TILE_SIZE/2		
		for y in range(grid_size):
			var tile = HEX_FILE.instantiate()
			add_child(tile)
			tile.translate(Vector3(tile_coordinate.x, 0, tile_coordinate.y))
			tile_coordinate.y += TILE_SIZE
			tile.get_node("Hex Pillar").material_override
			tile_index += 1
