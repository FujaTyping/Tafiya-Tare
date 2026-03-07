extends Control

@onready var play: Button = $Main/VBoxContainer/VBoxContainer/Play
@onready var credit_animation: AnimationPlayer = $CreditAnimation
@onready var menu_animation: AnimationPlayer = $MenuAnimation
@onready var close_credit: Button = $Credit/VBoxContainer/CloseCredit

# Container
@onready var main: MarginContainer = $Main
@onready var credit: MarginContainer = $Credit

func _ready():
	play.grab_focus()
	if not MenuMusic.getmusicplaying() :
		MenuMusic.playmenumusic()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/player_selection.tscn")

func _on_option_pressed() -> void:
	pass # Replace with function body.

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
