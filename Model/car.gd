extends VehicleBody3D

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 200

var is_driven: bool = false 

func _physics_process(delta):
	if is_driven:
		steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("down", "up") * ENGINE_POWER
	else:
		steering = move_toward(steering, 0, delta * 10)
		engine_force = 0
