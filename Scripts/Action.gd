struct Action extends Node3D:
	var playerID:int
	var sourceObj:Node
	var act:ActionType
	var endPos
	
	enum ActionType {Move, Attack, Build}
		
