extends StaticBody3D

@onready var gameInstant = get_tree().current_scene

@export var saveItem: bool = true
#@export var thumnailsIn: CompressedTexture2D
@export var InName:String

func add_ingredientLevel3() :
	self.visible = false
	self.set_collision_layer_value(2,false)
	if saveItem :
		gameInstant.collectedItem.append(self.get_path())
	self.queue_free()

func interact() :
	return "ON_INTERACTION_ADD_INGREDIENT"
