extends StaticBody3D

@export var CoinReward: int
@onready var gameInstant = get_tree().current_scene

func clear_trash() :
	Varibles.Coins += CoinReward
	self.visible = false
	self.set_collision_layer_value(2,false)
	gameInstant.collectedItem.append(self.get_path())
	self.queue_free()

func interact() :
	return "ON_INTERACTION_COLLECT_TRASH"
