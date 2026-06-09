extends Area3D

#@export var FogInstant:FogVolume;
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var environment: WorldEnvironment = $"../../Environment"
@onready var FoggyBGM:AudioStreamPlayer = get_tree().current_scene.get_node("fogsDNBGM");
@onready var gameInstant:Node3D = get_tree().current_scene
@onready var fog_view: TextureRect = $"../../FogView"
@onready var view_w_on: AnimationPlayer = $"../../FogView/ViewWOn"
@onready var carInsant:VehicleBody3D = get_tree().current_scene.get_node("VehicleBody3D")

func _ready() -> void:
	self.body_entered.connect(enableFog);
	self.body_exited.connect(disableFog);

func enableFog(body) :
	if body == player or body == carInsant :
		environment.environment.volumetric_fog_density = 0.05
		FoggyBGM.play()
		fog_view.show()
		view_w_on.play("0.3")
		gameInstant.stopCurrentBGM()

func disableFog(body) :
	if body == player and body == carInsant :
		environment.environment.volumetric_fog_density = 0
		FoggyBGM.stop()
		gameInstant.enableCurentBGM()
		view_w_on.play_backwards("0.3")
		await view_w_on.animation_finished
		fog_view.hide()
