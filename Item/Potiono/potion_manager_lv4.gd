extends Node

@export var potionName:String;
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var gameInstant:Node3D = get_tree().current_scene

func collectPotion() :
	player.PotionInv = potionName
	gameInstant.saveDat()
	self.queue_free()

func interact() :
	return "ON_INTERACTION_POTION_COLLECT";
