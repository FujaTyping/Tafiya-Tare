extends CanvasLayer

@onready var label: Label = $Label
@onready var start: AudioStreamPlayer = $Start
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		Varibles.quest_State = Varibles.saved_data.quest_State
	else :
		Varibles.quest_State = 0

func hideQuest() :
	if self.visible :
		animation_player.play_backwards("In")
		await animation_player.animation_finished
		self.visible = false

func startQuest(questState: int,VisibleTime: int = 8) :
	if questState - Varibles.quest_State == 1 :
		Varibles.quest_State += 1
		label.text = "QUEST_STARTED_LEVEL_" + str(questState)
		await  Varibles.wait(3)
		animation_player.play("In")
		await  Varibles.wait(0.025)
		self.visible = true
		start.play()
		await Varibles.wait(VisibleTime)
		animation_player.play_backwards("In")
		await animation_player.animation_finished
		self.visible = false
