extends StaticBody3D

@export var farm_number:int;
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@export var plantScence:PackedScene;

var isGoodForPlant:bool = false;

func plantRice() :
	player.RiceSeed = player.RiceSeed - 1
	var playerPOS:Vector3 = player.global_position
	var thisSeed = plantScence.instantiate()
	thisSeed.isFarmLandQLT = isGoodForPlant
	thisSeed.global_position = Vector3(playerPOS.x,playerPOS.y - 0.6, playerPOS.z)
	get_tree().current_scene.add_child(thisSeed)
	thisSeed.startGrow()

func interact() :
	return "ON_INTERACTION_PLANT"
