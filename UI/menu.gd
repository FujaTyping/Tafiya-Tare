extends Control

@onready var play: Button = $Main/VBoxContainer/VBoxContainer/Play
@onready var credit_animation: AnimationPlayer = $CreditAnimation
@onready var menu_animation: AnimationPlayer = $MenuAnimation
@onready var close_credit: Button = $Credit/MarginContainer/CloseCredit
@onready var option: MarginContainer = $Option
@onready var option_animation: AnimationPlayer = $OptionAnimation

# Container
@onready var main: MarginContainer = $Main
@onready var credit: MarginContainer = $Credit

# Option
@onready var h_slider: HSlider = $Option/VBoxContainer/VBoxContainer/HBoxContainer/HSlider
@onready var BGMBus = AudioServer.get_bus_index("BGM")
@onready var SFXBus = AudioServer.get_bus_index("SFX")
@onready var s_check_button: CheckButton = $Option/VBoxContainer/VBoxContainer/HBoxContainer4/SCheckButton
@onready var check_button: CheckButton = $Option/VBoxContainer/VBoxContainer/HBoxContainer3/CheckButton
@onready var option_button: OptionButton = $Option/VBoxContainer/VBoxContainer/HBoxContainer2/OptionButton
@onready var cn_check_button: CheckButton = $Option/VBoxContainer/VBoxContainer/HBoxContainer5/CNCheckButton
@onready var close_option: Button = $Option/VBoxContainer/CloseOption
@onready var fps_selector: OptionButton = $Option/VBoxContainer/VBoxContainer/HBoxContainer6/FPSSelector
@onready var version: Label = $Main/VBoxContainer2/HBoxContainer/Version
@onready var load: Button = $Main/VBoxContainer/VBoxContainer/Load
@onready var license_animation: AnimationPlayer = $LicenseAnimation
@onready var license: MarginContainer = $License
@onready var close_lisense: Button = $License/MarginContainer/CloseCredit
@onready var player_selectionC: MarginContainer = $PlayerSelection
@onready var player_selection_2: AnimationPlayer = $PlayerSelection2

# Animate cam
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_selection: Marker3D = $Marker/PlayerSelection
var previousCamPost

const fpsList = [30,60,120]
const langList = ["en","th","jp"]

func _ready():
	animation_player.play("Intro")
	if FileAccess.file_exists("user://setting_data.tres") :
		var data = ResourceLoader.load("user://setting_data.tres") as settingSave
		Varibles.MouseSens = data.camSens
		_on_fps_selector_item_selected(data.gameFPSIndex)
		_on_check_button_toggled(data.musicEnable)
		_on_s_check_button_toggled(data.effectEnable)
	play.grab_focus()
	DiscordRpc.updateRPC("In main menu")
	h_slider.value = Varibles.MouseSens
	check_button.button_pressed = Varibles.BGM
	s_check_button.button_pressed = Varibles.SFX
	option_button.selected = Varibles.LangIndex
	cn_check_button.button_pressed = Varibles.wantCinematic
	fps_selector.selected = Varibles.maxFPSindex
	version.text = str(ProjectSettings.get_setting("application/config/version"))
	if FileAccess.file_exists("user://save_data.res") :
		load.show()
	
	if not MenuMusic.getmusicplaying() :
		MenuMusic.playmenumusic()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("down") and Input.is_action_pressed("shift") and Input.is_action_pressed("ctrl") :
		Varibles.isFromLoadSaved = false
		ScenesLoader.load_scene("uid://dm0rxd10m14f3")
		#get_tree().change_scene_to_file("res://game.tscn")
		MenuMusic.stopmenumusic()
		
func _on_play_pressed() -> void:
	UiSound.ui_click()
	#get_tree().change_scene_to_file("res://UI/player_selection.tscn")
	Varibles.isFromLoadSaved = false
	animation_player.pause()
	previousCamPost = camera_3d.global_transform
	menu_animation.play("MenuOut")
	Varibles.tweenCam(camera_3d,"global_transform",player_selection.global_transform,3.0)
	await Varibles.wait(3)
	player_selectionC.playIdle()
	main.hide()	
	player_selection_2.play("In")
	await Varibles.wait(0.05)
	player_selectionC.show()
	#ScenesLoader.load_scene("uid://c3mj2fiee0xht")

