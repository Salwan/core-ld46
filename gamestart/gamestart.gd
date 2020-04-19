extends Control

var ticks:int = 0
var timeTillBlinks:float = 2.5

func _ready():
	$press.visible = false
	$anim.play("intro")

func _process(delta):
	Global.global_process(delta)
	if timeTillBlinks > 0:
		timeTillBlinks -= delta
	if Input.is_action_just_pressed("game_start"):
		$sound_select.play()
		get_tree().change_scene("res://main.tscn")

func _on_Timer_timeout():
	if timeTillBlinks <= 0:
		ticks += 1
		$press.visible = ticks % 3 != 0
