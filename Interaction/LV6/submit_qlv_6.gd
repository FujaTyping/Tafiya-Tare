extends Node3D

@onready var marker_3d: Marker3D = $Marker3D
@onready var dialoge_trigged: Node3D = $Start
@onready var submit: StaticBody3D = $Submit
@onready var done: Node3D = $Done
@export var rewardScemce:PackedScene;
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var startDialogPOS:Vector3 = dialoge_trigged.global_position
@onready var submitPOS:Vector3 = submit.global_position
@onready var donePOS:Vector3 = done.global_position
@onready var reward: Marker3D = $reward

var state:int = 0

func dialogEnd(params) :
	if params == 'One' :
		changeState(1)
	elif params == 'End' :
		state = 2
		get_tree().current_scene.stateQLV5 = 2
		audio_stream_player_3d.play()
		submit.global_position = submitPOS
		done.global_position = marker_3d.global_position
	elif params == 'Reward' :
		var thisReward = rewardScemce.instantiate()
		thisReward.fuelValue = 35
		thisReward.saveToremoveList = false
		thisReward.global_position = reward.global_position
		get_tree().current_scene.add_child(thisReward)
		get_tree().current_scene.addAchivement(4)

func changeState(Tstate:int) :
	if state == 1 :
		dialoge_trigged.global_position = startDialogPOS
		submit.global_position = marker_3d.global_position
	state = Tstate
	get_tree().current_scene.stateQLV5 = Tstate

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		state = Varibles.saved_data.quest_state_level_6
		changeState(state)
	dialoge_trigged.global_position = marker_3d.global_position
