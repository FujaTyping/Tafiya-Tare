extends Node

@export var ImagetoView: CompressedTexture2D
@onready var viewUI : Control = get_tree().current_scene.get_node("ViewPaper")
@onready var textureArea : TextureRect = viewUI.get_node("VBoxContainer/ImageView")

func openViewImage() :
	textureArea.texture = ImagetoView
	viewUI.openImage()

func interact() :
	return "ON_INTERACTION_VIEW"
