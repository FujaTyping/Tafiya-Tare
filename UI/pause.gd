extends Control

@onready var pause: Control = $"."
@onready var open: AnimationPlayer = $Open
@onready var resume: Button = $MarginContainer/VBoxContainer/VBoxContainer/Resume
var paused = false

# Save Stuff
@export var player : CharacterBody3D
@onready var car: VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")
@onready var gameInstance: Node3D = get_tree().current_scene

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
	get_tree().paused = false
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
	#get_tree().change_scene_to_file("res://UI/menu.tscn")

func _on_save_pressed() -> void:
	var data = gameData.new()
	data.player_position = player.global_position
	data.player_rotation = player.rotation_degrees
	data.car_position = car.global_position
	data.car_rotation = car.rotation_degrees
	data.car_fuel = car.carFuel
	data.player_coins = Varibles.Coins
	data.game_time = gameInstance.getDN()
	data.player_selection = Varibles.playerSelection
	
	ResourceSaver.save(data,"user://save_data.res")
