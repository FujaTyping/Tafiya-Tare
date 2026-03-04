extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var transis: AnimationPlayer = $Transis

func transition(animation: String,seconds:float) -> void:
	transis.play(animation,-1.0,1/ seconds)
