class_name PlayerWorld extends Node

#var world_state: WorldState

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Player instantiated: ", multiplayer.get_unique_id())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#@rpc("authority", "call_local")
#func world_updated(new_state: WorldState):
	##update world
	#var a = Action.new(id, ServerEnums.ActionType.BUILD)
	#self.server.commit_action.rpc_id(1, a)
	#pass
