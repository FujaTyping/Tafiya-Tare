extends MarginContainer

@export var ACH_Texture:Array[CompressedTexture2D]
@onready var badge: TextureRect = $HBoxContainer/Badge
@onready var tname: Label = $HBoxContainer/VBoxContainer/Name
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ach: AudioStreamPlayer3D = $"../ach"

func _ready() -> void:
	self.hide()
	self.position = Vector2(0,-250)
	
func newACHNoti(ach_index) :
	if Varibles.isSteamRunning :
		return
	badge.texture = ACH_Texture[ach_index]
	tname.text = str("ARCHIVEMENT_VILLAGE_",ach_index+1,"_TITLE")
	animation_player.play("slide")
	self.show()
	ach.play()
	await Varibles.wait(8)
	animation_player.play_backwards("slide")
	await animation_player.animation_finished
	self.hide()
