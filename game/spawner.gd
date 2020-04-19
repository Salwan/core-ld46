extends Area2D

# spawner is able to pick a random CollisionShape2D/Circle from its children
# and pick a random point inside of CircleShape2D
# May extend to suppor capsule/rect if I needed since those involve rotation
# and this is a gamejam.

export(PackedScene) var enemySquare = preload("res://game/enemySquare.tscn")
export(PackedScene) var enemyTriangle = preload("res://game/enemyTriangle.tscn")
export(PackedScene) var enemyCircle = preload("res://game/enemyCircle.tscn")
export(PackedScene) var powerupHeal = preload("res://game/powerupHealth.tscn")

var spawnTimers:Array = []
var spawnParent:Node2D = null

class circle:
	var pos
	var rad
	func _init(p, r):
		self.pos = p
		self.rad = r
	# Selects a random point within the circle
	func random_point():
		return Global.random_point_in_circle(self.pos, self.rad)

var circles:Array = []

func _ready():
	for c in self.get_children():
		if c is CollisionShape2D and c.shape is CircleShape2D:
			circles.append(circle.new(c.position, c.shape.radius))
	randomize()
	$timer.start()
	get_parent().connect("sig_init_game", self, "init_game")

func init_game():
	kill_all()
	spawnParent = Node2D.new()
	spawnParent.name = "spawnParent"
	spawnParent.position = Vector2(0, 0)
	get_parent().add_child(spawnParent)
	for e in Global.currentLevel.enemies:
		var tick_every:float = 1.0
		if e.population == LevelData.ePopulation.RATE:
			tick_every = e.rate
		else:
			tick_every = (e.end - e.start) / float(e.total)
		# spawn timer
		var t:Timer = Timer.new()
		t.wait_time = tick_every
		add_child(t)
		t.connect("timeout", self, "spawn_enemy", [ e ])
		spawnTimers.append(t)
		# start spawn timer
		var st:Timer = Timer.new()
		st.wait_time = e.start
		st.one_shot = true
		add_child(st)
		st.connect("timeout", self, "start_timer", [ t, st ])
		spawnTimers.append(st)
		st.start()
		# timer that kills spawn timer when its job is done
		var tt:Timer = Timer.new()
		tt.wait_time = e.end
		tt.one_shot = true
		add_child(tt)
		tt.connect("timeout", self, "kill_timer", [ t, tt ])
		spawnTimers.append(tt)
		tt.start()

func spawn_enemy(enemy):
	assert(enemy)
	if enemy.id == "square" or enemy.id == "triangle" or enemy.id == "circle" or enemy.id == "heal":
		var ep = circles[randi() % len(circles)].random_point()
		var en = null
		match enemy.id:
			"square":
				en = enemySquare.instance()
			"triangle":
				en = enemyTriangle.instance()
			"circle":
				en = enemyCircle.instance()
			"heal":
				en = powerupHeal.instance()
		en.position = ep
		spawnParent.add_child(en)

# 1 second tick for any spawner tasks
func _on_timer_timeout():
	pass

func start_timer(timer:Timer, caller:Timer):
	timer.start()
	spawnTimers.erase(caller)
	caller.stop()
	caller.queue_free()

func kill_timer(timer:Timer, caller:Timer):
	print("Timer killed")
	timer.stop()
	spawnTimers.erase(timer)
	spawnTimers.erase(caller)
	timer.queue_free()
	caller.queue_free()

func kill_all():
	for t in spawnTimers:
		t.stop()
		t.queue_free()
	spawnTimers = []
	if spawnParent and spawnParent.is_inside_tree():
		spawnParent.queue_free()
