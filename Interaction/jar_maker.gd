extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"Jar Make/AnimationPlayer"
@onready var animation_player_2: AnimationPlayer = $"Jar Make/AnimationPlayer2"
@onready var finish: AudioStreamPlayer3D = $Finish
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var collect: AudioStreamPlayer3D = $Collect

@export var listMenu:Array[PackedScene];

var isCooking = false

var tranformationDefault;
var positionDefault;

func resetJar() :
	collect.play();
	animation_player.play("capAction")
	animation_player.stop()
	collision_shape_3d.disabled = false;
	self.show()
	
func _ready() -> void:
	resetJar();
	tranformationDefault = self.global_transform;
	positionDefault = self.global_position;

func level3cooking() :
	var inIngreInv:Array[String] = get_tree().current_scene.get_node("player").IngreInv
	isCooking = true
	animation_player.play("WaterAction");
	animation_player_2.play("capAction");
	await Varibles.wait(15)
	if inIngreInv.size() == 1 and "guava" in inIngreInv :
		spwanItem(listMenu[1])
	else :
		spwanItem(listMenu[0])
	isCooking = false
	finish.play()
	self.hide()
	get_tree().current_scene.get_node("player").resetIngreInv();
	collision_shape_3d.disabled = true;
	
func spwanItem(dish:PackedScene) :
	var newFeedSpawn = dish.instantiate()
	get_tree().current_scene.add_child(newFeedSpawn);
	newFeedSpawn.global_transform = tranformationDefault;
	newFeedSpawn.global_position = positionDefault;
	
func interact() :
	if isCooking :
		return "JAR_PICKLING"
	else :
		return "ON_INTERACTION_PICKLE"
