extends Node3D

@onready var animation_player: AnimationPlayer = $StatueL/AnimationPlayer
@onready var camera_3d: Camera3D = $Camera3D
@onready var playerNode : CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var animation_playerUI: AnimationPlayer = $AnimationPlayer
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var marker_3d: Marker3D = $Marker3D
@onready var line_edit: LineEdit = $CanvasLayer/LineEdit
@onready var bt_marker_3d: Marker3D = $BTMarker3D
@onready var reward_spawn: Marker3D = $RewardSpawn
@onready var area_3d: Area3D = $Area3D

# Sound
@onready var rock_moving: AudioStreamPlayer3D = $RockMoving
@onready var sp: AudioStreamPlayer3D = $SP

# Item
@export var RewardItem: PackedScene

@onready var isUsed = false
var playercamOrigin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("ArmatureAction_001")
	animation_player.stop()
	if Varibles.isFromLoadSaved :
		isUsed = Varibles.saved_data.miniGameLevel1State
		if isUsed :
			area_3d.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not isUsed :
		playerNode.SPEED = 0.0
		var playerCam: Camera3D = playerNode.get_node("CamOrigin/SpringArm3D/Camera3D")
		# -- Cam --
		playercamOrigin = playerCam.global_transform
		camera_3d.global_transform = playerCam.global_transform
		Varibles.tweenCam(camera_3d,"global_transform",marker_3d.global_transform,2)
		animation_playerUI.play("In")
		await Varibles.wait(0.05)
		# ---------		
		canvas_layer.show()
		camera_3d.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		animation_player.play("ArmatureAction_001")
		rock_moving.play()

#func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.is_in_group("player") :
		#animation_player.play_backwards("ArmatureAction_001")
		#animation_playerUI.play_section_backwards("In")
		#await animation_playerUI.animation_finished
		#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#playerCam.make_current()

func _on_close_pressed(wantAnimation: bool = true) -> void:
	var playerCam: Camera3D = playerNode.get_node("CamOrigin/SpringArm3D/Camera3D")
	if wantAnimation :
		animation_player.play_backwards("ArmatureAction_001")
		rock_moving.play()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_3d, "global_transform", playercamOrigin, 2)
	animation_playerUI.play_section_backwards("In")
	await tween.finished
	canvas_layer.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	playerCam.make_current()
	playerNode.SPEED = 3.0

func _on_button_pressed() -> void:
	if line_edit.text.length() > 5 :
		isUsed = true
		animation_playerUI.play_section_backwards("In")
		Varibles.tweenCam(camera_3d,"global_transform",bt_marker_3d.global_transform,2)
		animation_player.play("ArmatureAction_002")
		sp.play()
		await animation_player.animation_finished
		canvas_layer.hide()
		_on_close_pressed(true)
		var rewardItem = RewardItem.instantiate()
		get_tree().current_scene.add_child(rewardItem)
		rewardItem.savedItem = false
		rewardItem.CoinReward = 3
		rewardItem.enableGavity()
		rewardItem.global_transform = reward_spawn.global_transform
		await Varibles.wait(5)
		var gameInstance = get_tree().current_scene
		gameInstance.saveDat()
		area_3d.hide()
