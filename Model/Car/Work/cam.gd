extends SpringArm3D

@export var MouseSensitivity = 0.1
@export var JoypadSensitivity = 100.0 # You may need to tweak this value!

# Assuming your Camera3D is a direct child of this SpringArm3D
@onready var camera_3d: Camera3D = $Camera3D 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	top_level = true
	
func _input(event: InputEvent) -> void:
	# Stop reading input if the player isn't using the car camera
	if camera_3d and not camera_3d.current:
		return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.x -= event.relative.y * MouseSensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, -10.0)
		
		rotation_degrees.y -= event.relative.x * MouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _process(delta: float) -> void:
	# Stop reading input if the player isn't using the car camera
	if camera_3d and not camera_3d.current:
		return

	# --- Controller Look ---
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	if look_dir.length() > 0:
		# We multiply by delta here so the joystick speed is smooth regardless of framerate
		rotation_degrees.y -= look_dir.x * JoypadSensitivity * delta
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		
		rotation_degrees.x -= look_dir.y * JoypadSensitivity * delta
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, -10.0)
