extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	self.hide()
	animation_player.play("IO")
	animation_player.stop()

func onTransition(duration:int = 1) :
	self.show()
	await Varibles.wait(0.05)
	animation_player.play("IO")
	await animation_player.animation_finished
	await Varibles.wait(duration)
	animation_player.play_backwards("IO")
	await animation_player.animation_finished
	self.hide()
