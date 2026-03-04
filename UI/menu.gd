extends Control

@onready var play: Button = $MarginContainer/VBoxContainer/VBoxContainer/Play

func _ready():
	play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_option_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
