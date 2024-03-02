extends Node3D
signal fight(dict)
signal build(dict)
signal wait(dict)
var unit = Unit.new(1, 2, "0,0")
func _ready():
	add_child(unit)
	var unit_dict = {
	"id": unit.id,
	"loc": unit.loc,
	"mov_range": unit.mov_range,
	"player_id": unit.player_id,
	"health": unit.health,
	"active": unit.active,
	"cooldown_queue_position": unit.cooldown_queue_position,
	"obj_type": unit.obj_type
	}
	fight.emit(unit_dict)
	build.emit(unit_dict)
	wait.emit(unit_dict)
