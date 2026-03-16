extends RigidBody3D

@export var CoinReward: int
@export var savedItem: bool = true
@export var usedGravity: bool = false
@onready var gameInstant = get_tree().current_scene
	
func _ready() -> void:
	if not usedGravity:
		gravity_scale = 0.0
	else:
		gravity_scale = 1.0

func enableGavity() :
	gravity_scale = 1.0

func clear_trash() :
	Varibles.Coins += CoinReward
	self.visible = false
	self.set_collision_layer_value(2,false)
	if savedItem :
		gameInstant.collectedItem.append(self.get_path())
	self.queue_free()

func interact() :
	return "ON_INTERACTION_COLLECT_TRASH"
