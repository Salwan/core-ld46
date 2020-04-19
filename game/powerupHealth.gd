extends RigidBody2D

class_name CPowerUp

export(float) var spawnForce:float = 100.0
export(String) var powerType:String = "heal"
export(float) var healAmount:float = 15.0

export(PackedScene) var consumeFX = preload("res://game/healConsume.tscn")

func _ready():
	on_ready()

func _physics_process(delta):
	on_physics_process(delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Override to change behavior
func on_ready():
	var core_pos = Global.core.global_position
	look_at(core_pos)
	add_central_force((core_pos - global_position).normalized() * spawnForce)

func on_physics_process(delta):
	pass

func consume():
	var ex = consumeFX.instance()
	ex.global_position = global_position
	get_parent().add_child(ex)
	queue_free()
