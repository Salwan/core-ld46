extends Node2D

var soundDone = false
var particlesDone = false

func _ready():
	$sfx.play()
	$particles.emitting = true
	$particles2.emitting = true

func _process(delta):
	particlesDone = $particles.emitting and $particles2.emitting
	if soundDone and particlesDone:
		queue_free()

func _on_sfx_finished():
	soundDone = true
