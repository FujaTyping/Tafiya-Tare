extends Node

signal progress_changed(progress)
signal load_finished

var loading_screen : PackedScene = preload("uid://xdi33cxrxj5q")
var loaded_resource: PackedScene
var scence_path: String
var progress:Array = []
var use_sub_threads: bool = true

func _ready() -> void:
	set_process(false)
	
func load_scene(_scence_path:String) -> void:
	scence_path = _scence_path
	
	var new_load_screen = loading_screen.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)
	
	await new_load_screen.loading_screen_ready
	
	start_load()
	
func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scence_path,"",use_sub_threads)
	if state == OK :
		set_process(true)
		
func _process(delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scence_path,progress)
	progress_changed.emit(progress[0])
	match load_status :
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE , ResourceLoader.THREAD_LOAD_FAILED :
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED :
			loaded_resource = ResourceLoader.load_threaded_get(scence_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()
