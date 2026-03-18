extends Node

@onready var Sclick: AudioStreamPlayer = $Click
@onready var whoose: AudioStreamPlayer = $Whoose

func ui_click() :
	Sclick.play()

func ui_whoose() :
	whoose.play()
	
