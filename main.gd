extends Node2D

signal sig_init_game

var elapsed:int = 0
var accumTime:float = 0.0
var levelTime:float

export(PackedScene) var levelName = preload("res://game/levelName.tscn")

func _ready():
	Global.new_game(0, $core)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$music.play()
	$time.text = "0"
	$timer.start()
	Global.connect("sig_game_over", self, "on_game_over")
	Global.connect("sig_next_level", self, "on_next_level")
	on_next_level(0)

func _process(delta):
	Global.global_process(delta)
	levelTime -= delta
	if levelTime <= 0.0:
		# end of level
		Global.next_level()
	accumTime += delta
	if accumTime >= 0.0:
		accumTime -= 1.0
		elapsed += 1


func _on_music_finished():
	$music.play()


func _on_timer_timeout():
	$time.text = str(elapsed)
	Global.elapsedTime = elapsed

func on_game_over():
	get_tree().change_scene("res://gameover/gameover.tscn")

func on_next_level(level_num):
	$spawner.kill_all()
	emit_signal("sig_init_game")
	var ln = levelName.instance()
	add_child(ln)
	levelTime = Global.currentLevel.time

#func next_level():
#	Global.next_level()
