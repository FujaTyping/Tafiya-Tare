extends StaticBody3D

@export var isFarmLandQLT:bool = false;
@export var seedGrowTreshold:int = 25;
@onready var rottenDialoge:Node3D = get_tree().current_scene.get_node('SpawnAssets/RottenPlant')
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')

var state:int = 0;

var badGrowState:Array[int] = [0,1,2]
var goodGrowState:Array[int] = [0,1,3,4,5]

# State
@onready var rice_seed: Node3D = $RiceSeed
@onready var rice_tonkhla: Node3D = $"Rice Tonkhla"
@onready var rice_tonkhla_bigger_bad: Node3D = $"Rice Tonkhla Bigger Bad"
@onready var rice_bigger_tonkhla: Node3D = $"Rice Bigger Tonkhla"
@onready var rice_roung: Node3D = $"Rice Roung"
@onready var rice_ready: Node3D = $"Rice Ready"

var allGrowState:Array[Node3D] = []

func _ready() -> void:
	allGrowState = [rice_seed,rice_tonkhla,rice_tonkhla_bigger_bad,rice_bigger_tonkhla,rice_roung,rice_ready]

func getSeedFarmCurrentState() :
	return isFarmLandQLT

func startGrow() :
	if not isFarmLandQLT :
		for i in badGrowState :
			if i != 0 :
				allGrowState[i-1].hide()
				allGrowState[i].show()
			if i != badGrowState[len(badGrowState) - 1] :
				await Varibles.wait(seedGrowTreshold)
		state = 1
	else :
		for i in goodGrowState :
			if i != 0 :
				allGrowState[i-1].hide()
				allGrowState[i].show()
			if i != goodGrowState[len(goodGrowState) - 1] :
				await Varibles.wait(seedGrowTreshold)
		state = 1
	
func collectSeedResult() :
	if rice_seed.visible :
		return
	if not isFarmLandQLT :
		var dialog = rottenDialoge.duplicate()
		dialog.global_position = player.global_position
		get_tree().current_scene.add_child(dialog)
		self.queue_free()
	else :
		player.collectedRice = true
		self.queue_free()
	
func interact() :
	if state == 0 :
		return "SEED_GROWING"
	else :
		return "ON_INTERACTION_HARVEST"
