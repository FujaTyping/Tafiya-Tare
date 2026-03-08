extends VehicleBody3D

var max_RPM = 500
var max_torque = 300
var turn_speed = 3
var turn_amount = 0.3
var carFuel = 50

var is_driven: bool = false 
#@onready var car_idle: AudioStreamPlayer3D = $CarIdle
@onready var cnt: Label = $MarginContainer/HBoxContainer/CNT

func _ready() -> void:
	fuelUpdate()
	
func fuelUpdate() :
	cnt.text = str(snapped(carFuel, 0.1)) 
	
func interact() :
	return "ON_INTERACTION_CAR"

func canDrive() :
	pass

#func _input(event: InputEvent) -> void:
	#if is_driven:
		#if carFuel > 0 :		
			#if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
				#carFuel -= 0.005
				#cnt.text = str(carFuel)
		#else :
			#cnt.text = str(0)

func _physics_process(delta: float) -> void:
	$CamArm.position = position
	
	if is_driven and carFuel > 0 :
		var dir = Input.get_action_strength("up") - Input.get_action_strength("down")
		var steering_dir = Input.get_action_strength("left") - Input.get_action_strength("right")
		
		# --- CONTINUOUS FUEL DRAIN & UI UPDATE ---
		if dir != 0:
			carFuel -= 0.5 * delta 
			if carFuel < 0 :
				cnt.text = str(0)
			else :
				cnt.text = str(snapped(carFuel, 0.1)) 
		# -----------------------------------------
		
		var RPM_left = abs($WBL.get_rpm())
		var RPM_right = abs($WBR.get_rpm())
		var RPM = (RPM_left + RPM_right) / 2.0
		
		var torque = dir * max_torque * (1.0 - RPM / max_RPM)

		engine_force = torque
		steering = lerp(steering, steering_dir * turn_amount,turn_speed * delta)
		
		if dir == 0 :
			brake = 2
			
	elif is_driven and carFuel <= 0:
		engine_force = 0
		brake = 2
