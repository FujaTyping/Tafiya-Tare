extends Node

func _ready():
	DiscordRPC.app_id = 1481374632601714688
	DiscordRPC.details = "Driving to the Peak of Immortality"
	DiscordRPC.state = "In main menu"
	#DiscordRPC.large_image = "example_game"
	#DiscordRPC.large_image_text = "Try it now!"
	#DiscordRPC.small_image = "boss"
	#DiscordRPC.small_image_text = "Fighting the end boss! D:"

	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()

func updateRPC(state:String) :
	#DiscordRPC.details = details
	DiscordRPC.state = state
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()
	
