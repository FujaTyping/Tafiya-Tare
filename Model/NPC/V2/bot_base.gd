extends Node3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var notiContainer:MarginContainer = get_tree().current_scene.get_node("player/NotiItem")
@onready var rev_powder: AudioStreamPlayer3D = $RevPowder

func dialogEnd(params) :
	if params != 'Give' or player.haveAPoonPowder == true :
		return
	player.haveAPoonPowder = true
	rev_powder.play()
	notiContainer.notiNewItem("POON_POWDER_COLLECT")
