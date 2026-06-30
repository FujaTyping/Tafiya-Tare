extends Node3D

@export var MinPosWithOrigin:int = -2 
var originalPOS = Vector3(0,0,0)
@onready var hiddenPOS = Vector3(0,MinPosWithOrigin,0)

func _ready() :
	self.global_position = hiddenPOS

func ONDAY() :
	Varibles.tweenCam(self,"global_position",hiddenPOS,0.5)
	
func ONNIGHT() :
	Varibles.tweenCam(self,"global_position",originalPOS,0.5)
