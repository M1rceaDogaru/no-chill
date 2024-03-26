extends KinematicBody2D

class_name Elf

export (int) var speed = 100
export (int) var health = 3
export (float) var fire_interval = 1.5

var target_node
var position_node

var velocity = Vector2()
onready var current_health = health
onready var time_to_fire = fire_interval

var fireball = preload("res://Fireball/Fireball.tscn")
var death = preload("res://Deaths/Elf_dead.tscn")

var camera

func _ready():
	target_node = get_parent().get_node("Player")
	camera = get_parent().get_node("Camera")
	$AnimationPlayer.play("Move")

func _physics_process(delta):
	check_fire(delta)
	check_position()
	$Sprite.flip_h = target_node.position.x < position.x
	velocity = position.direction_to(position_node.position) * speed
	velocity = move_and_slide(velocity)
	
func damage():
	current_health -= 1
	camera.add_trauma(0.3)
	if current_health <= 0:
		camera.add_trauma(0.2)
		die()
		Score.add(500)
		queue_free()
		
func check_position():
	if !position_node or (abs(position.x - position_node.position.x) < 3 and abs(position.y - position_node.position.y) < 3):
		set_new_position()
		
func set_new_position():
	var positions = get_parent().get_node("Positions")
	var new_position_index = int(rand_range(0, positions.get_child_count()))
	position_node = positions.get_child(new_position_index)

func check_fire(delta):
	time_to_fire -= delta
	if time_to_fire < 0.0:
		fire()
		time_to_fire = fire_interval
	
func fire():
	var new_fireball = fireball.instance()
	new_fireball.position = position
	new_fireball.send(position.direction_to(target_node.position))
	get_parent().add_child(new_fireball)
	$Sprite.frame = 0
	$Sprite.play("Fire")
	
func die():
	var new_parent = Node2D.new()
	new_parent.position = position
	get_parent().add_child(new_parent)
	
	var new_death = death.instance()
	new_death.flip_h = $Sprite.flip_h
	new_parent.add_child(new_death)
