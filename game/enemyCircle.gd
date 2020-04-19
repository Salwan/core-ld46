extends CEnemy

var aimPoint:Vector2

func on_ready():
	aimPoint = Global.core.get_random_point()

func on_integrate_forces(state:Physics2DDirectBodyState):
	var cur_dir = get_global_transform().basis_xform(Vector2(1, 0))
	var tgt_dir = (aimPoint - get_global_transform().get_origin()).normalized()
	add_force(-cur_dir, tgt_dir * spawnForce * state.step)

func on_collision_explode():
	Global.emit_signal("sig_circle_explode", self)
	explode()
	
