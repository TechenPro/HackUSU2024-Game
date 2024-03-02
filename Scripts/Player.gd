class_name Player extends Node3D

@export
var id: int
var visibility_map: Dictionary
var unit_list: Dictionary
var base_list: Dictionary


func _init(uid):
	self.id = uid
	visibility_map = {}
	unit_list = {}
	base_list = {}
	


