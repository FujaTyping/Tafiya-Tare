extends Area3D

@onready var player: CharacterBody3D= get_tree().current_scene.get_node("player")
@onready var car: VehicleBody3D= get_tree().current_scene.get_node("VehicleBody3D")
@onready var WaterView:TextureRect = get_tree().current_scene.get_node("WaterView")
@onready var ViewAnimation:AnimationPlayer = WaterView.get_node("ViewWOn")

var AlreadyEnter:bool = false

func _ready() -> void:
	self.body_entered.connect(InWater)
	self.body_exited.connect(OutWater)
	
func checkEnti(body) -> bool:
	if body == player or body == car:
		return true
	else :
		return false
	
func InWater(body) -> void:
	if checkEnti(body) and not AlreadyEnter :
		AudioServer.set_bus_effect_enabled(1,0,true)
		WaterView.show()
		ViewAnimation.play("0.3")
		AlreadyEnter = true
	
func OutWater(body) -> void :
	if checkEnti(body) and AlreadyEnter and not player.is_in_car :
		AudioServer.set_bus_effect_enabled(1,0,false)
		ViewAnimation.play_backwards("0.3")
		await ViewAnimation.animation_finished
		WaterView.hide()
		AlreadyEnter = false
