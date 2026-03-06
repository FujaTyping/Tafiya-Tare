extends VehicleBody3D

var max_RPM = 500
var max_torque = 300
var turn_speed = 3
var turn_amount = 0.3

var is_driven: bool = false 

func _physics_process(delta: float) -> void:
	$CamArm.position = position
	
	if is_driven :
		var dir = Input.get_action_strength("up") - Input.get_action_strength("down")
		var steering_dir = Input.get_action_strength("left") - Input.get_action_strength("right")
		
		var RPM_left = abs($WBL.get_rpm())
		var RPM_right = abs($WBR.get_rpm())
		var RPM = (RPM_left + RPM_right) / 2.0
		
		var torque = dir * max_torque * (1.0 - RPM / max_RPM)

		engine_force = torque
		steering = lerp(steering, steering_dir * turn_amount,turn_speed * delta)
		
		if dir == 0 :
			brake = 2
