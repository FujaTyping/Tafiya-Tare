extends Control

@onready var pause: Control = $"."
@onready var open: AnimationPlayer = $Open
@onready var resume: Button = $MarginContainer/VBoxContainer/VBoxContainer/Resume
var paused = false

@onready var gameInstant = get_tree().current_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if self.visible == true :
			pauseMenu()
			return
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
			pauseMenu()


func _on_resume_pressed() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		UiSound.ui_click()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		open.play("CloseAnimation")
		#self.hide()
		get_tree().paused = false
		paused = false
		await open.animation_finished
		self.hide()

func _on_exit_pressed() -> void:
	var day_bgm: AudioStreamPlayer = get_tree().current_scene.get_node("dayBGM")
	var night_bgm: AudioStreamPlayer = get_tree().current_scene.get_node("nightBGM")
	var footsteps: AudioStreamPlayer3D = get_tree().current_scene.get_node("player/Walking")
	var waterFall: AudioStreamPlayer3D = get_tree().current_scene.get_node("WaterFall/Landscape_001/AudioStreamPlayer3D")
	footsteps.stop()
	day_bgm.stop()
	night_bgm.stop()
	waterFall.stop()
	Input.set_custom_mouse_cursor(null)
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
	UiSound.ui_click()
	get_tree().paused = false
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
	#get_tree().change_scene_to_file("res://UI/menu.tscn")

func _on_save_pressed() -> void:
	UiSound.ui_click()
	gameInstant.saveDat()
