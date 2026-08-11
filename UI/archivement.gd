extends Control

@export var listbadgeImage:Array[CompressedTexture2D];
@onready var container: VBoxContainer = $MarginContainer/VBoxContainer3/VBoxContainer2
@onready var item: HBoxContainer = $MarginContainer/VBoxContainer3/VBoxContainer2/HBoxContainer
@onready var label: Label = $MarginContainer/VBoxContainer3/Label
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var margin_container: MarginContainer = $MarginContainer

var badgeContent = [
	{"title":'ARCHIVEMENT_VILLAGE_1_TITLE',"desc": 'ARCHIVEMENT_VILLAGE_1_DESC'},
	{"title":'ARCHIVEMENT_VILLAGE_2_TITLE',"desc": 'ARCHIVEMENT_VILLAGE_2_DESC'},
	{"title":'ARCHIVEMENT_VILLAGE_3_TITLE',"desc": 'ARCHIVEMENT_VILLAGE_3_DESC'},
	{"title":'ARCHIVEMENT_VILLAGE_4_TITLE',"desc": 'ARCHIVEMENT_VILLAGE_4_DESC'},
	{"title":'ARCHIVEMENT_VILLAGE_5_TITLE',"desc": 'ARCHIVEMENT_VILLAGE_5_DESC'},
	{"title":'ARCHIVEMENT_VILLAGE_6_TITLE',"desc": 'ARCHIVEMENT_VILLAGE_6_DESC'}
]

var listCollectBadge = []

func _ready() -> void:
	margin_container.modulate = 'ffffff00'
	camera_3d.global_transform = marker_3d_2.global_transform
	
	if FileAccess.file_exists('user://achievement_data.res') :
		var data = ResourceLoader.load('user://achievement_data.res') as achievementData
		listCollectBadge = data.list_of_achievement
 	
	if not listCollectBadge :
		label.show()
	else :	
		label.hide()
		for i in listCollectBadge :
			var thisBadge = item.duplicate(	)
			thisBadge.get_node('BadgeImg').texture = listbadgeImage[i]
			thisBadge.get_node('VBoxContainer/Title').text = badgeContent[i].title
			thisBadge.get_node('VBoxContainer/Desc').text = badgeContent[i].desc
			thisBadge.show()
			container.add_child(thisBadge)
	
	panCam()
	disableShadows(Varibles.allShadowsShow)
	
func panCam() :
	Varibles.tweenCam(camera_3d,'global_transform',marker_3d.global_transform,3)
	await Varibles.wait(2.5)
	animation_player.play("fade")

func disableShadows(eN:bool) :
	var sun:DirectionalLight3D = get_tree().current_scene.get_node('Sun')
	if not eN :
		sun.shadow_enabled = false
	else :
		sun.shadow_enabled = true

func _on_c_button_pressed() -> void:
	UiSound.ui_click()
	ScenesLoader.load_scene('uid://bk2eqtj4bowsx')
