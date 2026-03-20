extends StaticBody3D

var isInpot = []
var isCooking = false

@export var listArrayMenu: Array[PackedScene]
@onready var item_spawn: Marker3D = $ItemSpawn
@onready var finish: AudioStreamPlayer3D = $Finish

func level3cooking() :
	isCooking = true
	await Varibles.wait(10)
	if "floor" in isInpot and "egg" in isInpot and isInpot.size() == 2 :
		spawnFood(listArrayMenu[1])
	elif "potato" in isInpot and "cucumber" in isInpot and "bellPeper" in isInpot and isInpot.size() == 3 :
		spawnFood(listArrayMenu[2])
	else :
		var rewardItem = listArrayMenu[0].instantiate()
		get_tree().current_scene.add_child(rewardItem)
		rewardItem.global_transform = item_spawn.global_transform
	finish.play()
	isCooking = false
	isInpot = []

func spawnFood(ArrayIndex: PackedScene) :
	var rewardItem = ArrayIndex.instantiate()
	get_tree().current_scene.add_child(rewardItem)
	rewardItem.global_transform = item_spawn.global_transform

func interact() :
	if isCooking :
		return "COOKING_POT_COOKING"
	else :
		return "ON_INTERACTION_COOK"
