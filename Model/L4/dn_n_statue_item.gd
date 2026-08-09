extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"DnN Statue Ameture/AnimationPlayer"
@export var isItem:bool = true;
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var gameInstant:Node3D = get_tree().current_scene

func _ready() -> void:
	animation_player.play("Init");

func collectDnNStatue() :
	player.isCollectDnNStatue = true
	gameInstant.collectedItem.append(self.get_path())
	gameInstant.collectStatueLV4 = true
	gameInstant.saveDat()
	self.queue_free()

func interact() :
	if not isItem: return
	return "ON_INTERACTION_COLLECT"
