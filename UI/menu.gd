extends Control

@onready var play: Button = $Main/VBoxContainer/VBoxContainer/Play
@onready var credit_animation: AnimationPlayer = $CreditAnimation
@onready var menu_animation: AnimationPlayer = $MenuAnimation
@onready var close_credit: Button = $Credit/VBoxContainer/CloseCredit

func _ready():
	play.grab_focus()
	MenuMusic.playmenumusic()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/player_selection.tscn")

func _on_option_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credit_pressed() -> void:
	menu_animation.play("MenuOut")
	credit_animation.play("CreditIn")
	close_credit.grab_focus()


func _on_close_credit_pressed() -> void:
	credit_animation.play("CreditOut")
	menu_animation.play("MenuIn")
	play.grab_focus()
