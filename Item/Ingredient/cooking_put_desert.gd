extends StaticBody3D

var isCooking = false

@export var listArrayMenu: Array[PackedScene]
@onready var item_spawn: Marker3D = $ItemSpawn
@onready var finish: AudioStreamPlayer3D = $Finish

func level3cooking() :
	var isInpot:Array[String] = get_tree().current_scene.get_node("player").IngreInv
	isCooking = true
	await Varibles.wait(15)
	if "floor" in isInpot and "sugar" in isInpot and isInpot.size() == 2 :
		spawnFood(listArrayMenu[1])
	else :
		spawnFood(listArrayMenu[0])
	finish.play()
	isCooking = false
	get_tree().current_scene.get_node("player").resetIngreInv()

func spawnFood(ArrayIndex: PackedScene) :
	var rewardItem = ArrayIndex.instantiate()
	get_tree().current_scene.add_child(rewardItem)
	rewardItem.global_transform = item_spawn.global_transform

func interact() :
	if isCooking :
		return "COOKING_POT_DESERT_COOKING"
	else :
		return "ON_INTERACTION_COOK_DESERT"
