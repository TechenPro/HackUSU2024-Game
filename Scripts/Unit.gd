class_name Unit extends Node3D

@export
var id: int
@export
var loc: String
@export
var mov_range: int
@export
var player_id: int
@export
var health: int
@export
var active: bool
@export
var cooldown_queue_position: int
var obj_type: ServerEnums.ObjectType = ServerEnums.ObjectType.UNIT

func _init(uid: int, pid: int, location: String):
	self.id = uid
	self.player_id = pid
	self.loc = location
	self.mov_range = 5
	self.health = 1
	self.active = true
	self.cooldown_queue_position = -1	
	


