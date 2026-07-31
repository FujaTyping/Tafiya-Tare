extends Area3D

@onready var player:CharacterBody3D = get_tree().current_scene.get_node('player')
@onready var gameInstant:Node3D = get_tree().current_scene

var firstTimeSave:bool = false;

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		firstTimeSave = Varibles.saved_data.last_savepoint

func _on_body_entered(body: Node3D) -> void:
	if body == player and not firstTimeSave :
		gameInstant.mtSavePoint = true
		firstTimeSave = true
		gameInstant.saveDat()
