extends StaticBody3D

@onready var gameInstant:Node3D = get_tree().current_scene
@onready var carInstant:VehicleBody3D = get_tree().current_scene.get_node('VehicleBody3D')
@onready var audio: AudioStreamPlayer3D = $Audio

func upgradeTire() :
	audio.play()
	carInstant.max_torque = 190
	gameInstant.collectedItem.append(self.get_path())
	gameInstant.saveDat()
	self.queue_free()

func interact() :
	return "ON_INTERACT_WRENCH_TIRE"
