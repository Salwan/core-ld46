extends Node

signal sig_game_over
signal sig_new_game
signal sig_next_level(level_num)
# Action when paddles impact an enemy piece at force
signal sig_paddle_impact
# Action when circle impact explodes another piece
signal sig_circle_explode(cir)

enum eRunMode { RELEASE, DEBUG }
const RunMode = eRunMode.DEBUG

var elapsedTime:int = 0
var currentLevelNumber:int = 0
var currentLevel:LevelData.cLevel = null
var core:Node2D = null

func is_debug() -> bool:
	return RunMode == eRunMode.DEBUG

func new_game(level_index:int, player_core:Node2D):
	currentLevelNumber = level_index
	currentLevel = LevelData.CreateLevel(level_index)
	print("Level: " + str(currentLevel.name))
	elapsedTime = 0
	emit_signal("sig_new_game")
	core = player_core
	assert(core)

func next_level():
	currentLevelNumber += 1
	if currentLevelNumber < LevelData.GetLevelCount():
		currentLevel = LevelData.CreateLevel(currentLevelNumber)
		emit_signal("sig_next_level", currentLevelNumber)
	else:
		game_over(true)

func game_over(won:bool = false):
	emit_signal("sig_game_over")

func global_process(delta):
	if RunMode == eRunMode.DEBUG:
		if Input.is_action_just_pressed("debug_quit"):
			get_tree().quit()
		if Input.is_action_just_pressed("debug_nextlevel"):
			next_level()

func random_point_in_circle(pos:Vector2, rad:float):
	var r = randf() * rad
	var t = randf() * PI * 2.0
	return Vector2(pos.x + (r * cos(t)), pos.y + (r * sin(t)))
