extends Control

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$sound_select.play()
		get_tree().change_scene("res://main.tscn")
