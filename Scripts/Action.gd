class_name Action

var action_type: ServerEnums.ActionType
var final_pos: String
var target_pos: String
var actor_id: String

func _init(aid, a_type, f_pos=null, t_pos=null):
	actor_id=aid
	action_type=a_type
	final_pos=f_pos
	target_pos=t_pos

