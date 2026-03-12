extends CharacterBody3D

var SPEED = 3.0
var JUMP_VELOCITY = 4.0

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
@onready var engine_start: AudioStreamPlayer3D = $"../VehicleBody3D/EngineStart"
@onready var engine_stop: AudioStreamPlayer3D = $"../VehicleBody3D/EngineStop"
@onready var engine_idle: AudioStreamPlayer3D = $"../VehicleBody3D/CarIdle"
@onready var Fuelmargin_container: CanvasLayer = $"../VehicleBody3D/CanvasLayer"

@onready var looking_cast: RayCast3D = $LookingCast
@onready var interact: MarginContainer = $Interact
@onready var inter_show: AnimationPlayer = $InterShow
@onready var label: Label = $Interact/HBoxContainer/Label
@onready var label_2: Label = $Interact/HBoxContainer/Label2
@onready var wrong: AudioStreamPlayer3D = $Wrong

# Trash Collect
@onready var trash_collect: AudioStreamPlayer3D = $TrashCollect
@onready var fuel_collect: AudioStreamPlayer3D = $FuelCollect

var is_in_car: bool = false
var isInViewInteract = false
var interActionJustPress = false

func _ready():
	sens = Varibles.MouseSens
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
		if looking_cast.is_colliding() :
			if looking_cast.get_collider().has_method("addFuel") :
				#interActionJustPress = true
				#sens = 0
				if looking_cast.get_collider().checkCanBuy() :
					fuel_collect.play()
					looking_cast.get_collider().addFuel()
				else :
					wrong.play()
				#sens = Varibles.MouseSens
				#interActionJustPress = false
			if looking_cast.get_collider().has_method("clear_trash") :
				trash_collect.play()
				looking_cast.get_collider().clear_trash()
			
		if car_cam != null:
			
			if not is_in_car:
				
				if looking_cast.is_colliding() and looking_cast.get_collider().has_method("canDrive") :
					# GET IN THE CAR
					is_in_car = true
					car_cam.current = true
					camera_3d.current = false
					visible = false 
					$CollisionShape3D.disabled = true 
					if car_node.canOpenLight :
						car_node.openLight(true)
					
					# ### NEW ### Tell the car to turn on!
					car_node.is_driven = true 
					if car_node.carFuel > 0 :
						engine_start.play()
						engine_idle.play()
					Fuelmargin_container.visible = true
					
			else:
				# GET OUT OF THE CAR
				is_in_car = false
				car_cam.current = false
				camera_3d.current = true
				visible = true
				$CollisionShape3D.disabled = false
				Fuelmargin_container.visible = false
				
				car_node.openLight(false)
				
				global_position = car_node.global_position + (car_node.transform.basis.x * 0.5) + Vector3(1, 0, 0.25)
				car_node.is_driven = false
				if car_node.carFuel > 0 :
					engine_idle.stop()
					engine_stop.play()

func _physics_process(delta: float) -> void:
	if looking_cast.is_colliding() and not interActionJustPress:
		if looking_cast.get_collider() :
			if looking_cast.get_collider().has_method("interact") and not isInViewInteract:
					var interactText = looking_cast.get_collider().interact()
					if "BUY" in interactText :
						label_2.visible = true
						label_2.text= looking_cast.get_collider().getbuyvalue() + " ฿"
					label.text = interactText
					interact.show()
					inter_show.play("Show")
					isInViewInteract = true
	else :
		if isInViewInteract :
			isInViewInteract = false
			label_2.visible = false
			inter_show.play("Hide")
			await inter_show.animation_finished
			interact.hide()
		
	if is_in_car:
		return 
	
	# --- Controller Look ---
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if look_dir.length() > 0:
		rotate_y(-look_dir.x * joy_sens * delta)
		pivot.rotate_x(-look_dir.y * joy_sens * delta)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	# -----------------------

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
