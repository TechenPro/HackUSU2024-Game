class_name World extends Node3D

var isServer:bool
var world_map:WorldMap
var players:ItemList
var ActionQ:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	# Networking code
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# client code
	
	# server code
	if (!isServer):
		return
		
	if (ActionQ.is_empty()):
		pass
	else:
		process_action(ActionQ.pop_front())
	pass

func process_action(Action a):
	switch (a.)
	
	pass
