extends StaticBody3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var notiContainer:MarginContainer = get_tree().current_scene.get_node("player/NotiItem")

func collectRiceSeed() :
	audio_stream_player_3d.play()
	player.RiceSeed = player.RiceSeed + 1
	notiContainer.notiNewItem("SEED_COLLECT_NOTIFY")
	
func interact() :
	return "ON_INTERACTION_COLLECT_SEED"
