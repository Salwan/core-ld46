extends Node

signal sig_game_over
signal sig_new_game

enum eRunMode { RELEASE, DEBUG }
const RunMode = eRunMode.DEBUG

var ElapsedTime:int

func is_debug() -> bool:
	return RunMode == eRunMode.DEBUG

func new_game():
	ElapsedTime = 0
	emit_signal("sig_new_game")

func game_over():
	emit_signal("sig_game_over")

func global_process(delta):
	if RunMode == eRunMode.DEBUG:
		if Input.is_action_just_pressed("debug_quit"):
			get_tree().quit()
