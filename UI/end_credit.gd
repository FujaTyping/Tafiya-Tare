extends Control

@onready var animation: AnimationPlayer = $Animation
@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await Varibles.wait(1)
	animation.play("Play")
	v_box_container.show()
	await animation.animation_finished
	await Varibles.wait(2.5)
	startOver()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") :
		startOver() 
		
func startOver() :
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
	MenuMusic.stopEnd()
