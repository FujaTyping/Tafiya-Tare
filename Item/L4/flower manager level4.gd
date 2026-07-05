extends Node

@onready var gameInstant:Node3D = get_tree().current_scene
@export var flower_name:String

func collectFlower() :
	gameInstant.collectedItem.append(self.get_path())
	self.queue_free()

func interact() :
	return "ON_INTERACTION_COLLECT_FLOWER"
