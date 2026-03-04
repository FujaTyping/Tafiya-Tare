extends Node3D

@export var startTime = 160
@export var dayLengthInSeconds:float = 155

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

var dayDuration = 600
var dayColorList = [
	{"top": morningColorTop, "horizon": morningColorHorizon, "startTime": 165},
	{"top": dayColorTop, "horizon": dayColorHorizon, "startTime": 190 },
	{"top": afternoonColorTop, "horizon": afternoonColorHorizon, "startTime": 470},
	{"top": nightColorTop, "horizon": nightColorHorizon, "startTime": 485}
]
var currentDayState = 0
var durationMultiplier = 1.0

func _ready() -> void:
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

func _process(delta: float) -> void:
	_refresh_day_state()
