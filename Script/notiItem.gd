extends MarginContainer

@onready var TEMP_abel: Label = $"VBoxContainer/Label"
@onready var v_box_container: VBoxContainer = $"VBoxContainer"

var sumofNoti:int = 0

func notiNewItem(text:String) :
	var label: Label = TEMP_abel.duplicate()
	label.text = text
	label.show()
	Varibles.tweenCam(label,"modulate",Color("ffffff"),0.25)
	v_box_container.add_child(label)
	sumofNoti += 1
	await  Varibles.wait(5)
	Varibles.tweenCam(label,"modulate",Color("ffffff00"),0.25)
	await  Varibles.wait(0.25)
	sumofNoti -= 1
	label.queue_free()
		
func _process(delta: float) -> void:
	if sumofNoti > 0 :
		self.show()
	else :
		self.hide()
