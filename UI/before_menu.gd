extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var intro: AnimationPlayer = $Intro

const langList = ["en","th","jp"]
const windowList = [DisplayServer.WINDOW_MODE_MAXIMIZED,DisplayServer.WINDOW_MODE_WINDOWED,DisplayServer.WINDOW_MODE_FULLSCREEN]

var SteamAppID = "5099770"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.set_environment('SteamAppID', SteamAppID)
	OS.set_environment('SteamGameID',SteamAppID)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if FileAccess.file_exists("user://setting_data.tres") :
		var data = ResourceLoader.load("user://setting_data.tres") as settingSave
		Varibles.LangIndex = data.languageIndex
		TranslationServer.set_locale(langList[data.languageIndex])
		DisplayServer.window_set_mode(windowList[data.windowsModeIndex])
	Steam.steamInit()
	var SteamRunning = Steam.isSteamRunning()
	print(SteamRunning)
	Varibles.isSteamRunning = SteamRunning
	await Varibles.wait(0.25)	
	intro.play("In")
	await Varibles.wait(0.025)
	texture_rect.show()
	label.show()
	await intro.animation_finished
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
