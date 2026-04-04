extends Node3D

@onready var lightSource:OmniLight3D = $"./OmniLight3D"
@onready var player : CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var gameInstance:Node3D = get_tree().current_scene
@onready var car:VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")

@export var rangeTrigged: int = 32

func _process(delta: float) -> void:
	if gameInstance.get_day_time() == "TIME_NIGHT" :
		var posOg:Vector3		
		var lightPos = self.global_position
		
		if not player.is_in_car :
			posOg = player.global_position
		else :
			posOg = car.global_position

		if posOg.distance_to(lightPos) < rangeTrigged :			
			lightSource.visible = true
			Varibles.tweenCam(lightSource,"light_energy",2.56,0.3)
		else :
			closeLight()
	else :
		closeLight()
			
func closeLight() :
	Varibles.tweenCam(lightSource,"light_energy",0.0,0.3)
	await Varibles.wait(0.31)
	lightSource.visible = false
