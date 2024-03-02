class_name Action

var action_type: ServerEnums.ActionType
var final_pos: int
var target_pos: int
var actor_id: int

func _init(aid, a_type, f_pos=null, t_pos=null):
	actor_id=aid
	action_type=a_type
	final_pos=f_pos
	target_pos=t_pos

