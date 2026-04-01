extends CharacterBody3D

var DSPEED = 2
var SPEED = 0
var JUMP_VELOCITY = 4.0

@onready var pivot = $SpringArm3D
@export var sens = 0.2
@export var joy_sens = 3.0
@onready var walking: AudioStreamPlayer3D = $Walking
@onready var jump: AudioStreamPlayer3D = $Jump

@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var animation_player: AnimationPlayer = $playerAnimation/AnimationPlayer
@onready var animation_player_j: AnimationPlayer = $playerAnimation/AnimationPlayerJ
#@onready var animation_player_i: AnimationPlayer = $playerAnimation/AnimationPlayerI
@onready var Wanimation_player: AnimationPlayer = $woman_player/AnimationPlayer
@onready var Wanimation_player_j: AnimationPlayer = $woman_player/AnimationPlayerJ

# --- CAR VARIABLES ---
@onready var car_cam: Camera3D = $"../VehicleBody3D/CamArm/Camera3D"
@onready var car_node: Node3D = $"../VehicleBody3D"
@onready var exitCar: Marker3D = car_node.get_node("Exit")

@onready var player_animation: Node3D = $playerAnimation
@onready var woman_player: Node3D = $woman_player
@onready var engine_start: AudioStreamPlayer3D = $"../VehicleBody3D/EngineStart"
@onready var engine_stop: AudioStreamPlayer3D = $"../VehicleBody3D/EngineStop"
@onready var engine_idle: AudioStreamPlayer3D = $"../VehicleBody3D/CarIdle"
@onready var Fuelmargin_container: CanvasLayer = $"../VehicleBody3D/CanvasLayer"

@onready var looking_cast: RayCast3D = $LookingCast
@onready var interact: MarginContainer = $Interact
@onready var inter_show: AnimationPlayer = $InterShow
@onready var label: Label = $Interact/VBoxContainer/HBoxContainer/Label
@onready var label_2: Label = $Interact/VBoxContainer/HBoxContainer/Label2
@onready var wrong: AudioStreamPlayer3D = $Wrong
@onready var more_info_hint: Label = $Interact/VBoxContainer/MoreInfoHint

# Trash Collect
@onready var trash_collect: AudioStreamPlayer3D = $TrashCollect
@onready var fuel_collect: AudioStreamPlayer3D = $FuelCollect

# Spawn
@onready var default_spawn: Marker3D = $"../AllMarker/DefaultSpawn"

@onready var NeedNPCbackCar: Node3D = get_tree().current_scene.get_node("SpawnAssets/NeedNPC")

var is_in_car: bool = false
var isInViewInteract = false
var interActionJustPress = false

var prevSpringArm: float

# Help
@onready var tutorial: MarginContainer = $Tutorial
@onready var control_sh: AnimationPlayer = $Tutorial/ControlSH
@onready var help: MarginContainer = $Help
@onready var help_me: AnimationPlayer = $Help/HelpMe

@onready var paper: AudioStreamPlayer3D = $Paper

@onready var gameInstance : Node3D = get_tree().current_scene

@onready var canvas_layer: CanvasLayer = $Sleep
@onready var sleep: AnimationPlayer = $Sleep/Sleep
@onready var ingredient: AudioStreamPlayer3D = $Ingredient

@onready var cooking_put: StaticBody3D = get_tree().current_scene.get_node("cookingPut")
@onready var cooking: AudioStreamPlayer3D = $Cooking
@onready var dish: AudioStreamPlayer3D = $Dish
@onready var fuel_fill: AudioStreamPlayer3D = $FuelFill
@onready var wash_body_bubble: Node3D = $WashBodyBubble
@onready var wash: AudioStreamPlayer3D = $Wash

func _ready():
	if Varibles.isFromLoadSaved :
		self.global_position = Varibles.saved_data.player_position
		self.rotation_degrees = Varibles.saved_data.player_rotation
		pivot.spring_length = Varibles.saved_data.playerSpringArmLength
		Varibles.Coins = Varibles.saved_data.player_coins
		DSPEED = Varibles.saved_data.playerSpeed
	else :
		self.global_position = default_spawn.global_position
	SPEED = DSPEED
	sens = Varibles.MouseSens
	if Varibles.playerSelection == "joker" :
		player_animation.visible = true
	else :
		woman_player.visible = true
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await Varibles.wait(5)
	help_me.play("Hide")
	await help_me.animation_finished
	help.hide()
	
func washBody() :
	if not wash_body_bubble.visible :
		wash_body_bubble.scale = Vector3(0,0,0)
		wash_body_bubble.show()
		wash.play()
		Varibles.tweenCam(wash_body_bubble,"scale",Vector3(0.11,0.11,0.11),3)
		await Varibles.wait(10)
		Varibles.tweenCam(wash_body_bubble,"scale",Vector3(0,0,0),3)
		await Varibles.wait(3)
		wash_body_bubble.hide()
	
func hideInteraction() :
	isInViewInteract = false
	label_2.visible = false
	inter_show.play("Hide")
	await inter_show.animation_finished
	interact.hide()
	
