extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var intro: AnimationPlayer = $Intro

const langList = ["en","th","jp"]
const windowList = [DisplayServer.WINDOW_MODE_MAXIMIZED,DisplayServer.WINDOW_MODE_WINDOWED,DisplayServer.WINDOW_MODE_FULLSCREEN]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if FileAccess.file_exists("user://setting_data.tres") :
		var data = ResourceLoader.load("user://setting_data.tres") as settingSave
		Varibles.LangIndex = data.languageIndex
		TranslationServer.set_locale(langList[data.languageIndex])
		DisplayServer.window_set_mode(windowList[data.windowsModeIndex])
	await Varibles.wait(0.25)	
	intro.play("In")
	await Varibles.wait(0.025)
	texture_rect.show()
	label.show()
	await intro.animation_finished
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
