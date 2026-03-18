extends Control

@onready var wm: Button = $VBoxContainer/VBoxContainer2/HBoxContainer/WM
@onready var animation_player_i: AnimationPlayer = $playerAnimation/AnimationPlayerI
@onready var animation_player: AnimationPlayer = $woman_player/AnimationPlayer
@onready var animation_player_j: AnimationPlayer = $playerAnimation/AnimationPlayerJ

# Camera
@onready var select_wm: Marker3D = $"../Marker/SelectWM"
@onready var camera_3d: Camera3D = $"../SubViewportContainer/SubViewport/Camera3D"
@onready var select_m: Marker3D = $"../Marker/SelectM"
@onready var player_selection_2: AnimationPlayer = $"../PlayerSelection2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		wm.grab_focus()
		DiscordRpc.updateRPC("Selecting character")
		
func playIdle() :
	animation_player.play("ArmatureAction_004")
	animation_player_i.play("ArmatureAction_004")

func _on_m_pressed() -> void:	
	player_selection_2.play_backwards("In")
	Varibles.playerSelection = "joker"
	animation_player_j.speed_scale = 0.3
	Varibles.tweenCam(camera_3d,"global_transform",select_m.global_transform,3.0)
	await Varibles.wait(0.5)
	animation_player_j.play("ArmatureAction_003")
	await animation_player_j.animation_finished
	next()

func _on_button_pressed() -> void:
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
	#get_tree().change_scene_to_file("res://UI/menu.tscn")

func _on_wm_pressed() -> void:	
	player_selection_2.play_backwards("In")
	Varibles.playerSelection = "sophia"
	animation_player.speed_scale = 0.3
	Varibles.tweenCam(camera_3d,"global_transform",select_wm.global_transform,3.0)
	await Varibles.wait(0.5)
	animation_player.play("ArmatureAction_003")
	await animation_player.animation_finished
	next()
	
func next() :
	#MenuMusic.stopmenumusic()
	self.hide()
	ScenesLoader.load_scene("uid://cofsjencilm7y")
	#get_tree().change_scene_to_file("res://game.tscn")
