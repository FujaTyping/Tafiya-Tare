extends StaticBody3D

@export var statueItem:PackedScene;
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var playerCam:Camera3D;
@onready var camera_3d: Camera3D = $Camera3D
var alreadyUse:bool = false;
@onready var c_1: Marker3D = $c1
@onready var c_2: Marker3D = $c2
@onready var gameInstant:Node3D = get_tree().current_scene
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var tick: AudioStreamPlayer3D = $Tick

func _ready() -> void:
	playerCam = player.get_node('SpringArm3D/Camera3D')
	if Varibles.isFromLoadSaved :
		alreadyUse = Varibles.saved_data.is_activate_statue
		if alreadyUse :
			var THISstatueItem = statueItem.instantiate()
			THISstatueItem.global_transform = marker_3d_2.global_transform
			get_tree().current_scene.add_child.call_deferred(THISstatueItem)
		
func placeStatue() :
	if alreadyUse : return
	alreadyUse = true
	gameInstant.isStatueActivate = true
	var THISstatueItem = statueItem.instantiate()
	THISstatueItem.isItem = false
	THISstatueItem.global_transform = marker_3d.global_transform
	get_tree().current_scene.add_child(THISstatueItem)
	Varibles.tweenCam(THISstatueItem,'global_transform',marker_3d_2.global_transform,7)
	camera_3d.global_transform = playerCam.global_transform
	await Varibles.wait(0.05)
	camera_3d.make_current()
	Varibles.tweenCam(camera_3d,'global_transform',c_1.global_transform,2);
	await Varibles.wait(2.1)
	Varibles.tweenCam(camera_3d,'global_transform',c_2.global_transform,5);
	await Varibles.wait(1.5)
	audio_stream_player_3d.play()
	get_tree().current_scene.fastForwardNight()
	playTick()
	await Varibles.wait(3.6)
	Varibles.tweenCam(camera_3d,'global_transform',playerCam.global_transform,8);
	await Varibles.wait(8.1)
	playerCam.make_current()

func playTick() :
	tick.play()
	while get_tree().current_scene.day_night.current_animation_position < 485:
		await get_tree().process_frame
	tick.stop()

func interact() :
	if alreadyUse: return ""
	return "ON_INTERACTION_PLACE_STATUE"
