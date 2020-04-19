extends Control

var timeTillBlink:float = 4.0
var blinkCount:int = 0

func _ready():
	if Global.win:
		$gameover.text = "KEPT    IT   ALIVE!"
		$survived.text = "TOTAL   TIME:"
		$anim.play("win")
		$sound_win.play()
	else:
		$anim.play("gameover")
		$sound_dead.play()
	$elapsed.text = str(Global.elapsedTime) + "   seconds"
	$thankyou.visible = false

func _process(delta):
	Global.global_process(delta)
	if Input.is_action_just_pressed("game_start"):
		$sound_select.play()
		get_tree().change_scene("res://gamestart/gamestart.tscn")
	if timeTillBlink > 0:
		timeTillBlink -= delta


func _on_Timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_blink_timeout():
	if timeTillBlink <= 0:
		blinkCount += 1
		$thankyou.visible = blinkCount % 3 != 0
