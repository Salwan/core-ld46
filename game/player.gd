extends KinematicBody2D

export(float, 50, 500, 50) var paddleSpeed = 200

onready var motion:Vector2 = Vector2(0, 0)

func _ready():
	Global.connect("sig_paddle_impact", self, "on_paddle_impact")
	
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

func on_paddle_impact():
	if not $impact.playing:
		$impact.pitch_scale = 0.8 + (float(randi() % 4) * 0.1)
		$impact.play()
