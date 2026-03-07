extends Control

@onready var pause: Control = $"."
@onready var open: AnimationPlayer = $Open
@onready var resume: Button = $MarginContainer/VBoxContainer/VBoxContainer/Resume
var paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


func _on_resume_pressed() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		open.play("CloseAnimation")
		#self.hide()
		get_tree().paused = false
		paused = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func pauseMenu() :
	if paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		open.play("CloseAnimation")
		await open.animation_finished
		pause.visible = false
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause.visible = true
		open.play("PauseAnimation")
		resume.grab_focus()
	paused = !paused  # Flip the paused state

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/menu.tscn")
