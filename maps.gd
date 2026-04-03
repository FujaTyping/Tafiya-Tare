extends Control

@onready var player:CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var vehicle_body_3d: VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")
@onready var AIn: AnimationPlayer = $In
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var prevPlayerSpeed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_3d.global_position.y = 15
	prevPlayerSpeed = player.DSPEED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("map") :
		if self.visible == false and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :			
			player.SPEED = 0
			AIn.play("In")
			#canvas_layer.show()
			self.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else :
			AIn.play_backwards("In")
			await AIn.animation_finished
			self.hide()
			#canvas_layer.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			player.SPEED = prevPlayerSpeed
	
	if self.visible == true :
		if Input.is_action_just_pressed("scrollUp") :
			if camera_3d.global_position.y > 10.42806816101074 :
				camera_3d.global_position.y -= 0.5
		if Input.is_action_just_pressed("scrollDown") :
			if camera_3d.global_position.y < 70.4280681610107 :
				camera_3d.global_position.y += 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_in_car :
		camera_3d.global_position.x = vehicle_body_3d.global_position.x
		camera_3d.global_position.z = vehicle_body_3d.global_position.z
	else :
		camera_3d.global_position.x = player.global_position.x
		camera_3d.global_position.z = player.global_position.z
