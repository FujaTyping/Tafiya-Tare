extends Node3D

@export var startTime = 160
@export var dayLengthInSeconds:float = 300 #155

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
@onready var carInstant : VehicleBody3D = $VehicleBody3D

@onready var sun: DirectionalLight3D = $Sun

@onready var m_value: Label = $Control/HBoxContainer2/MValue
@onready var save_icon_indicator: TextureRect = $Control/MarginContainer2/SaveIconIndicator
@onready var animation_player: AnimationPlayer = $Control/MarginContainer2/AnimationPlayer

# Save Stuff
@onready var player : CharacterBody3D = get_tree().current_scene.get_node("player")
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
		if Varibles.saved_data.collectItem.size() > 0 :
			collectedItem = Varibles.saved_data.collectItem
			for item in Varibles.saved_data.collectItem :
				var removeItem = get_tree().current_scene.get_node(item)
				removeItem.queue_free()
	else :
		Varibles.Coins = 0
	DiscordRpc.updateRPC("In game")
	_change_duration()
	
	_set_sun()
	
	_set_current_state()
	
	_refresh_day_state()
	
	_day_change_animation()

func _change_duration():
	durationMultiplier = dayLengthInSeconds/180
	day_night.speed_scale = 1.0 / durationMultiplier

func _set_sun():
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
	
	if dayColorList[currentDayState]["startTime"] >= 485 :
		if not night_bgm.playing :
			carInstant.canOpenLight = true
			if carInstant.is_driven :
				carInstant.openLight(true)
			night_bgm.play()
			day_bgm.stop()
			#sun.visible = false
			for light in everyNightLight :
				light.visible = true
			for patical:GPUParticles3D in waterFlow :
				patical.process_material.color = "ffffff05"
	else :
		if not day_bgm.playing :
			#sun.visible = true
			carInstant.canOpenLight = false
			if carInstant.is_driven :
				carInstant.openLight(false)
			day_bgm.play()
			night_bgm.stop()
			for light in everyNightLight :
				light.visible = false
			for patical:GPUParticles3D in waterFlow :
				patical.process_material.color = "ffffffb4"

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
	data.car_position = car.global_position
	data.car_rotation = car.rotation_degrees
	data.car_fuel = car.carFuel
	data.player_coins = Varibles.Coins
	data.game_time = gameInstance.getDN()
	data.player_selection = Varibles.playerSelection
	data.collectItem = collectedItem
	data.miniGameLevel1State = level1Minigame.isUsed
	
	ResourceSaver.save(data,"user://save_data.res")
	await animation_player.animation_finished
	save_icon_indicator.hide()
