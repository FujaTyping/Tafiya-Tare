extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"Jar Make/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("capAction")
	animation_player.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact() :
	return "DONG_MESSAGE"
