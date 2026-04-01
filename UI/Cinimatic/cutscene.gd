extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	MenuMusic.stopmenumusic()
	await Varibles.wait(5)
	animation_player.play("SlideOut")

func _on_video_stream_player_finished() -> void:
	next()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") :
		next()
		
func next() :
	ScenesLoader.load_scene("uid://dm0rxd10m14f3")
