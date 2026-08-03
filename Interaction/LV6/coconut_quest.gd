extends StaticBody3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var gameInstant:Node3D = get_tree().current_scene

func collectCOCO() :
	player.cocoNUTLV5 = true
	gameInstant.collectedItem.append(self.get_path())
	self.queue_free()

func interact() :
	return 'INTERACTION_COLLECT_COCONUT'
