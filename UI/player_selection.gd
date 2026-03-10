extends Control

@onready var wm: Button = $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/WM
@onready var animation_player_i: AnimationPlayer = $playerAnimation/AnimationPlayerI
@onready var animation_player: AnimationPlayer = $woman_player/AnimationPlayer
@onready var animation_player_j: AnimationPlayer = $playerAnimation/AnimationPlayerJ
@onready var select_man: AnimationPlayer = $SelectMan

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		wm.grab_focus()
		DiscordRpc.updateRPC("Selecting character")
		animation_player.play("ArmatureAction_004")
		animation_player_i.play("ArmatureAction_004")

func _on_m_pressed() -> void:	
	Varibles.playerSelection = "joker"
	select_man.play("Man")
	await select_man.animation_finished
	animation_player_j.speed_scale = 0.3
	animation_player_j.play("ArmatureAction_003")
	await animation_player_j.animation_finished
	MenuMusic.stopmenumusic()
	get_tree().change_scene_to_file("res://game.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/menu.tscn")

func _on_wm_pressed() -> void:	
	Varibles.playerSelection = "sophia"
	select_man.play("WM")
	await select_man.animation_finished
	animation_player.speed_scale = 0.3
	animation_player.play("ArmatureAction_003")
	await animation_player.animation_finished
	MenuMusic.stopmenumusic()
	get_tree().change_scene_to_file("res://game.tscn")
