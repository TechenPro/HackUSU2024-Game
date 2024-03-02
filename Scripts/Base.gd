class_name Base extends Node3D

@export
var id: int
@export
var loc: int
@export
var player_id: int
@export
var health: int
@export
var active: bool
@export
var is_main_base: bool
@export
var cooldown_queue_position: int
var obj_type: ServerEnums.ObjectType = ServerEnums.ObjectType.BASE

func _init(uid: int, pid: int, location: int, is_main=false):
	self.id = uid
	self.player_id = pid
	self.loc = location
	self.health = 5
	self.active = true
	self.cooldown_queue_position = -1
	self.is_main_base = is_main
