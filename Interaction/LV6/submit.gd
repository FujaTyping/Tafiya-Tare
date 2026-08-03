extends StaticBody3D

@export var triggedNode:Node3D;

func submitCOCO() :
	triggedNode.dialogEnd('End')

func interact() :
	return "INTERACTION_SUBMIT_QUEST_LEVEL_4"
