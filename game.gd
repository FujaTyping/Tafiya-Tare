extends Node3D

@export var startTime = 465 #155
@export var dayLengthInSeconds:float = 300 #155
var day = 0

@export var morningColorTop: Color = Color("5897fa")
@export var morningColorHorizon: Color = Color("d3916b")

@export var dayColorTop: Color = Color("1f6ddf")
@export var dayColorHorizon: Color = Color("56a9f5")

@export var afternoonColorTop: Color = Color("3d6fcd")
@export var afternoonColorHorizon: Color = Color("e98174")

@export var nightColorTop: Color = Color("090e14")
@export var nightColorHorizon: Color = Color("010049")

@onready var day_night: AnimationPlayer = $DayNight
@onready var environment: WorldEnvironment = $Environment

@onready var night_bgm: AudioStreamPlayer = $nightBGM
@onready var day_bgm: AudioStreamPlayer = $dayBGM
@onready var dn: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/DN
@onready var time: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Time
@onready var everyNightLight = get_tree().get_nodes_in_group("lightFromPole")
@onready var waterFlow = get_tree().get_nodes_in_group("waterFlow")
@onready var fireflyPatical = get_tree().get_nodes_in_group("firefly")
@onready var carInstant : VehicleBody3D = $VehicleBody3D
@onready var day_effect: AudioStreamPlayer = $dayEffect
@onready var night_effect: AudioStreamPlayer = $nightEffect

@onready var sun: DirectionalLight3D = $Sun

@onready var m_value: Label = $Control/HBoxContainer2/MValue
@onready var save_icon_indicator: TextureRect = $Control/MarginContainer2/SaveIconIndicator
@onready var animation_player: AnimationPlayer = $Control/MarginContainer2/AnimationPlayer

# Save Stuff
@onready var player : CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var playerCamPivot: SpringArm3D = player.get_node("SpringArm3D")
@onready var car: VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")
@onready var gameInstance: Node3D = self
@onready var texture_rect: TextureRect = $Control/TextureRect
@onready var level1Minigame : Node3D = get_tree().current_scene.get_node("StatueOfCatalyst")

# Image set
@export var dayIcon: CompressedTexture2D
@export var morningIcon: CompressedTexture2D
@export var nightIcon: CompressedTexture2D

var dayDuration = 600
var dayColorList = []
var currentDayState = 0
var durationMultiplier = 1.0
var dayFromSave = false

var collectedItem:Array[NodePath] = []

func _ready() -> void:
	dayColorList = [
		{"top": morningColorTop, "horizon": morningColorHorizon, "startTime": 165,"name": "TIME_MORNING","icon": morningIcon},
		{"top": dayColorTop, "horizon": dayColorHorizon, "startTime": 190,"name": "TIME_DAY","icon": dayIcon },
		{"top": afternoonColorTop, "horizon": afternoonColorHorizon, "startTime": 470,"name": "TIME_AFTERNOON", "icon": morningIcon},
		{"top": nightColorTop, "horizon": nightColorHorizon, "startTime": 485, "name": "TIME_NIGHT", "icon": nightIcon}
	]
	#sun.visible = false
	if Varibles.isFromLoadSaved :
		startTime = Varibles.saved_data.game_time
		day = Varibles.saved_data.dayCount
		dayFromSave = true
		if Varibles.saved_data.collectItem.size() > 0 :
			collectedItem = Varibles.saved_data.collectItem
			for item in Varibles.saved_data.collectItem :
				var removeItem = get_tree().current_scene.get_node(item)
				removeItem.queue_free()
	else :
		Varibles.Coins = 0
	DiscordRpc.updateRPC("In game")
	_change_duration()
	
	_set_sun(startTime)
	
	_set_current_state()
	
	_refresh_day_state()
	
	_day_change_animation()
	print(day)

func _change_duration():
	durationMultiplier = dayLengthInSeconds/180
	day_night.speed_scale = 1.0 / durationMultiplier

func _set_sun(startTime:int):
	day_night.play("DayAndNight")
	day_night.seek(startTime)

func _set_current_state():
	for i in dayColorList.size():
		if startTime < dayColorList[i].startTime:
			currentDayState = i -1
			return

