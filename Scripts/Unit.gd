class_name Unit extends Node3D

@export
var id: int
@export
var pos: int
@export
var mov_range: int
@export
var player_id: int
@export
var health: int
@export
var is_active: bool
@export
var cooldown_queue_position: int

func _init(uid: int, pid: int, pos: int):
	self.id = uid
	self.player_id = player_id
	self.pos = pos
	self.mov_range = 0
	self.health = 1
	self.is_active = true
	self.cooldown_queue_position = -1
