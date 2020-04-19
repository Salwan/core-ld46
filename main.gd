extends Node2D

signal sig_init_game

var elapsed:int = 0
var accumTime:float = 0.0
var levelTime:float

export(Array, AudioStream) var musicTracks = []

export(PackedScene) var levelName = preload("res://game/levelName.tscn")

func _ready():
	Global.main = self
	Global.new_game(0, $core, self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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
	if $win.visible:
		$win.modulate = Color(0.5 + (randf() * 0.5), 0.3 + (randf() * 0.7), 0.35 + (randf() * 0.65))

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
	if $music.playing:
		$music.stop()
	$music.stream = musicTracks[Global.currentLevelNumber % len(musicTracks)]
	$music.play()
	$bg.color = Color(Global.currentLevel.bg)

#func next_level():
#	Global.next_level()

func winning():
	# Winning teaser!
	$win.visible = true
	$sfx_win.play()
	Global.win = true
