extends KinematicBody2D

export (int) var speed = 300

var lifetime = 5.0
var current_lifetime = 0.0

var velocity = Vector2()

func _physics_process(delta):
	current_lifetime += delta
	if current_lifetime > lifetime:
		queue_free()
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("damage"):
			collision.collider.damage()
		queue_free()

func send(direction):
	velocity = direction * speed
	rotation = velocity.angle()
