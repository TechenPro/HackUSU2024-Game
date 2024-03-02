class_name Unit extends Node3D

@export
var id: int
@export
var loc: int
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

func _init(uid: int, pid: int, location: int):
	self.id = uid
	self.player_id = pid
	self.loc = location
	self.mov_range = 5
	self.health = 1
	self.active = true
	self.cooldown_queue_position = -1

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Emit the signal with the unit's info as a dictionary
		emit_signal("unit_selected", {
			"id": id,
			"loc": loc,
			"mov_range": mov_range,
			"player_id": player_id,
			"health": health,
			"active": active,
			"cooldown_queue_position": cooldown_queue_position,
			"obj_type": obj_type
		})
