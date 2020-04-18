extends Control

func _ready():
	$elapsed.text = str(Global.ElapsedTime) + "   seconds"
	$sound_dead.play()

func _process(delta):
	Global.global_process(delta)
	if Input.is_action_just_pressed("ui_accept"):
		$sound_select.play()
		get_tree().change_scene("res://main.tscn")


func _on_Timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
