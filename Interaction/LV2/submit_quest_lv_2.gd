extends Node3D

@onready var default: Node3D = $Default
@onready var marker_3d: Marker3D = $Marker3D
@onready var submit: StaticBody3D = $Submit
@export var Reward:PackedScene;
@onready var reward_spawner: Marker3D = $RewardSpawner
@onready var gameInstant:Node3D = get_tree().current_scene

@onready var defaultPOS:Vector3 = default.global_position
@onready var submitPOS:Vector3 = submit.global_position

var state:int = 0;

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		var savedState = Varibles.saved_data.quest_level_2_state
		changeState(savedState)
	else :
		changeState(0)
	
func changeState(stateN) :
	if stateN == 1 :
		default.global_position = defaultPOS
		submit.global_position = marker_3d.global_position
	elif stateN == 0 :
		default.global_position = marker_3d.global_position
		
func dialogEnd(params) :
	if params == 'First' :
		state = 1
		changeState(1)
	elif params == 'Done' :
		state = 2
		var reward = Reward.instantiate()
		reward.fuelValue = 50
		reward.saveToremoveList = false
		reward.global_position = reward_spawner.global_position
		get_tree().current_scene.add_child(reward)
	gameInstant.QLV2State = state
