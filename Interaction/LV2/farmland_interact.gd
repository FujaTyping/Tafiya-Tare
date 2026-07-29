extends StaticBody3D

@export var farm_number:int;
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@export var plantScence:PackedScene;
@onready var newSoilDialog:Node3D = get_tree().current_scene.get_node('SpawnAssets/NewSoil')
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var gameInstant:Node3D = get_tree().current_scene

@onready var bad_soil: Node3D = $"Bad Soil"
@onready var good_soil: Node3D = $"Good Soil"

var isGoodForPlant:bool = false;

func _ready() -> void:
	bad_soil.show()
	await Varibles.wait(0.25)
	if Varibles.isFromLoadSaved :
		isGoodForPlant = gameInstant.famelandState[farm_number]
		if isGoodForPlant :
			good_soil.show()
			bad_soil.hide()

func plantRice() :
	if player.haveAPoonPowder :
		player.haveAPoonPowder = false
		var soilDialog = newSoilDialog.duplicate()
		soilDialog.global_position = player.global_position
		get_tree().current_scene.add_child(soilDialog)
		isGoodForPlant = true
		gameInstant.famelandState[farm_number] = true
		audio_stream_player_3d.play()
		good_soil.show()
		bad_soil.hide()
		gameInstant.saveDat()
	else :
		player.RiceSeed = player.RiceSeed - 1
		var playerPOS:Vector3 = player.global_position
		var thisSeed = plantScence.instantiate()
		thisSeed.isFarmLandQLT = isGoodForPlant
		thisSeed.global_position = Vector3(playerPOS.x,playerPOS.y - 0.6, playerPOS.z)
		get_tree().current_scene.add_child(thisSeed)
		thisSeed.startGrow()

func interact() :
	if player.haveAPoonPowder :
		return "ON_INTERACTION_SPRINKLE_LIME_POWDER"
	else :
		return "ON_INTERACTION_PLANT"
