extends StaticBody3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var marker_3d: Marker3D = $"../Marker3D"
@onready var done: Node3D = $"../Done"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"

@onready var nowPOS:Vector3 = self.global_position

func submitQuestLV2() :
	audio_stream_player_3d.play()
	player.collectedRice = false
	self.global_position = nowPOS
	done.global_position = marker_3d.global_position

func interact() :
	return "INTERACTION_SUBMIT_QUEST_LEVEL_4"
