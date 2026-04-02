extends VehicleBody3D

var max_RPM = 200 # 500
var max_torque = 80 # 300
var turn_speed = 3
var turn_amount = 0.3
var carFuel = 10

var is_driven: bool = false 
var canOpenLight = false
#@onready var car_idle: AudioStreamPlayer3D = $CarIdle
#@onready var cnt: Label = $MarginContainer/HBoxContainer/CNT
@onready var fuel_bar: ProgressBar = $CanvasLayer/FuelBar

@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var spot_light_3d_2: SpotLight3D = $SpotLight3D2

@onready var engine_start: AudioStreamPlayer3D = $EngineStart
@onready var car_idle: AudioStreamPlayer3D = $CarIdle
@onready var engine_stop: AudioStreamPlayer3D = $EngineStop
@onready var fuel_out: AudioStreamPlayer3D = $FuelOut
@onready var fuel_icon: TextureRect = $CanvasLayer/FuelIcon
@onready var fuel_animation: AnimationPlayer = $CanvasLayer/FuelAnimation
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var isOutFuel: bool = false

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		self.global_position = Varibles.saved_data.car_position
		self.rotation_degrees = Varibles.saved_data.car_rotation
		carFuel = Varibles.saved_data.car_fuel
		Varibles.ListNPCbackCar = Varibles.saved_data.carNPCBackList
	fuelUpdate()
	updateBackNPC()
	
func updateBackNPC() :
	var ListOfNPC:Array[String] = Varibles.ListNPCbackCar
	if ListOfNPC.size() > 0 :
		for i in ListOfNPC :
			var NPC : Node3D = get_node(i)
			NPC.show()
	
func fuelUpdate() :
	fuel_bar.value = snapped(carFuel, 0.1)
	if carFuel > 15 :
		isOutFuel = false
		fuel_icon.hide()
	
func interact() :
	return "ON_INTERACTION_CAR"

func canDrive() :
	pass
	
func openLight(value:bool) :
	if value and carFuel > 0 :
		spot_light_3d.visible = true
		spot_light_3d_2.visible = true
	else :
		spot_light_3d.visible = false
		spot_light_3d_2.visible = false
	

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
			carFuel -= 0.8 * delta #0.08 #0.05
			if carFuel < 0 :
				fuel_bar.value = 0
				car_idle.stop()
				engine_start.stop()
				engine_stop.play()
				openLight(false)
			else :
				if carFuel < 15 :
					if not isOutFuel :
						isOutFuel = true
						fuel_out.play()
						fuel_icon.show()
						fuel_animation.play("3")
				else :
					isOutFuel = false
					fuel_icon.hide()
				fuel_bar.value = snapped(carFuel, 0.1)
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

var prevToggle: bool = true

func checkHUD(state:bool) :
	if is_driven :
		if not state :
			canvas_layer.hide()
		else :
			canvas_layer.show()
	prevToggle = state
