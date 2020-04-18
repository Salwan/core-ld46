extends RigidBody2D

export(float) var spawnForce:float = 100.0

func _ready():
	var core_pos = Vector2(1920, 1080)
	look_at(core_pos)
	add_central_force((core_pos - position).normalized() * spawnForce)

func _physics_process(delta):
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
