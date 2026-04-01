extends Area3D

@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var AreaNoti:Control = get_tree().current_scene.get_node("Notification")
@export var Areaname:String
@onready var vehicle_body_3d: VehicleBody3D = $"../../VehicleBody3D"
@export var questName: int = 0
@onready var questInstant : CanvasLayer = get_tree().current_scene.get_node("QuestNoti")
@onready var gameInstant : Node3D =  get_tree().current_scene
@export var saveGameFile: String

func _ready() -> void:
	self.body_entered.connect(bodyEnter)
	
func bodyEnter(body) :
	if not AreaNoti.visible :
		if body == player: #or body == vehicle_body_3d
			AreaNoti.playEnterNoti(Areaname)
			gameInstant.currentGameSaveArea = saveGameFile.to_lower()
			if questName != 0 :
				questInstant.startQuest(questName)
