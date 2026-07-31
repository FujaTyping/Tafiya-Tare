extends Area3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var Transition:Control = get_tree().current_scene.get_node('Transition')
@onready var BgTransition:ColorRect = get_tree().current_scene.get_node('Transition/ColorRect')
@onready var TransitionAnimation:AnimationPlayer = get_tree().current_scene.get_node('Transition/AnimationPlayer')
@onready var night_bgm: AudioStreamPlayer = $"../nightBGM"
@onready var day_bgm: AudioStreamPlayer = $"../dayBGM"

# ListCam
@onready var _1: Camera3D = $"../EndingCam/1"
@onready var c_2: Marker3D = $"../EndingCam/C2"
@onready var c_3: Marker3D = $"../EndingCam/C3"
@onready var _2: Camera3D = $"../EndingCam/2"
@onready var c_4: Marker3D = $"../EndingCam/C4"
@onready var c_5: Marker3D = $"../EndingCam/C5"
@onready var _3: Camera3D = $"../EndingCam/3"

func _on_body_entered(body: Node3D) -> void:
	if body != player :
		return
	get_tree().current_scene.isEnding = true
	BgTransition.color = Color(1.0, 1.0, 1.0, 1.0)
	await Varibles.wait(1)
	Transition.show()
	player.ending()
	await Varibles.wait(2)
	TransitionAnimation.play('IO')
	await Varibles.wait(0.5)
	Varibles.tweenCam(night_bgm,'volume_db',-80,1)
	Varibles.tweenCam(day_bgm,'volume_db',-80,1)
	get_tree().current_scene.hideGameGUI()
	_1.make_current()
	await Varibles.wait(3)
	MenuMusic.playEnd()
	TransitionAnimation.play_backwards()
	await TransitionAnimation.animation_finished
	Transition.hide()
	# Begin Cam
	await Varibles.wait(1)
	Varibles.tweenCam(_1,'global_transform',c_2.global_transform,15)
	await Varibles.wait(14)
	Varibles.tweenCam(_1,'global_transform',c_3.global_transform,25)
	await Varibles.wait(24)
	_2.make_current()
	Varibles.tweenCam(_2,'global_transform',c_4.global_transform,35)
	await  Varibles.wait(34)
	_3.make_current()
	Varibles.tweenCam(_3,'global_transform',c_5.global_transform,20)
	await Varibles.wait(19)
	ScenesLoader.load_scene("uid://bvlv0jtma8aq6")