func _refresh_day_state():
	var newState = false
	
	for i in dayColorList.size():
		var sameState = i == currentDayState
		if not sameState and day_night.current_animation_position > dayColorList[i].startTime:
			currentDayState = i
			newState = true
			
	if newState: 
		_day_change_animation()

func _day_change_animation():
	var topColor = dayColorList[currentDayState]["top"]
	var hoirzonColor = dayColorList[currentDayState]["horizon"]
	var tween = create_tween()
	
	var duration = durationMultiplier
	
	tween.tween_property(environment, "environment:sky:sky_material:sky_top_color", topColor, duration)
	tween.parallel()
	tween.tween_property(environment, "environment:sky:sky_material:sky_horizon_color", hoirzonColor, duration)
	tween.parallel()
	tween.tween_property(environment, "environment:sky:sky_material:ground_bottom_color", topColor, duration)
	tween.parallel()
	tween.tween_property(environment, "environment:sky:sky_material:ground_horizon_color", hoirzonColor, duration)
	
	dn.text = dayColorList[currentDayState]["name"]
	#var dnIcon = Image.load_from_file()
	var dnTexture = dayColorList[currentDayState]["icon"]
	texture_rect.texture = dnTexture
	
	if dayColorList[currentDayState]["name"] == "TIME_DAY" :
		for firefire:GPUParticles3D in fireflyPatical :
			firefire.emitting = false
	else :
		for firefire:GPUParticles3D in fireflyPatical :
			firefire.emitting = true
	
	if dayColorList[currentDayState]["startTime"] >= 485 :
		if not night_bgm.playing :
			if dayFromSave :
				dayFromSave = not dayFromSave
			carInstant.canOpenLight = true
			if carInstant.is_driven :
				carInstant.openLight(true)
			night_bgm.play()
			if dayColorList[currentDayState]["name"] == "TIME_NIGHT":
				night_effect.play()
			day_bgm.stop()
			#sun.visible = false			
			for patical:GPUParticles3D in waterFlow :
				patical.amount_ratio = 0.3
			for light in everyNightLight :
				if light is OmniLight3D :
					light.light_energy = 1
					return
				light.visible = true

	else :
		if not day_bgm.playing :
			#sun.visible = true
			carInstant.canOpenLight = false
			if carInstant.is_driven :
				carInstant.openLight(false)
			day_bgm.play()
			if not dayFromSave :
				day += 1
			if dayColorList[currentDayState]["name"] == "TIME_MORNING" :
				day_effect.play()
			night_bgm.stop()
			for patical:GPUParticles3D in waterFlow :
				patical.amount_ratio = 1
			for light in everyNightLight :
				if light is OmniLight3D :
					light.light_energy = 0.1
					return
				light.visible = false

func getDN() :
	return day_night.current_animation_position

func _process(delta: float) -> void:
	m_value.text = str(Varibles.Coins) + " ฿"
	_refresh_day_state()
	_update_time_display()
	
func _update_time_display() -> void:
	var current_time_sec = day_night.current_animation_position
	current_time_sec = fmod(current_time_sec, float(dayDuration))
	var day_fraction = current_time_sec / float(dayDuration)
	var total_minutes = day_fraction * 24.0 * 60.0
	var hours = int(total_minutes / 60.0)
	var minutes = int(total_minutes) % 60
	time.text = "%02d:%02d" % [hours, minutes]

func saveDat() :
	save_icon_indicator.show()
	animation_player.play("Saving")
	var data = gameData.new()
	data.player_position = player.global_position
	data.player_rotation = player.rotation_degrees
	data.playerSpeed = player.DSPEED
	data.car_position = car.global_position
	data.car_rotation = car.rotation_degrees
	data.car_fuel = car.carFuel
	data.player_coins = Varibles.Coins
	data.game_time = gameInstance.getDN()
	data.player_selection = Varibles.playerSelection
	data.collectItem = collectedItem
	data.miniGameLevel1State = level1Minigame.isUsed
	data.playerSpringArmLength = playerCamPivot.spring_length
	data.dayCount = day	

	ResourceSaver.save(data,"user://save_data.res")
	await animation_player.animation_finished
	save_icon_indicator.hide()
	
func get_day_time() :
	return dayColorList[currentDayState]["name"]	

func instanceDaySkip (time:int) :
	startTime = time
	_change_duration()
		
	_set_sun(time)
	
	_set_current_state()
	
	_refresh_day_state()
	
	_day_change_animation()
