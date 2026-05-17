extends RigidBody3D

@export var completeQuestReward:int = 0
@export var isJar: bool = false
@export var foodName: String;

@onready var gameInstant = get_tree().current_scene

func getFood() :
	Varibles.Coins += completeQuestReward
	self.visible = false
	self.set_collision_layer_value(2,false)
	if isJar :
		get_tree().current_scene.get_node("JarMaker").resetJar()
	self.queue_free()

func interact():
	return "ON_INTERACTION_FOOD_COLLECT"
