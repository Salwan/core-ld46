extends Node2D

export(Array, AudioStream) var explodeSfx:Array

var soundDone = false
var particlesDone = false

func _ready():
	$player.stream = explodeSfx[randi() % len(explodeSfx)]
	$player.play()
	$particles.emitting = true

func _process(delta):
	particlesDone = $particles.emitting
	if soundDone and particlesDone:
		queue_free()

func _on_player_finished():
	soundDone = true
