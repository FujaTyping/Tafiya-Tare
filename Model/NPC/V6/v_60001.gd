extends Node3D

@export var animation:AnimationPlayer
@export var sittAnimationName: String

func _ready() -> void:
	animation.play(sittAnimationName)
