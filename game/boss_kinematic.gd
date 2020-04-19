extends KinematicBody2D

export(float) var gearSpeed = 10.0
export(float) var linearSpeed = 2000.0
export(float) var radialSpeed = 2.0 * PI / 3.0
export(float) var health = 60.0

enum eState { INTRO, POSITION, STANDBY, GRAB, THROW }
var state:int = eState.INTRO

enum eMotionState { IDLE, MOVETO, RADIAL_MOVETO }
var motionState:int = eMotionState.IDLE
var moveTo:Vector2
var radialMoveTo:float
var movementRadius:float

func _ready():
	var side = randi() % 4
	var spawn_pos:Vector2
	var first_move:Vector2
	match side:
		0: # top
			spawn_pos = Global.main.get_node("bossTopSpawn").position
			first_move = Global.main.get_node("bossTopPos").position
		1: # left
			spawn_pos = Global.main.get_node("bossLeftSpawn").position
			first_move = Global.main.get_node("bossLeftPos").position
		2: # bottom
			spawn_pos = Global.main.get_node("bossBottomSpawn").position
			first_move = Global.main.get_node("bossBottomPos").position
		3: # right
			spawn_pos = Global.main.get_node("bossRightSpawn").position
			first_move = Global.main.get_node("bossRightPos").position
	#spawn_pos = Vector2(-300, 1080)
	#first_move = Vector2(1920-980, 1080)
	global_position = spawn_pos
	look_at(get_core_pos())
	moveTo = first_move
	motionState = eMotionState.MOVETO
	movementRadius = Global.main.get_node("bossCircle").shape.radius
	print("Boss radius: " + str(movementRadius))
	$sfx_intro.play()

func _process(delta):
	var r = gearSpeed * delta
	$gear1.rotate(-r)
	$gear2.rotate(-r)
	$gear3.rotate(r)
	$gear4.rotate(r)

func _physics_process(delta):
	match motionState:
		eMotionState.IDLE:
			pass
		eMotionState.MOVETO:
			move_to(delta)
		eMotionState.RADIAL_MOVETO:
			radial_move_to(delta)

func get_core_pos()->Vector2:
	return Global.core.global_position

func dir_to_core()->Vector2:
	return (get_core_pos() - global_position).normalized()

func on_motion_end():
	if state == eState.INTRO:
		reposition()
	elif state == eState.POSITION:
		# go on standby for random duration, listen for enemies to toss
		pass
	elif state == eState.STANDBY:
		reposition()

func reposition():
	state = eState.POSITION
	queue_radial_move_to(PI * 2.0 * randf())

func queue_move_to(position):
	moveTo = position
	motionState = eMotionState.MOVETO
	$sfx_position.play()

func queue_radial_move_to(angle):
	radialMoveTo = angle
	motionState = eMotionState.RADIAL_MOVETO
	$sfx_dash.play()

func move_to(delta):
	if (global_position - moveTo).length_squared() > (delta * linearSpeed * 1.5):
		look_at(moveTo)
		move_and_collide((moveTo - global_position).normalized() * linearSpeed * delta)
	else:
		global_position = moveTo
		motionState = eMotionState.MOVETO
		on_motion_end()

func radial_move_to(delta):
	
#	var dir = (global_position - get_core_pos()).normalized()
#	var cur_angle = dir.angle_to(Vector2(1, 0))
#	var dest_dir = Vector2(1, 0).rotated(radialMoveTo)
#	if cur_angle > (delta * radialSpeed * 1.5):
#		look_at(get_core_pos())
#		move_and_collide(dir.slerp(dest_dir, 0.1) * delta)
#	else:
#		pass
