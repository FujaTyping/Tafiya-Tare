extends VehicleBody3D

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 200

@onready var title_action: Label3D = $TitleAction

var is_driven: bool = false 

func _ready() -> void:
	title_action.hide()

func _physics_process(delta):
	if is_driven:
		steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("down", "up") * ENGINE_POWER
	else:
		steering = move_toward(steering, 0, delta * 10)
		engine_force = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") :
		title_action.show()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") :
		title_action.hide()
