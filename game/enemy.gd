extends RigidBody2D

class_name CEnemy

export(float) var spawnForce:float = 100.0
export(float) var damage:float = 10.0

export(PackedScene) var explodeFX = preload("res://game/enemyExplode.tscn")

func _ready():
	on_ready()

func _physics_process(delta):
	on_physics_process(delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Override to change behavior
func on_ready():
	var core_pos = Global.core.position
	look_at(core_pos)
	add_central_force((core_pos - position).normalized() * spawnForce)

func on_physics_process(delta):
	pass

func explode():
	var ex = explodeFX.instance()
	ex.global_position = global_position
	get_parent().add_child(ex)
	queue_free()
