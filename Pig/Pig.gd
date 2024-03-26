extends KinematicBody2D

class_name Pig

export (int) var speed = 150
export (int) var health = 1
var target_node

var velocity = Vector2()
onready var current_health = health

var camera

var death = preload("res://Deaths/Pig_dead.tscn")

func _ready():
	target_node = get_parent().get_node("Player")
	camera = get_parent().get_node("Camera")
	$AnimationPlayer.play("Move")

func _physics_process(delta):
	var target = target_node.position
	$Sprite.flip_h = velocity.x < 0
	velocity = position.direction_to(target) * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("damage"):
			collision.collider.damage()
	
func damage():
	current_health -= 1
	camera.add_trauma(0.3)
	if current_health <= 0:
		die()
		Score.add(200)
		queue_free()
		
func die():
	var new_parent = Node2D.new()
	new_parent.position = position
	get_parent().add_child(new_parent)
	
	var new_death = death.instance()
	new_death.flip_h = $Sprite.flip_h
	new_parent.add_child(new_death)
	
