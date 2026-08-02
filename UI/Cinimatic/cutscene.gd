extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var vdo: AnimationPlayer = $VDO
@onready var cc: AnimationPlayer = $CC
@onready var label: Label = $MarginContainer2/Label

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	MenuMusic.stopmenumusic()
	await Varibles.wait(2)
	video_stream_player.play()
	vdo.play("VDO_On")
	onCCBegins()
	await Varibles.wait(5)
	animation_player.play("SlideOut")

func onCCBegins() :
	label.text = "INTRO_CC_1"
	cc.play("FadeIO")
	await Varibles.wait(1.5)
	cc.play_backwards("FadeIO")
	await Varibles.wait(1.25)
	label.text = "INTRO_CC_2"
	cc.play("FadeIO")
	await Varibles.wait(2.5)
	cc.play_backwards("FadeIO")
	await  Varibles.wait(1)
	label.text = "INTRO_CC_3"
	cc.play("FadeIO")
	await Varibles.wait(1.5)
	cc.play_backwards("FadeIO")
	await Varibles.wait(1)
	label.text = "INTRO_CC_4"
	cc.play("FadeIO")
	await Varibles.wait(3.5)
	cc.play_backwards("FadeIO")
	await Varibles.wait(1)
	label.text = "INTRO_CC_5"
	cc.play("FadeIO")
	await Varibles.wait(1)
	cc.play_backwards("FadeIO")
	await Varibles.wait(1.5)
	label.text = "INTRO_CC_6"
	cc.play("FadeIO")
	await Varibles.wait(2)
	cc.play_backwards("FadeIO")
	await Varibles.wait(1)
	label.text = "INTRO_CC_7"
	cc.play("FadeIO")
	await Varibles.wait(1)
	cc.play_backwards("FadeIO")
	await Varibles.wait(1.25)
	label.text = "INTRO_CC_8"
	cc.play("FadeIO")
	await Varibles.wait(2.5)
	cc.play_backwards("FadeIO")
	
func _on_video_stream_player_finished() -> void:
	await Varibles.wait(1)
	next()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") :
		video_stream_player.stop()
		next()
		
func next() :
	ScenesLoader.load_scene("uid://dm0rxd10m14f3")
