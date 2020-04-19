extends Node

signal sig_game_over
signal sig_new_game
signal sig_next_level(level_num)
# Action when paddles impact an enemy piece at force
signal sig_paddle_impact
# Action when circle impact explodes another piece
signal sig_circle_explode(cir)

enum eRunMode { RELEASE, DEBUG }
const RunMode = eRunMode.RELEASE

var elapsedTime:int = 0
var currentLevelNumber:int = 0
var currentLevel:LevelData.cLevel = null
var core:Node2D = null
var main:Node2D = null
var win:bool = false

func is_debug() -> bool:
	return RunMode == eRunMode.DEBUG

func new_game(level_index:int, player_core:Node2D, game_main:Node2D):
	currentLevelNumber = level_index
	currentLevel = LevelData.CreateLevel(level_index)
	print("Level: " + str(currentLevel.name))
	elapsedTime = 0
	emit_signal("sig_new_game")
	core = player_core
	assert(core)
	main = game_main
	assert(main)
	win = false

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
		if Input.is_action_just_pressed("debug_spawnboss"):
			if main.get_node("spawnParent"):
				var boss_s = preload("res://game/boss.tscn")
				var boss = boss_s.instance()
				main.get_node("spawnParent").add_child(boss)
		if Input.is_action_just_pressed("debug_heal"):
			core.heal(100.0)

func random_point_in_circle(pos:Vector2, rad:float):
	var r = randf() * rad
	var t = randf() * PI * 2.0
	return Vector2(pos.x + (r * cos(t)), pos.y + (r * sin(t)))
