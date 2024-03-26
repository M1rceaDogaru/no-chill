extends KinematicBody2D

export (int) var speed = 800

var lifetime = 5.0
var current_lifetime = 0.0

var velocity = Vector2()

var splash = preload("res://Fireball/Splash.tscn")

func _physics_process(delta):
	current_lifetime += delta
	if current_lifetime > lifetime:
		queue_free()
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider is Pig or collision.collider is Elf:
			collision.collider.damage()
			
		var new_splash = splash.instance()
		new_splash.position = position
		new_splash.rotation = velocity.angle()
		get_parent().add_child(new_splash)
		queue_free()
	
func set_direction(facing):
	if facing == 0:
		velocity.x += 1
	elif facing == 1:
		velocity.x -= 1
	elif facing == 2:
		velocity.y += 1
	elif facing == 3:
		velocity.y -= 1
		
	velocity = velocity.normalized() * speed
