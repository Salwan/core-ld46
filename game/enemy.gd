extends RigidBody2D

class_name CEnemy

signal sig_enemy_killed

export(float) var spawnForce:float = 100.0
export(float) var damage:float = 10.0
export(float) var lifetime:float = 10.0
export(float) var collisionKillForce:float = 500.0
export(float) var sfxPaddleForce:float = 450.0

export(PackedScene) var explodeFX = preload("res://game/enemyExplode.tscn")

func _ready():
	contacts_reported = 1
	contact_monitor = true
	on_ready()

func _integrate_forces(state:Physics2DDirectBodyState):
	var cc = state.get_contact_count()
	for i in range(0, cc):
		var n = state.get_contact_collider_object(i)
		if n.is_in_group("enemy") or n.is_in_group("corner"):
			var vf:Vector2 = state.get_contact_collider_velocity_at_position(i)
			if vf.length() >= collisionKillForce:
				if n.is_in_group("enemy"):
					n.on_collision_explode()
				on_collision_explode()
		elif n.is_in_group("player"):
			var vf:Vector2 = state.get_contact_collider_velocity_at_position(i)
			if vf.length() >= sfxPaddleForce:
				Global.emit_signal("sig_paddle_impact")
	on_integrate_forces(state)

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0.0:
		explode()
	on_physics_process(delta)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("sig_enemy_killed")
	queue_free()

# Override to change behavior
func on_ready():
	var core_pos = Global.core.position
	look_at(core_pos)
	add_central_force((core_pos - position).normalized() * spawnForce)

func on_physics_process(delta):
	pass

func on_integrate_forces(state:Physics2DDirectBodyState):
	pass	

func on_collision_explode():
	explode()

func explode():
	var ex = explodeFX.instance()
	ex.global_position = global_position
	get_parent().add_child(ex)
	emit_signal("sig_enemy_killed")
	queue_free()

func disable(dis:bool = true):
	for c in get_children():
		if c is CollisionShape2D:
			c.disabled = dis
