extends Node3D

# Use groups or unique names to avoid long paths
@onready var dialogCanvas: CanvasLayer = get_tree().current_scene.get_node("Dialoges/CanvasLayer")
@onready var typingEffect: AnimationPlayer = get_tree().current_scene.get_node("Dialoges/Typing")
@onready var AniIO : AnimationPlayer = get_tree().current_scene.get_node("Dialoges/IN_Out")
@onready var spearker_name: Label = get_tree().current_scene.get_node("Dialoges/CanvasLayer/MarginContainer2/SP")
@onready var dialogText: RichTextLabel = get_tree().current_scene.get_node("Dialoges/CanvasLayer/Dialoge")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var typingContainer: LineEdit = get_tree().current_scene.get_node("Dialoges/CanvasLayer/LineEdit")

@export var dialoguesLine: Array[String]
@export var charLine: Array[String]
@export var isBody: bool
@export var animationBody : Node
@export var helloAnimation: String
@export var talkingAnimation: String
@export var saveAfter : bool
@export var useTyping: bool
@export var typingPlaceholder: String

var current_dialogue = 0 # Start at 0
var started = false
var playerSpeedBefore: float = 0.0

func _ready() -> void:
	if useTyping:
		typingContainer.placeholder_text = typingPlaceholder
	
	# Check if already connected to avoid duplication
	var btn = dialogCanvas.get_node("TNext")
	if not btn.is_connected("pressed", _on_next_pressed):
		btn.pressed.connect(_on_next_pressed)

func _on_next_pressed():
	if started: # Only trigger if THIS specific instance is active
		continume_dialoge()

func startDialoge(body):
	if body == player and not started:
		started = true
		current_dialogue = 0 # Reset here
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		playerSpeedBefore = player.SPEED
		player.SPEED = 0.0
		
		dialogCanvas.visible = true
		AniIO.play("In")
		
		if isBody and animationBody:
			animationBody.get_node("AnimationPlayer").play(helloAnimation)
		
		display_current_line() # New helper function

func endDialoge():
	player.SPEED = playerSpeedBefore
	AniIO.play("Out")
	await AniIO.animation_finished
	dialogCanvas.visible = false        
	started = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if saveAfter:
		await get_tree().create_timer(2.0).timeout
		get_tree().current_scene.saveDat()

func _input(event: InputEvent) -> void:
	if not started: return
	
	if Input.is_action_just_pressed("interaction"):
		# Prevent skip if typing is required
		if dialoguesLine[current_dialogue] == "[INPUT]":
			return 
		continume_dialoge()

func continume_dialoge():
	# Validation for Input field
	if dialoguesLine[current_dialogue] == "[INPUT]" and typingContainer.text.length() < 6:
		return
		
	current_dialogue += 1
	
	if current_dialogue < dialoguesLine.size():
		display_current_line()
	else:
		endDialoge()

func display_current_line():
	var line = dialoguesLine[current_dialogue]
	spearker_name.text = charLine[current_dialogue]
	
	# Handle Input UI
	if line == "[INPUT]" and useTyping:
		dialogText.hide()
		typingContainer.show()
		typingContainer.grab_focus()
	else:
		if useTyping:
			typingContainer.hide()
			dialogText.show()
		
		# Replace [RESULT] dynamically without destroying the original array logic
		var final_text = line
		if line == "[RESULT]":
			final_text = typingContainer.text
			
		dialogText.text = final_text
		typingEffect.play("RESET")
		typingEffect.play("Writer")
		
		if isBody and animationBody:
			if not spearker_name.text == "PLAYER_DIALOGE_NAME" :
				var ap = animationBody.get_node("AnimationPlayer")
				if not ap.is_playing():
					ap.play(talkingAnimation)
