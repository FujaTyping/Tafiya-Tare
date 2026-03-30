extends Node

var playerSelection = "joker"
var playerName = "Player"
var DNCycle = "00:00"
var MouseSens = 0.2
var BGM = true
var SFX = true
var LangIndex = 0
var wantCinematic = true
var maxFPSindex = 1
var questAvalable = true
var questState = ""
var isQuestDone = false
var Coins = 0
var isFromLoadSaved = false
var saved_data : gameData
var quest_State: int = 0
var ListNPCbackCar: Array[String] = []

func wait(seconds):
	await get_tree().create_timer(seconds).timeout
	
func tweenCam(node,property,targetNode,duration) :
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, property, targetNode, duration)
