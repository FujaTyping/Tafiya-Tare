extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"KaTongRuuSii A/AnimationPlayer"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var potionList:Array[PackedScene]
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var done: AudioStreamPlayer3D = $Done
@onready var marker_3d: Marker3D = $Marker3D
@onready var gameInstant:Node3D = get_tree().current_scene
@export var reward:PackedScene;
@onready var reward_spawner: Marker3D = $rewardSpawner

var isBrewing:bool = false;
var canGetReward:bool = true;

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		canGetReward = Varibles.saved_data.can_get_reward_level_4

func getRewardState() :
	return canGetReward
	
func getRewardLV4() :
	canGetReward = false;
	gameInstant.LV4GetReward = canGetReward
	var rewardItem = reward.instantiate()
	gameInstant.add_child(rewardItem)
	rewardItem.fuelValue = 80
	rewardItem.global_position = reward_spawner.global_position

func brew() :
	isBrewing = true;
	animation_player.play("ArmatureAction")
	audio_stream_player_3d.play()
	await animation_player.animation_finished
	animation_player.play("ArmatureAction")
	await animation_player.animation_finished
	var RnFlower = player.FlowInv
	if "pink" in RnFlower :
		spawnPotion(potionList[0])
	elif "purple" in RnFlower :
		spawnPotion(potionList[1])
	elif "white" in RnFlower :
		spawnPotion(potionList[2])
	done.play()
	player.resetFlowInv()
	isBrewing = false

func spawnPotion(scence:PackedScene) :
	var potion = scence.instantiate()
	get_tree().current_scene.add_child(potion)
	potion.global_position = marker_3d.global_position

func interact() :
	if isBrewing :
		return "BREWING_A_POTION"
	else :
		return "ON_INTERACTION_SUBMIT_QUEST_LEVEL_4"
