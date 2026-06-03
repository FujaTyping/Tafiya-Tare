extends Area3D

#@export var FogInstant:FogVolume;
@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var environment: WorldEnvironment = $"../../Environment"

func _ready() -> void:
	self.body_entered.connect(enableFog);
	self.body_exited.connect(disableFog);

func enableFog(body) :
	if body == player :
		environment.environment.volumetric_fog_density = 0.05

func disableFog(body) :
	if body == player :
		environment.environment.volumetric_fog_density = 0
