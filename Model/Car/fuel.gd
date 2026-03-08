extends StaticBody3D

@onready var carInstanst: VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")

func addFuel() :
	carInstanst.carFuel += 20
	carInstanst.fuelUpdate()
	self.visible = false
	self.set_collision_layer_value(2,false)
	self.queue_free()
	
func interact() :
	return "ON_INTERACTION_COLLECT"
