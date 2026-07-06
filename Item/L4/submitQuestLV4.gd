extends Node

@onready var player:CharacterBody3D = get_tree().current_scene.get_node("player")
@export var targetPotion:String;
@export var mainQuestSub:Node3D;

func _ready() -> void:
	print(targetPotion);

func submitQuestLevel4() :
	var PItem:String = player.PotionInv
	if PItem == targetPotion :
		mainQuestSub.questDone()
		player.resetPotionInv()
	else :
		mainQuestSub.questFail()

func interact() :
	return "INTERACTION_SUBMIT_QUEST_LEVEL_4"
