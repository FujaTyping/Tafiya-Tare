extends RigidBody3D

@export var completeQuestReward:int = 0

@onready var gameInstant = get_tree().current_scene

func getFood() :
	Varibles.Coins += completeQuestReward
	self.visible = false
	self.set_collision_layer_value(2,false)
	self.queue_free()

func interact():
	return "ON_INTERACTION_FOOD_COLLECT"
