extends KinematicBody2D

export(float, 50, 500, 50) var paddleSpeed = 250

onready var motion:Vector2 = Vector2(0, 0)
onready var analog:Vector2 = Vector2(0, 0)

func _ready():
	Global.connect("sig_paddle_impact", self, "on_paddle_impact")
	
func _input(event):
	if event is InputEventMouseButton:
		pass
	elif event is InputEventMouseMotion:
		motion = event.relative
	elif event is InputEventJoypadMotion:
		if event.axis == 0:
			analog.x = event.axis_value
		elif event.axis == 1:
			analog.y = event.axis_value

func _physics_process(delta:float):
	if analog.length() < 0.2:
		var ra = motion.x * (paddleSpeed / 10000.0) * delta
		rotation += ra
		$starter_paddles.rotation -= ra * 2
	else:
		var base:Vector2 = Vector2(1, 0)
		var angle = base.angle_to(analog.normalized())
		rotation = angle
		$starter_paddles.rotation = angle
	motion = Vector2(0, 0)

func on_paddle_impact():
	if not $impact.playing:
		$impact.pitch_scale = 0.8 + (float(randi() % 4) * 0.1)
		$impact.play()
