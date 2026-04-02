extends StaticBody3D

@onready var carInstanst: VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")
@export var valueOfItem: int = 0
@export var fuelValue :int = 0
@export var saveAfterCollect :bool = true
@export var saveToremoveList : bool = true
@export var showNotiItem: bool = true

@onready var gameInstant = get_tree().current_scene
@onready var notiContainer:MarginContainer = get_tree().current_scene.get_node("player/NotiItem")

func addFuel() :
	if checkCanBuy() :
		carInstanst.carFuel += fuelValue
		Varibles.Coins -= valueOfItem
		carInstanst.fuelUpdate()
		self.visible = false
		self.set_collision_layer_value(2,false)
		notiContainer.notiNewItem("FUEL_COLLECT_NOTIFY")
		if saveToremoveList :
			gameInstant.collectedItem.append(self.get_path())
		if saveAfterCollect :
			gameInstant.saveDat()
		self.queue_free()

func buyItem() :
	addFuel()
		
func checkCanBuy() :
	if valueOfItem > 0 :
		if Varibles.Coins - valueOfItem > 0 :
			return true
		else :
			return false
	else :
		return true

func getbuyvalue() :
	return valueOfItem
	
func interact() :
	if valueOfItem > 0 :
		return "ON_INTERACTION_BUY_FUEL"
	else :
		return "ON_INTERACTION_COLLECT"
