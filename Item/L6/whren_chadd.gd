extends StaticBody3D

@onready var gameInstant:Node3D = get_tree().current_scene
@onready var carInstant:VehicleBody3D = get_tree().current_scene.get_node('VehicleBody3D')
@onready var audio: AudioStreamPlayer3D = $Audio
@onready var notiContainer:MarginContainer = get_tree().current_scene.get_node("player/NotiItem")

func upgradeTire() :
	audio.play()
	carInstant.max_torque = 190
	notiContainer.notiNewItem("TIRE_UPGRADE_NOTIFY")
	gameInstant.collectedItem.append(self.get_path())
	gameInstant.saveDat()
	self.queue_free()

func interact() :
	return "ON_INTERACT_WRENCH_TIRE"
