extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"../L3ChefNPC/AnimationPlayer"
@onready var failed_dialog: Node3D = $"../FailedDialog"
@onready var l_3_chef_npc: Node3D = $"../L3ChefNPC"
@onready var failedPos: Vector3 = failed_dialog.position;
@onready var pass_dialog: Node3D = $"../PassDialog"
@onready var passPos: Vector3 = pass_dialog.position;
@onready var selfDefaultPos: Vector3 = self.position
@onready var success: AudioStreamPlayer3D = $"../Success"
@onready var failed: AudioStreamPlayer3D = $"../Failed"
@onready var gameInstant : Node3D = get_tree().current_scene
@onready var item_spawn_marker: Marker3D = $"../ItemSpawnMarker"
@onready var marker_3d: Marker3D = $"../Marker3D"

@export var reward:PackedScene;

var enableSubmitQuestLevel3 = false;
var notGoodDish:Array[String] = ['burnt', 'failedjar'];

func _ready() -> void:
	if Varibles.isFromLoadSaved :
		if Varibles.saved_data.enableSubmitQuestLevel3 :
			self.position = marker_3d.position

func submitDish() :
	var currentDish = get_tree().current_scene.get_node("player").FoodInv;
	get_tree().current_scene.get_node("player").resetFoodInv();
	for i in notGoodDish :
		if currentDish == i :
			animation_player.play("BadDish");
			await animation_player.animation_finished
			failed_dialog.position = l_3_chef_npc.position
			failed.play()
			get_tree().current_scene.get_node("player").hideInteraction()
			await Varibles.wait(0.5);
			failed_dialog.global_position = failedPos
			return
	animation_player.play("GoodDish");
	await animation_player.animation_finished
	get_tree().current_scene.get_node("player").hideInteraction()
	pass_dialog.position = l_3_chef_npc.position
	var RewardItem = reward.instantiate()
	gameInstant.add_child(RewardItem);
	enableSubmitQuestLevel3 = false
	RewardItem.global_position = item_spawn_marker.global_position;
	RewardItem.saveToremoveList = false;
	RewardItem.fuelValue = 60;
	success.play()
	await Varibles.wait(0.5);
	pass_dialog.global_position = passPos
	self.position = selfDefaultPos
	self.hide()

func interact() :
	return "ON_INTERACTION_SUBMIT_QUEST_LEVEL_3"
