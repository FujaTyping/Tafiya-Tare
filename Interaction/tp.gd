extends StaticBody3D

@export var direction:String
@export var destination:Marker3D
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')

func treeLV2TP() :
	player.global_position = destination.global_position

func interact() :
	return "ON_INTERACTION_GOING_" + direction;
