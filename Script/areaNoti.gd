extends Area3D

@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var AreaNoti:Control = get_tree().current_scene.get_node("Notification")
@export var Areaname:String
@onready var vehicle_body_3d: VehicleBody3D = $"../../VehicleBody3D"
@export var questName: int
@onready var questInstant : CanvasLayer = get_tree().current_scene.get_node("QuestNoti")

func _ready() -> void:
	self.body_entered.connect(bodyEnter)
	
func bodyEnter(body) :
	if not AreaNoti.visible :
		if body == player: #or body == vehicle_body_3d
			AreaNoti.playEnterNoti(Areaname)
			questInstant.startQuest(questName)
