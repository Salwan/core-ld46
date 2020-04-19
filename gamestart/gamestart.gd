extends Control

var ticks:int = 0

func _ready():
	pass

func _process(delta):
	Global.global_process(delta)
	if Input.is_action_just_pressed("game_start"):
		$sound_select.play()
		get_tree().change_scene("res://main.tscn")
	if ticks % 3 == 0:
		$press.visible = false
	else:
		$press.visible = true

func _on_Timer_timeout():
	ticks += 1
