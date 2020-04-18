extends Area2D

# spawner is able to pick a random CollisionShape2D/Circle from its children
# and pick a random point inside of CircleShape2D
# May extend to suppor capsule/rect if I needed since those involve rotation
# and this is a gamejam.

export(PackedScene) var enemy = preload("res://game/enemy.tscn")

class circle:
	var pos
	var rad
	func _init(p, r):
		self.pos = p
		self.rad = r
	# Selects a random point within the circle
	func random_point():
		var r = randf() * self.rad
		var t = randf() * PI * 2.0
		return Vector2(self.pos.x + (r * cos(t)), self.pos.y + (r * sin(t)))

var circles:Array = []

func _ready():
	for c in self.get_children():
		if c is CollisionShape2D and c.shape is CircleShape2D:
			circles.append(circle.new(c.position, c.shape.radius))
	randomize()
	$timer.start()

func spawn_enemy():
	assert(enemy)
	var ep = circles[randi() % len(circles)].random_point()
	var en = enemy.instance()
	en.position = ep
	get_parent().add_child(en)


func _on_timer_timeout():
	spawn_enemy()
