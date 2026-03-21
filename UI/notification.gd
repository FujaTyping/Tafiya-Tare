extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $MarginContainer/Label
@onready var notification: Control = $"."

var prevArea;

func playEnterNoti(areaName:String) :
	if prevArea != areaName :
		label.text = areaName
		animation_player.play("In")
		notification.show()
		await Varibles.wait(5)
		animation_player.play_backwards("In")
		await  animation_player.animation_finished
		notification.hide()
		prevArea = areaName
