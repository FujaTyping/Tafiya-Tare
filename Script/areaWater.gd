extends Area3D

@onready var player: CharacterBody3D= get_tree().current_scene.get_node("player")
@onready var car: VehicleBody3D= get_tree().current_scene.get_node("VehicleBody3D")

func _ready() -> void:
	self.body_entered.connect(InWater)
	self.body_exited.connect(OutWater)
	
func checkEnti(body) -> bool:
	if body == player or body == car:
		return true
	else :
		return false
	
func InWater(body) -> void:
	if checkEnti(body) :
		AudioServer.set_bus_effect_enabled(1,0,true)
	
func OutWater(body) -> void :
	if checkEnti(body) :
		AudioServer.set_bus_effect_enabled(1,0,false)
