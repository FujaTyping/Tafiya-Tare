extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var margin_container: MarginContainer = $MarginContainer

func isOpenQuest(open:bool) :
	if open :
		margin_container.visible = true
		animation_player.play("QuestIn")
	else :
		animation_player.play("QuestOut")
		await animation_player.animation_finished
		margin_container.visible = false
