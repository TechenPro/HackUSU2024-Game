class_name ServerWorld extends Node3D

# Exposed fields to import resources into
@export
var map_coord_set: Array = [[0,0],[0,1],[0,-1],[1,0],[-1,0], [4, 3], [4, 4], [1,2], [0,-3], [0,-2]]
@export
var valid_start_locations: Array = [[[0,0], [0,1]], [[4,3], [4,4]]]

signal World_Updated(world_state:WorldState)
signal simp_World_Updated(world_state:WorldState)
const simpleworldstate:String = "I like trains"

# Generates uids for all objects
static var id_counter = 0

var world_map: TerrainMap
var action_queue: Array = []
var player_list: Dictionary = {}
var object_location_map: Dictionary = {}
var world_objects: Dictionary = {}
var mine_set: Dictionary = {}

func _init():
	# Load world map
	world_map = TerrainMap.new()
	world_map.load_map(map_coord_set)
	

	# Load players
	# for p in multiplayer.get_peers():
	for p in [1,2]:
		player_list[p] = Player.new(p)
		load_initial_player_location(p, valid_start_locations.pop_back())

	# Setup Variable Mines
	
# Players call this function to add their action to the queue
# commit_action.rpc_id(1, action) 
@rpc("any_peer", "call_local")
func commit_action(action: Action):
	action_queue.push_back(action)

func _process(_delta):
	if action_queue:
		process_action(action_queue.pop_front())

func process_action(action: Action):
	var result = {}
	match action.action_type:
		ServerEnums.ActionType.WAIT:
			result = resolve_wait(action)
		ServerEnums.ActionType.ATTACK:
			result = resolve_attack(action)
		ServerEnums.ActionType.BUILD:
			result = resolve_build(action)
		ServerEnums.ActionType.MINE:
			pass
		ServerEnums.ActionType.RECRUIT:
			result = resolve_recruit(action)
	
	# Advance Cooldown Queue
	if not result["success"]:
		return
	pass
	
	# Emit world state delta to clients
	World_Updated.emit(WorldState.new(world_map,
	object_location_map,
	world_objects))
	
func get_world_state():
	print(multiplayer.get_unique_id(), " getting world state")
	var ws:WorldState = WorldState.new(world_map, object_location_map, world_objects)
	print("State: ", ws)
	return ws
	

@rpc("authority", "call_local", "reliable")
func load_initial_player_location(pid, loc_set):
	var base_loc = TerrainMap.coord_to_key(loc_set[0][0], loc_set[0][1])
	var unit_loc = TerrainMap.coord_to_key(loc_set[1][0], loc_set[1][1])
	# var mine_loc = TerrainMap.coord_to_key(loc_set[2][0], loc_set[2][1])
	build_base(pid, base_loc, true)
	build_unit(pid, unit_loc)
	# build_mine(mine_loc, true)

func build_base(pid, loc, is_main=false):
	# Need to handle instantiation into the scene !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	var b = Base.new(ServerWorld.next_id(), pid, loc, is_main)
	world_objects[b.id] = b
	object_location_map[loc] = b.id

func build_unit(pid, loc):
	# Need to handle instantiation into the scene !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	var u = Unit.new(ServerWorld.next_id(), pid, loc)
	world_objects[u.id] = u
	object_location_map[loc] = u.id

func build_mine(loc, is_main=false):
	pass

func resolve_attack(action: Action):
	var aid = action.actor_id
	# Only Unit objects can initiate an attack
	if check_world_obj_type(aid) == ServerEnums.ObjectType.UNIT:
		var tid = grab_object_id_by_location(action.target_pos)
		#  Only a Unit or Base may be the target of an attack
		if tid and check_world_obj_type(tid) in [ServerEnums.ObjectType.UNIT, ServerEnums.ObjectType.BASE]:
			# Verify Movement and Attack Range
			var path =  validate_movement(world_objects[aid].loc, action.final_pos, world_objects[aid].mov_range)
			if path and validate_attack_target(action.final_pos, action.target_pos):
				deal_damage(tid)
				return path
	return false

func resolve_wait(action: Action):
	var aid = action.actor_id
	# Only Unit objects can wait
	if check_world_obj_type(aid) == ServerEnums.ObjectType.UNIT:
		# Verify Movement
		return validate_movement(world_objects[aid].loc, action.final_pos, world_objects[aid].mov_range)
	return false

func resolve_build(action: Action):
	var aid = action.actor_id
	# Only Unit objects can build
	if check_world_obj_type(aid) == ServerEnums.ObjectType.UNIT:
		var path =  validate_movement(world_objects[aid].loc, action.final_pos, world_objects[aid].mov_range)
		if path and validate_spawn_target(action.final_pos, action.target_pos):
			var pid = world_objects[aid].player_id
			if player_list[pid].can_build():
				build_base(pid, action.target_pos)
				player_list[pid].build_spend()
				return path
	return false

func resolve_recruit(action: Action):
	var aid = action.actor_id
	# Only Base objects can build
	if check_world_obj_type(aid) == ServerEnums.ObjectType.BASE:
		if validate_spawn_target(world_objects[aid].loc, action.target_pos):
			var pid = world_objects[aid].player_id
			if player_list[pid].can_recruit():
				build_unit(pid, action.target_pos)
				player_list[pid].recruit_spend()
				return true
	return false

# Verifies the given object id is valid and returns its obj_type field if it can. Returns false otherwise
func check_world_obj_type(id):
	if not world_objects.has(id):
		return false
	var result = world_objects[id].get("obj_type")
	if result == null:
		return false
	return result

func grab_object_id_by_location(loc):
	if object_location_map.has(loc):
		return object_location_map[loc]
	return false

func validate_movement(start, end, max_range):
	return world_map.bfs(start, end, max_range, object_location_map)

func validate_attack_target(atk_pos, tgt_pos):
	if world_objects.has(tgt_pos):
		if tgt_pos in world_map[atk_pos]:
			return true
	return false

func validate_spawn_target(builder_pos, tgt_pos):
	if tgt_pos in world_map[builder_pos]:
		if not object_location_map.has(tgt_pos):
			return true
	return false

func deal_damage(target):
	var t_type = check_world_obj_type(target)
	if t_type == ServerEnums.ObjectType.UNIT:
		# Kill Unit
		pass
	elif t_type == ServerEnums.ObjectType.BASE:
		# Damage Base
		# Check For Death
		# Check Loss Condition
		# |--Handle Player Removal
		pass

static func next_id():
	ServerWorld.id_counter += 1
	return ServerWorld.id_counter
	
