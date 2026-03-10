extends Node3D

@onready var dialogCanvas: CanvasLayer = get_tree().current_scene.get_node("Dialoges/CanvasLayer")
@onready var typingEffect: AnimationPlayer = get_tree().current_scene.get_node("Dialoges/Typing")
@onready var AniIO : AnimationPlayer = get_tree().current_scene.get_node("Dialoges/IN_Out")
@onready var spearker_name: Label = get_tree().current_scene.get_node("Dialoges/CanvasLayer/Name/MarginContainer/SP")
@onready var dialogText: RichTextLabel = get_tree().current_scene.get_node("Dialoges/CanvasLayer/Context/MarginContainer/Dialoge")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")

@export var dialoguesLine: Array[String]
@export var charLine: Array[String]
@export var isBody: bool
@export var animationBody : Node
@export var helloAnimation: String
@export var talkingAnimation:	String
#@export var speaker: Node3D

var isHelloplaying

var current_dialogue = -1
var started = false

func _ready() -> void:
	dialogCanvas.get_node("Context/Next").connect("pressed", Callable(self,"continume_dialoge"))

func startDialoge(body):
	if body == player and not started :
		started = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.SPEED = 0.0
		#player.sens = 0.0
		dialogCanvas.visible = true
		AniIO.play("In")
		#speaker.look_at(player.global_transform.origin)
		#speaker.rotation_degrees.x = 0
		#speaker.rotation_degrees.z = 0
		if isBody :
			animationBody.get_node("AnimationPlayer").play(helloAnimation)
		continume_dialoge()
		
func endDialoge() :
		player.SPEED = 3.0
		#player.sens = 0.2
		AniIO.play("Out")
		await AniIO.animation_finished
		dialogCanvas.visible = false		
		started = false
		current_dialogue = -1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func continume_dialoge() :
	current_dialogue += 1
	if current_dialogue < dialoguesLine.size() :
		dialogText.text = dialoguesLine[current_dialogue]
		spearker_name.text = charLine[current_dialogue]
		typingEffect.play("RESET")
		typingEffect.play("Writer")
		if not charLine[current_dialogue] == "PLAYER_DIALOGE_NAME" and not animationBody.get_node("AnimationPlayer").is_playing() :
			animationBody.get_node("AnimationPlayer").play(talkingAnimation)
	else :
		endDialoge()
