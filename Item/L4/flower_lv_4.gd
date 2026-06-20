extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"KaTongRuuSii A/AnimationPlayer"
	
func brew() :
	animation_player.play("ArmatureAction")

func interact() :
	return "ON_INTERACTION_SUBMIT_QUEST_LEVEL_4"
