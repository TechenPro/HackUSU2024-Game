class_name Player

var id: int
var visibility_map: Dictionary
var unit_set: Dictionary
var base_set: Dictionary
var main_base_id: int


func _init(uid):
	self.id = uid
	visibility_map = {}
	unit_set = {}
	base_set = {}
	


