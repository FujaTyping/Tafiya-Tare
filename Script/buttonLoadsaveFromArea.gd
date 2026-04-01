extends Button

func _ready() -> void:
	self.pressed.connect(loadThisState)

func loadThisState() :
	UiSound.ui_click()
	Varibles.saved_data = null
	Varibles.isFromLoadSaved = true
	var data = ResourceLoader.load("user://saves/"+self.text.to_lower()+".res") as gameData
	Varibles.saved_data = data
	Varibles.playerSelection = data.player_selection
	ScenesLoader.load_scene("uid://dm0rxd10m14f3")
	MenuMusic.stopmenumusic()
