extends StaticBody3D

@export var isFarmLandQLT:bool = false;
@export var seedGrowTreshold:int = 25;

var state:int = 0;

var badGrowState:Array[int] = [0,1,2]
var goodGrowState:Array[int] = [0,1,3,4]

# State
@onready var rice_seed: Node3D = $RiceSeed
@onready var rice_tonkhla: Node3D = $"Rice Tonkhla"
@onready var rice_tonkhla_bigger_bad: Node3D = $"Rice Tonkhla Bigger Bad"

var allGrowState:Array[Node3D] = []

func _ready() -> void:
	allGrowState = [rice_seed,rice_tonkhla,rice_tonkhla_bigger_bad]

func startGrow() :
	if not isFarmLandQLT :
		for i in badGrowState :
			if i > 0 :
				allGrowState[i-1].hide()
				allGrowState[i].show()
			if i != badGrowState[len(badGrowState) - 1] :
				await Varibles.wait(seedGrowTreshold)
		state = 1
	
func collectSeedResult() :
	self.queue_free()
	
func interact() :
	if state == 0 :
		return "SEED_GROWING"
	else :
		return "ON_INTERACTION_HARVEST"
