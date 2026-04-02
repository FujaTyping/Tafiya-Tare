extends Control

@onready var button_temp: Button = $MarginContainer/VBoxContainer3/VBoxContainer2/Button_TEMP
@onready var v_box_container_2: VBoxContainer = $MarginContainer/VBoxContainer3/VBoxContainer2
@onready var del_confirm: CanvasLayer = $DelConfirm
@onready var animation_player: AnimationPlayer = $DelConfirm/AnimationPlayer
@onready var del_button_2: Button = $MarginContainer2/HBoxContainer/DelButton2
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var GOanimation_player: AnimationPlayer = $AnimationPlayer
@onready var margin_container_2: MarginContainer = $MarginContainer2

func _ready() -> void:
	del_confirm.hide()
	del_button_2.text = "DELETE_ALL_SAVE_BUTTON"
	var dirAccess = DirAccess.open("user://saves")
	var listOfSave = dirAccess.get_files()
	
	for i in listOfSave :
		var loadSaveBTN = button_temp.duplicate()
		loadSaveBTN.show()
		loadSaveBTN.text = i.split(".")[0].to_upper()
		v_box_container_2.add_child(loadSaveBTN)

func _on_c_button_pressed() -> void:
	UiSound.ui_click()
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")

func _on_del_button_2_pressed() -> void:
	UiSound.ui_click()
	if del_button_2.text == "DELETE_ALL_SAVE_BUTTON" :
		del_confirm.show()
		animation_player.play("On")
		del_button_2.text = "CONFIRM_BUTTON"
	elif del_button_2.text == "CONFIRM_BUTTON" :
		var file_to_remove = "user://saves"
		OS.move_to_trash(ProjectSettings.globalize_path(file_to_remove))
		ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
		
func goThrough() :
	GOanimation_player.play("Out")
	Varibles.tweenCam(margin_container_2,"position",Vector2(1930,1000),0.3)
	UiSound.ui_whoose()
	Varibles.tweenCam(camera_3d,"global_transform",marker_3d.global_transform,4)
