extends Node3D

@export var requirePotion:String;
@export var NPCIndex:int = 0;
var currentState:int = 0;
@export var dialogStart:Node3D;
@export var submitBody:StaticBody3D;
@export var failedDialog:Node3D;
@export var passDialog:Node3D;

@onready var gameInstant:Node3D = get_tree().current_scene
@onready var playerInstant:Node3D = get_tree().current_scene.get_node('player');

@onready var dialogStartPOS:Vector3 = dialogStart.global_position
@onready var submitBodyPOS:Vector3 = submitBody.global_position
@onready var failedPOS:Vector3 = failedDialog.global_position
@onready var passPOS:Vector3 = passDialog.global_position
@onready var marker_3d: Marker3D = $Marker3D

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		currentState = Varibles.saved_data.state_quest_level_4[NPCIndex]
		changeState(currentState)
	else :
		changeState(0)
		
	if requirePotion :
		submitBody.targetPotion = requirePotion
		
func dialogEnd() :
	changeState(1)

func changeState(state:int) :
	currentState = state
	gameInstant.NPCV4S[NPCIndex] = state
	if state == 0 :
		dialogStart.global_position = marker_3d.global_position
	elif state == 1 :
		dialogStart.global_position = dialogStartPOS
		submitBody.global_position = marker_3d.global_position

func questDone() :
	passDialog.global_position = playerInstant.global_position
	await Varibles.wait(0.25)
	passDialog.global_position = passPOS

func questFail() :
	failedDialog.global_position = playerInstant.global_position
	await Varibles.wait(0.25)
	failedDialog.global_position = failedPOS

func interact() :
	return "INTERACTION_SUBMIT_QUEST_LEVEL_4"
