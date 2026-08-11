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
@onready var c_button: Button = $MarginContainer2/HBoxContainer/CButton
@onready var margin_container: MarginContainer = $MarginContainer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

@onready var marker_3d_2: Marker3D = $Marker3D2
@onready var marker_3d_3: Marker3D = $Marker3D3

@export var confirmIcon:CompressedTexture2D;
@export var trashIcon:CompressedTexture2D;
@onready var Ttexture_button_2: TextureButton = $MarginContainer2/HBoxContainer/TextureButton2

func _ready() -> void:
	camera_3d.global_transform = marker_3d_3.global_transform
	margin_container.modulate = 'ffffff00'
	del_confirm.hide()
	del_button_2.text = "DELETE_ALL_SAVE_BUTTON"
	var dirAccess = DirAccess.open("user://saves")
	var listOfSave = dirAccess.get_files()
	
	for i in listOfSave :
		var loadSaveBTN = button_temp.duplicate()
		loadSaveBTN.show()
		loadSaveBTN.text = i.split(".")[0].to_upper()
		v_box_container_2.add_child(loadSaveBTN)
	
	c_button.grab_focus()
	camPan()
	return
	if v_box_container_2.get_child_count() > 0:
		v_box_container_2.get_child(0).call_deferred("grab_focus")
	
func camPan():
	Varibles.tweenCam(camera_3d,'global_transform',marker_3d_2.global_transform,3)
	await Varibles.wait(2.5)
	animation_player_2.play("fade")

func _on_c_button_pressed() -> void:
	UiSound.ui_click()
	ScenesLoader.load_scene("uid://bk2eqtj4bowsx")

func _on_del_button_2_pressed() -> void:
	UiSound.ui_click()
	if del_button_2.text == "DELETE_ALL_SAVE_BUTTON" :
		del_confirm.show()
		animation_player.play("On")
		del_button_2.text = "CONFIRM_BUTTON"
		Ttexture_button_2.texture_normal = confirmIcon
		Ttexture_button_2.texture_hover = confirmIcon
		Ttexture_button_2.texture_pressed = confirmIcon
		Ttexture_button_2.texture_focused = confirmIcon
	elif del_button_2.text == "CONFIRM_BUTTON" :
		var file_to_remove = "user://saves"
		OS.move_to_trash(ProjectSettings.globalize_path(file_to_remove))
		ScenesLoader.load_scene("uid://bk2eqtj4bowsx")
		
func goThrough() :
	GOanimation_player.play("Out")
	Varibles.tweenCam(margin_container_2,"position",Vector2(1930,1000),0.3)
	UiSound.ui_whoose()
	Varibles.tweenCam(camera_3d,"global_transform",marker_3d.global_transform,4)

func _on_close_pressed() -> void:
	UiSound.ui_click()
	del_button_2.text = "DELETE_ALL_SAVE_BUTTON"
	Ttexture_button_2.texture_normal = trashIcon
	Ttexture_button_2.texture_hover = trashIcon
	Ttexture_button_2.texture_pressed = trashIcon
	Ttexture_button_2.texture_focused = trashIcon
	animation_player.play_backwards("On")
	await animation_player.animation_finished
	del_confirm.hide()
