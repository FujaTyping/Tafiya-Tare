extends Node
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func playmenumusic() :
	audio_stream_player.play()
	
func stopmenumusic() :
	audio_stream_player.stop()
