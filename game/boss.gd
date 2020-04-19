extends Node2D

export(float) var gearSpeed = 10.0
export(float) var linearSpeed = 1000.0
export(float) var radialSpeed = 2.0 * PI / 6.0
export(float) var health = 30.0
export(float) var tossForce = 400.0

export(PackedScene) var explodeFX = preload("res://game/bigExplosion.tscn")

enum eState { INTRO, POSITION, STANDBY, GRAB, THROW }
var state:int = eState.INTRO

var enterPosition:Vector2
var boss:Area2D
var moveToAngle:float
var standbyTimer:float
var grabbedEnemy:RigidBody2D
var hp:float

func _ready():
	boss = $ship
	hp = health
	var spawn_pos = Vector2(-1920 - 300, 0)
	var first_move = Vector2(-980, 0)
	var side = randi() % 4
	match side:
		0: # top
			rotation = deg2rad(-90)
		1: # left
			rotation = 0
		2: # bottom
			rotation = deg2rad(90)
		3: # right
			rotation = deg2rad(180)
	boss.position = spawn_pos
	enterPosition = first_move
	if not $sfx_intro.playing:
		$sfx_intro.play()

func _process(delta):
	var r = gearSpeed * delta
	boss.get_node("gear1").rotate(-r)
	boss.get_node("gear2").rotate(-r)
	boss.get_node("gear3").rotate(r)
	boss.get_node("gear4").rotate(r)

	match state:
		eState.INTRO:
			return state_intro(delta)
		eState.POSITION:
			return state_position(delta)
		eState.STANDBY:
			return state_standby(delta)
		eState.GRAB:
			return state_grab(delta)
		eState.THROW:
			return state_throw(delta)

# States
func state_intro(delta):
	if move_to(delta, enterPosition.x):
		yield(get_tree().create_timer(0.5), "timeout")
		if not $sfx_position.playing:
			$sfx_position.play()
		reposition()

func state_position(delta):
	if rotate_to(delta, moveToAngle):
		standby()

func state_standby(delta):
	standbyTimer -= delta
	if standbyTimer <= 0:
		reposition()

func state_grab(delta):
	if grabbedEnemy:
		grabbedEnemy.disable(true)
		grabbedEnemy.look_at(Global.core.global_position)
		grabbedEnemy.global_position = boss.global_position + Vector2(32, 0)
		yield(get_tree().create_timer(0.2), "timeout")
	state = eState.THROW

func state_throw(delta):
	if grabbedEnemy and grabbedEnemy.is_inside_tree():
		grabbedEnemy.disable(false)
		$sfx_toss.play()
		grabbedEnemy.apply_impulse(Vector2(0, 0), (Global.core.global_position - grabbedEnemy.global_position).normalized() * tossForce)
	state = eState.STANDBY

# actions

func reposition():
	moveToAngle = randf() * PI * 2.0
	if abs(moveToAngle - rotation) > deg2rad(180):
		moveToAngle -= deg2rad(360)
	state = eState.POSITION

func standby():
	if not $sfx_standby.playing:
		$sfx_standby.play()
	standbyTimer = 3.0 + (randf() *  6.0)
	state = eState.STANDBY
	print("Standby: " + str(standbyTimer))

func grab(enemy:RigidBody2D):
	grabbedEnemy = enemy
	grabbedEnemy.connect("sig_enemy_killed", self, "grabbed_enemy_killed")
	state = eState.GRAB

func get_damaged(enemy:RigidBody2D):
	enemy.explode()
	hp -= enemy.damage
	if hp <= 0:
		# die!
		$sfx_die.play()
		big_explode()
		queue_free()
	var c:Color = Color(1, 0.3, 0.3)
	boss.modulate = c.linear_interpolate(Color(1, 1, 1), hp/health)

func big_explode():
	var ex = explodeFX.instance()
	ex.global_position = global_position
	get_parent().add_child(ex)
	queue_free()

# Movement

# returns true when it arrives
func move_to(delta:float, posx:float):
	if boss.position.x < posx:
		boss.position.x += linearSpeed * delta
		if boss.position.x >= posx:
			boss.position.x = posx
			return true
	else:
		boss.position.x -= linearSpeed * delta
		if boss.position.x <= posx:
			boss.position.x = posx
			return true
	return false

func rotate_to(delta:float, angle:float):
	if angle > rotation:
		rotation += radialSpeed * delta
		if rotation >= angle:
			rotation = angle
			return true
	else:
		rotation -= radialSpeed * delta
		if rotation <= angle:
			rotation = angle
			return true
	return false


func _on_ship_body_entered(body:RigidBody2D):
	if body.is_in_group("enemy"):
		var core_to_body = (body.global_position - Global.core.global_position).normalized()
		var dir_body = body.linear_velocity.normalized()
		if abs(core_to_body.angle_to(dir_body)) <= deg2rad(60.0):
			get_damaged(body)
		elif state == eState.STANDBY or state == eState.POSITION:
			grab(body)

func grabbed_enemy_killed():
	grabbedEnemy = null