func _on_option_pressed() -> void:
	UiSound.ui_click()
	menu_animation.play("MenuOut")
	option.visible = true
	option_animation.play("OptIn")
	close_option.grab_focus()

func _on_quit_pressed() -> void:
	Input.set_custom_mouse_cursor(null)
	MenuMusic.stopmenumusic()
	get_tree().quit()

func _on_credit_pressed() -> void:
	UiSound.ui_click()
	menu_animation.play("MenuOut")
	#await menu_animation.animation_finished
	credit.visible = true
	credit_animation.play("CreditIn")
	await credit_animation.animation_finished
	main.visible = false
	close_credit.grab_focus()


func _on_close_credit_pressed() -> void:
	UiSound.ui_click()
	credit_animation.play("CreditOut")
	menu_animation.play("MenuIn")
	main.visible = true
	await menu_animation.animation_finished
	credit.visible = false
	play.grab_focus()


func _on_close_option_pressed() -> void:
	UiSound.ui_click()
	saveSetting()
	menu_animation.play("MenuIn")
	option_animation.play("OptOut")
	await option_animation.animation_finished
	option.visible = false
	play.grab_focus()


func _on_h_slider_value_changed(value: float) -> void:
	Varibles.MouseSens = value

func _on_check_button_toggled(toggled_on: bool) -> void:
	Varibles.BGM = toggled_on
	if not toggled_on :
		AudioServer.set_bus_volume_db(BGMBus, -80)
	else :
		AudioServer.set_bus_volume_db(BGMBus, 0)

func _on_s_check_button_toggled(toggled_on: bool) -> void:
	Varibles.SFX = toggled_on
	if not toggled_on :
		AudioServer.set_bus_volume_db(SFXBus, -80)
	else :
		AudioServer.set_bus_volume_db(SFXBus, 0)


func _on_option_button_item_selected(index: int) -> void:
	Varibles.LangIndex = index
	TranslationServer.set_locale(langList[index])


func _on_cn_check_button_toggled(toggled_on: bool) -> void:
	Varibles.wantCinematic = toggled_on
	
func _on_fps_selector_item_selected(index: int) -> void:
	Engine.max_fps = fpsList[index]
	Varibles.maxFPSindex = index


func _on_play_2_pressed() -> void:
	UiSound.ui_click()
	Varibles.saved_data = null
	Varibles.isFromLoadSaved = true
	var data = ResourceLoader.load("user://save_data.res") as gameData
	Varibles.saved_data = data
	Varibles.playerSelection = data.player_selection
	ScenesLoader.load_scene("uid://dm0rxd10m14f3")
	MenuMusic.stopmenumusic()

func _on_link_button_2_pressed() -> void:
	UiSound.ui_click()
	menu_animation.play("MenuOut")
	credit.visible = true
	credit_animation.play("CreditIn")
	await credit_animation.animation_finished
	main.visible = false
	close_credit.grab_focus()

func saveSetting() :
	var data = settingSave.new()
	data.languageIndex = Varibles.LangIndex
	data.gameFPSIndex = Varibles.maxFPSindex
	data.camSens = Varibles.MouseSens
	data.effectEnable = Varibles.SFX
	data.musicEnable = Varibles.BGM
	
	ResourceSaver.save(data,"user://setting_data.tres")


func _on_link_button_3_pressed() -> void:
	UiSound.ui_click()
	menu_animation.play("MenuOut")
	license.visible = true
	license_animation.play("In")
	await license_animation.animation_finished
	main.visible = false
	close_lisense.grab_focus()

func _on_close_license_pressed() -> void:
	UiSound.ui_click()
	menu_animation.play("MenuIn")
	main.visible = true
	license_animation.play_backwards("In")
	await license_animation.animation_finished
	license.visible = false
	play.grab_focus()

func _on_back_selection_pressed() -> void:
	UiSound.ui_click()
	player_selection_2.play_backwards("In")
	Varibles.tweenCam(camera_3d,"global_transform",previousCamPost,3.0)
	await Varibles.wait(3)
	menu_animation.play("MenuIn")
	main.show()
	animation_player.play_section()
