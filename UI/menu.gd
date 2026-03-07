extends Control

@onready var play: Button = $Main/VBoxContainer/VBoxContainer/Play
@onready var credit_animation: AnimationPlayer = $CreditAnimation
@onready var menu_animation: AnimationPlayer = $MenuAnimation
@onready var close_credit: Button = $Credit/VBoxContainer/CloseCredit
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

func _ready():
	play.grab_focus()
	h_slider.value = Varibles.MouseSens
	check_button.button_pressed = Varibles.BGM
	s_check_button.button_pressed = Varibles.SFX
	option_button.selected = Varibles.LangIndex
	
	if not MenuMusic.getmusicplaying() :
		MenuMusic.playmenumusic()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/player_selection.tscn")

func _on_option_pressed() -> void:
	menu_animation.play("MenuOut")
	option.visible = true
	option_animation.play("OptIn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credit_pressed() -> void:
	menu_animation.play("MenuOut")
	#await menu_animation.animation_finished
	credit.visible = true
	credit_animation.play("CreditIn")
	await credit_animation.animation_finished
	main.visible = false
	close_credit.grab_focus()


func _on_close_credit_pressed() -> void:
	credit_animation.play("CreditOut")
	menu_animation.play("MenuIn")
	main.visible = true
	await menu_animation.animation_finished
	credit.visible = false
	play.grab_focus()


func _on_close_option_pressed() -> void:
	menu_animation.play("MenuIn")
	option_animation.play("OptOut")
	await option_animation.animation_finished
	option.visible = false


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
	if index == 0 :
		TranslationServer.set_locale("en")
	else :
		TranslationServer.set_locale("th")