func _input(event):
	if Input.is_action_just_pressed("toogleMouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if not is_in_car :
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
			if Input.is_action_pressed("scrollDown") :
				if pivot.spring_length < 2.20000004768372 :
					pivot.spring_length += 0.25
			if Input.is_action_pressed("scrollUp") :
				if pivot.spring_length > -0.29999995231628 :
					pivot.spring_length -= 0.25
			
		if Input.is_action_just_pressed("Help") :
			if not tutorial.visible :
				tutorial.visible = true
				control_sh.play("ShowH")
			else :
				control_sh.play_backwards("ShowH")
				await control_sh.animation_finished
				tutorial.visible = false
  			
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	
	# --- INTERACTION LOGIC ---
	if Input.is_action_just_pressed("interaction"):
		var viewUI : Control = get_tree().current_scene.get_node("ViewPaper")
		if viewUI.visible :
			viewUI._on_close_pressed()
			return
		if looking_cast.is_colliding() :
			var colliderView = looking_cast.get_collider()
			if colliderView.has_method("buyItem") :
				#interActionJustPress = true
				#sens = 0
				if colliderView.checkCanBuy() :
					if colliderView.getbuyvalue() > 0 :
						fuel_collect.play()
					else :
						fuel_fill.play()
					colliderView.buyItem()
				else :
					wrongInteraction("INTERACTION_FAIL_NEED_MONEY")
				#sens = Varibles.MouseSens
				#interActionJustPress = false
			elif colliderView.has_method("daySkipSleep") :
				if gameInstance.get_day_time() == "TIME_NIGHT" :
					prevSpringArm = pivot.spring_length
					canvas_layer.show()
					sleep.play("Sleep")
					if prevSpringArm > 0.25555555231628 :
						Varibles.tweenCam(pivot,"spring_length",pivot.spring_length-0.6,1.5)
					await Varibles.wait(4)
					gameInstance.instanceDaySkip(165)
					sleep.play_backwards("Sleep")
					if prevSpringArm > 0.25555555231628 :
						Varibles.tweenCam(pivot,"spring_length",prevSpringArm,1.5)
					await sleep.animation_finished
					canvas_layer.hide()
					await Varibles.wait(3)
					gameInstance.saveDat()
				else :
					wrongInteraction("INTERACTION_FAIL_ONLY_SLEEP_AT_NIGHT")
			elif colliderView.has_method("clear_trash") :
				trash_collect.play()
				colliderView.clear_trash()
			elif colliderView.has_method("wash_body") :
				washBody()
			elif colliderView.has_method("add_ingredientLevel3") :
				ingredient.play()
				cooking_put.isInpot.append(colliderView.InName)
				colliderView.add_ingredientLevel3()
			elif colliderView.has_method("getFood") :
				dish.play()
				colliderView.getFood()
			elif colliderView.has_method("level3cooking") :
				if not colliderView.isCooking :
					if colliderView.isInpot.size() > 0 :
						cooking.play()
						colliderView.level3cooking()
						var interactText = colliderView.interact()
						label.text = interactText
					else :
						wrongInteraction("INTERACTION_FAIL_NO_INGREDIENT")
			elif colliderView.has_method("openViewImage") :
				colliderView.openViewImage()
				paper.play()
				if isInViewInteract :
					hideInteraction()
			
		if car_cam != null:
			
			if not is_in_car:
				
				if looking_cast.is_colliding() and looking_cast.get_collider().has_method("canDrive") :
					# GET IN THE CAR
					if Varibles.quest_State > 1 and Varibles.ListNPCbackCar.size() <= 5  :
						if Varibles.ListNPCbackCar.size() < Varibles.quest_State - 1  :
							hideInteraction()
							var needDialoge = NeedNPCbackCar.duplicate()
							add_child(needDialoge)
							needDialoge.global_position = self.global_position
							return
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
					car_node.checkHUD()
					
			else:
				# GET OUT OF THE CAR
				is_in_car = false
				car_cam.current = false
				camera_3d.current = true
				visible = true
				$CollisionShape3D.disabled = false
				Fuelmargin_container.visible = false
				
				car_node.openLight(false)
				
				#global_position = exitCar.global_position
				car_node.is_driven = false
				if car_node.carFuel > 0 :
					engine_idle.stop()
					engine_stop.play()

func wrongInteraction(moreInfo:String = "") :
	label.add_theme_color_override("font_color",Color.RED)
	label_2.add_theme_color_override("font_color",Color.RED)
	if moreInfo != "" :
		more_info_hint.text = moreInfo
		more_info_hint.show()
	wrong.play()
	await Varibles.wait(4)
	if moreInfo != "" :
		more_info_hint.hide()
	label.add_theme_color_override("font_color",Color.WHITE)
	label_2.add_theme_color_override("font_color",Color.WHITE)

func _process(delta: float) -> void:
	if is_in_car :
		global_position = exitCar.global_position

func hideHUDInteract() :
	interact.hide()

func _physics_process(delta: float) -> void:
	var viewUI : Control = get_tree().current_scene.get_node("ViewPaper")
	if not gameInstance.isHudHide :
		if not viewUI.visible :
			if looking_cast.is_colliding() and not interActionJustPress:
				if looking_cast.get_collider() :
					if looking_cast.get_collider().has_method("interact") and not isInViewInteract:
							var interactText = looking_cast.get_collider().interact()
							if "BUY" in interactText :
								if looking_cast.get_collider().getbuyvalue() > 0 :
									label_2.visible = true
									label_2.text= str(looking_cast.get_collider().getbuyvalue()) + " ฿"
							label.text = interactText
							interact.show()
							inter_show.play_backwards("Hide")
							#inter_show.play("Show")
							if more_info_hint.visible :
								more_info_hint.hide()
							label.add_theme_color_override("font_color",Color.WHITE)
							label_2.add_theme_color_override("font_color",Color.WHITE)
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
