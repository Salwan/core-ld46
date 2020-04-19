extends KinematicBody2D

export(float, 50, 500, 50) var paddleSpeed = 200

onready var motion:Vector2 = Vector2(0, 0)

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		pass
	elif event is InputEventMouseMotion:
		motion = event.relative

func _physics_process(delta:float):
	var ra = motion.x * (paddleSpeed / 10000.0) * delta
	rotation += ra
	$starter_paddles.rotation -= ra * 2
	motion = Vector2(0, 0)
