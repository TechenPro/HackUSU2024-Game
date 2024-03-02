class_name WorldState extends Node

var world_map: TerrainMap
var object_location_map: Dictionary = {}
var world_objects: Dictionary = {}

func _init(wld_map, obj_map, wld_objs):
	self.world_map = wld_map
	self.object_location_map = obj_map
	self.world_objects = wld_objs
