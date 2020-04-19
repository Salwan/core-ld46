extends CEnemy

var timeTillOrient:float = 0.0
var aimPoint:Vector2
#var slowDown:bool = false

func on_ready():
	aimPoint = Global.core.get_random_point()

func on_physics_process(delta):
	if timeTillOrient > 0.0:
		timeTillOrient -= delta

func on_integrate_forces(state:Physics2DDirectBodyState):
	var cur_dir = get_global_transform().basis_xform(Vector2(1, 0))
	var tgt_dir = (aimPoint - get_global_transform().get_origin()).normalized()
	var at = cur_dir.angle_to(tgt_dir)
		

	if timeTillOrient > 0.0:
		return
	else:
		add_force(Vector2(0, 0), tgt_dir * spawnForce * state.step)

	if abs(at) >= 0.001:
		angular_velocity = clamp(at, -0.05, 0.05) / state.step
	else:
		timeTillOrient = 0.5
	
