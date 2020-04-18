extends Node2D

var elapsed:int = 0
var accumTime:float = 0.0

func _ready():
	Global.new_game()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$music.play()
	$time.text = "0"
	$timer.start()
	Global.connect("sig_game_over", self, "on_game_over")

func _process(delta):
	Global.global_process(delta)
	accumTime += delta
	if accumTime >= 0.0:
		accumTime -= 1.0
		elapsed += 1


func _on_music_finished():
	$music.play()


func _on_timer_timeout():
	$time.text = str(elapsed)
	Global.ElapsedTime = elapsed

func on_game_over():
	get_tree().change_scene("res://gameover/gameover.tscn")
