extends CanvasLayer

signal loading_screen_ready

@export var animation_player: AnimationPlayer
@export var progressBar : ProgressBar
@export var textLabel: Label

func _ready() -> void:
	textLabel.text = str(0)
	await animation_player.animation_finished
	loading_screen_ready.emit()
	
func _on_progress_changed(new_value:float) -> void:
	if new_value > 0 :
		textLabel.text = str(snapped(new_value*100,0))
	
func _on_load_finished() -> void:
	animation_player.play_backwards("FadeIn")
	await animation_player.animation_finished
	queue_free()
