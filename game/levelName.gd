extends Control

func _ready():
	if Global.currentLevel:
		$name.text = Global.currentLevel.name
	else:
		$name.text = "WELL DONE"

func _process(delta):
	pass

func end_of_anim():
	queue_free()
