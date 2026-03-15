extends Control

@onready var Aniin: AnimationPlayer = $In

func openImage() :
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.show()
	Aniin.play("in")

func _on_close_pressed() -> void:
	Aniin.play_backwards("in")
	await Aniin.animation_finished
	self.hide()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
