extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.0

@onready var pivot = $CamOrigin
@export var sens = 0.2
@export var joy_sens = 3.0
@onready var walking: AudioStreamPlayer3D = $Walking
@onready var jump: AudioStreamPlayer3D = $Jump

@onready var camera_3d: Camera3D = $CamOrigin/SpringArm3D/Camera3D
@onready var animation_player: AnimationPlayer = $playerAnimation/AnimationPlayer
@onready var animation_player_j: AnimationPlayer = $playerAnimation/AnimationPlayerJ
#@onready var animation_player_i: AnimationPlayer = $playerAnimation/AnimationPlayerI
@onready var Wanimation_player: AnimationPlayer = $woman_player/AnimationPlayer
@onready var Wanimation_player_j: AnimationPlayer = $woman_player/AnimationPlayerJ

# --- CAR VARIABLES ---
@onready var car_cam: Camera3D = $"../VehicleBody3D/CamArm/Camera3D"
@onready var car_node: Node3D = $"../VehicleBody3D"

@onready var player_animation: Node3D = $playerAnimation
@onready var woman_player: Node3D = $woman_player

var is_in_car: bool = false

func _ready():
	if Varibles.playerSelection == "joker" :
		player_animation.visible = true
	else :
		woman_player.visible = true
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if Input.is_action_just_pressed("toogleMouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	
	# --- INTERACTION LOGIC ---
	if Input.is_action_just_pressed("interaction"):
		if car_cam != null and car_node != null:
			
			if not is_in_car:
				var distance_to_car = global_position.distance_to(car_node.global_position)
				
				if distance_to_car < 3:
					# GET IN THE CAR
					is_in_car = true
					car_cam.current = true
					camera_3d.current = false
					visible = false 
					$CollisionShape3D.disabled = true 
					
					# ### NEW ### Tell the car to turn on!
					car_node.is_driven = true 
					
			else:
				# GET OUT OF THE CAR
				is_in_car = false
				car_cam.current = false
				camera_3d.current = true
				visible = true
				$CollisionShape3D.disabled = false
				
				global_position = car_node.global_position + (car_node.transform.basis.x * 0.5) + Vector3(1, 0, 0.25)
				car_node.is_driven = false

func _physics_process(delta: float) -> void:
	# --- Controller Look ---
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if look_dir.length() > 0:
		rotate_y(-look_dir.x * joy_sens * delta)
		pivot.rotate_x(-look_dir.y * joy_sens * delta)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	# -----------------------
	
	if is_in_car:
		return 

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump.play()
		if Varibles.playerSelection == "joker":
			animation_player_j.play("ArmatureAction_003")
		else :
			Wanimation_player_j.play("ArmatureAction_003")
		#animation_player_i.stop()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		#animation_player_i.stop()
		if Varibles.playerSelection == "joker":
			animation_player.play("ArmatureAction_002")
		else :
			Wanimation_player.play("ArmatureAction_002")
	else:
		walking.play()
		animation_player.stop()
		#animation_player_i.play("ArmatureAction_004")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
