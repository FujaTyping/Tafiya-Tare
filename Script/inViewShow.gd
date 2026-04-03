extends Node3D

@export var notiShow:VisibleOnScreenNotifier3D

func _ready() -> void:
	notiShow.screen_entered.connect(showArea)
	notiShow.screen_exited.connect(hideArea)
	
func showArea() :
	self.show()
	
func hideArea() :
	self.hide()
