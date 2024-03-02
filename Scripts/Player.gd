class_name Player

var id: int
var visibility_map: Dictionary
var unit_set: Dictionary
var base_set: Dictionary
var main_base_id: int
var resource_count: int


func _init(uid):
	self.id = uid
	visibility_map = {}
	unit_set = {}
	base_set = {}
	
@rpc("authority", "call_local")
func world_updated(world_state):
	#update world
	pass
	
func can_build():
	return resource_count >= 5

func build_spend():
	resource_count -= 5

func can_recruit():
	return resource_count >= 2

func recruit_spend():
	resource_count -= 2
