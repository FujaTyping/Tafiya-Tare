extends StaticBody3D

@onready var carInstanst: VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")
@export var valueOfItem: int = 0

@onready var gameInstant = get_tree().current_scene

func addFuel() :
	if checkCanBuy() :
		carInstanst.carFuel += 20
		Varibles.Coins -= valueOfItem
		carInstanst.fuelUpdate()
		self.visible = false
		self.set_collision_layer_value(2,false)
		gameInstant.collectedItem.append(self.get_path())
		self.queue_free()

func buyItem() :
	addFuel()
		
func checkCanBuy() :
	if Varibles.Coins - valueOfItem > 0 :
		return true
	else :
		return false

func getbuyvalue() :
	return str(valueOfItem)
	
func interact() :
	return "ON_INTERACTION_BUY_FUEL"
