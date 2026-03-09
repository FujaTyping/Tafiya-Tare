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
@onready var dn: Label = $Control/MarginContainer/HBoxContainer/DN
@onready var time: Label = $Control/MarginContainer/HBoxContainer/Time
@onready var everyNightLight = get_tree().get_nodes_in_group("lightFromPole")

@onready var sun: DirectionalLight3D = $Sun

var dayDuration = 600
var dayColorList = [
	{"top": morningColorTop, "horizon": morningColorHorizon, "startTime": 165,"name": "TIME_MORNING"},
	{"top": dayColorTop, "horizon": dayColorHorizon, "startTime": 190,"name": "TIME_DAY" },
	{"top": afternoonColorTop, "horizon": afternoonColorHorizon, "startTime": 470,"name": "TIME_AFTERNOON"},
	{"top": nightColorTop, "horizon": nightColorHorizon, "startTime": 485, "name": "TIME_NIGHT"}
]
var currentDayState = 0
var durationMultiplier = 1.0

func _ready() -> void:
	#sun.visible = false
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
	if dayColorList[currentDayState]["startTime"] >= 485 :
		if not night_bgm.playing :
			night_bgm.play()
			day_bgm.stop()
			#sun.visible = false
			for light in everyNightLight :
				light.visible = true
	else :
		if not day_bgm.playing :
			#sun.visible = true
			day_bgm.play()
			night_bgm.stop()
			for light in everyNightLight :
				light.visible = false

func _process(delta: float) -> void:
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
