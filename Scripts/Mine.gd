class_name Mine extends Node3D

@export
var id: int
@export
var pos: int
@export
var player_id: int
@export
var health: int
@export
var resource_remaining: int

func _init(uid: int, pid: int, pos: int):
	self.id = uid
	self.player_id = player_id
	self.pos = pos
	self.health = 1
	self.resource_remaining = (randi() % 7)*500
