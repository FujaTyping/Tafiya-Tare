extends Area3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var Transition:Control = get_tree().current_scene.get_node('Transition')
@onready var BgTransition:ColorRect = get_tree().current_scene.get_node('Transition/ColorRect')
@onready var TransitionAnimation:AnimationPlayer = get_tree().current_scene.get_node('Transition/AnimationPlayer')
@onready var night_bgm: AudioStreamPlayer = $"../nightBGM"
@onready var day_bgm: AudioStreamPlayer = $"../dayBGM"
@onready var ending_text: Control = $"../EndingText"
@onready var label: Label = $"../EndingText/Label"
@onready var ETanimation_player: AnimationPlayer = $"../EndingText/AnimationPlayer"
@onready var e_overlay: Control = $"../EOverlay"
@onready var end_overlay: AnimationPlayer = $"../EOverlay/EndOverlay"

# ListCam
@onready var _1: Camera3D = $"../EndingCam/1"
@onready var c_2: Marker3D = $"../EndingCam/C2"
@onready var c_3: Marker3D = $"../EndingCam/C3"
@onready var _2: Camera3D = $"../EndingCam/2"
@onready var c_4: Marker3D = $"../EndingCam/C4"
@onready var c_5: Marker3D = $"../EndingCam/C5"
@onready var _3: Camera3D = $"../EndingCam/3"

@onready var skip: MarginContainer = $"../Skip"
@onready var animation_player: AnimationPlayer = $"../Skip/AnimationPlayer"

@export var endingVAs:Array[AudioStreamWAV];
@onready var v_as: AudioStreamPlayer = $"../EndingText/VAs"

func playVAs(vaindex:Array[int],waitSec:int) :
	await Varibles.wait(1)
	var isEnd = 0;
	for i in vaindex :
		isEnd += 1
		var vaStream:AudioStreamWAV = endingVAs[i]
		v_as.stream = vaStream
		v_as.play()
		if isEnd != vaindex.size() :
			await Varibles.wait(waitSec + 3)

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
	ending_text.show()
	e_overlay.show()
	end_overlay.play("OVE")
	MenuMusic.playEnd()
	TransitionAnimation.play_backwards()
	await TransitionAnimation.animation_finished
	Transition.hide()
	# Begin Cam
	await Varibles.wait(1)
	animation_player.play("Fade")
	await Varibles.wait(0.05)
	skip.show()
	changeTextEnding(['ENDING_CINEMATIC_TEXT_1','ENDING_CINEMATIC_TEXT_2','ENDING_CINEMATIC_TEXT_3'],8,2)
	Varibles.tweenCam(_1,'global_transform',c_2.global_transform,15)
	playVAs([0,1,2],10)
	await Varibles.wait(5)
	animation_player.play("Slide")
	await Varibles.wait(9)
	Varibles.tweenCam(_1,'global_transform',c_3.global_transform,25)
	await Varibles.wait(24)
	_2.make_current()
	changeTextEnding(['ENDING_CINEMATIC_TEXT_4','ENDING_CINEMATIC_TEXT_5'],10,2)
	Varibles.tweenCam(_2,'global_transform',c_4.global_transform,35)
	playVAs([3,4],12)
	await  Varibles.wait(34)
	_3.make_current()
	changeTextEnding(['ENDING_CINEMATIC_TEXT_6'],10,0)
	Varibles.tweenCam(_3,'global_transform',c_5.global_transform,20)
	playVAs([5],10)
	await Varibles.wait(19)
	ScenesLoader.load_scene("uid://bvlv0jtma8aq6")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().current_scene.isEnding :
		ScenesLoader.load_scene('uid://bvlv0jtma8aq6')

func changeTextEnding(TextA:Array[String],waitSec:int,waitBetween:int) :
	for Text in TextA :
		label.text = Text
		ETanimation_player.play('Fade')
		label.show()
		await ETanimation_player.animation_finished
		await Varibles.wait(waitSec - 0.5)
		ETanimation_player.play_backwards()
		await ETanimation_player.animation_finished
		label.hide()
		if waitBetween > 0 :
			await Varibles.wait(waitBetween)
