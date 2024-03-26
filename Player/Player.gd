extends KinematicBody2D

class_name Player

var snowball = preload("res://Snowball/Snowball.tscn")
var hit = preload("res://Fireball/Splash.tscn")

export (int) var speed = 400
export (int) var health = 3
export (float) var invincible_duration = 2.0

var facing = 0

var is_firing = false
var firing_speed = 0.3
var time_since_fire = 0.0

var invincibility_time = 0.0

onready var health_pool = get_parent().get_node("Health")
onready var camera = get_parent().get_node("Camera")
	
func move(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
		
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	check_invincibility(delta)
	fire()
	set_facing(velocity)
	animate(velocity)
	move_and_slide(velocity)
	draw()

func check_invincibility(delta):
	if invincibility_time < 0.0:
		return
	
	invincibility_time -= delta
	if invincibility_time <= 0.0:
		set_visiblity(1)

func set_facing(velocity):
	if is_firing:
		return
		
	if velocity.x > 0:
		facing = 0 # right
	elif velocity.x < 0:
		facing = 1 # left
	elif velocity.y > 0:
		facing = 2 # down
	elif velocity.y < 0:
		facing = 3 # up

func draw():
	if facing == 0:
		$Graphics/Side.flip_h = false
		$Graphics/Side.visible = true
		$Graphics/Up.visible = false
		$Graphics/Down.visible = false
	elif facing == 1:
		$Graphics/Side.flip_h = true
		$Graphics/Side.visible = true
		$Graphics/Up.visible = false
		$Graphics/Down.visible = false
	elif facing == 2:
		$Graphics/Side.flip_h = false
		$Graphics/Side.visible = false
		$Graphics/Up.visible = false
		$Graphics/Down.visible = true
	elif facing == 3:
		$Graphics/Side.flip_h = false
		$Graphics/Side.visible = false
		$Graphics/Up.visible = true
		$Graphics/Down.visible = false
		
func animate(velocity):
	if velocity.x == 0 and velocity.y == 0:
		$AnimationPlayer.current_animation = "Idle"
	else:
		$AnimationPlayer.current_animation = "Move"
			
func fire():
	is_firing = true
	if Input.is_action_pressed('fire_right'):
		facing = 0
	elif Input.is_action_pressed('fire_left'):
		facing = 1
	elif Input.is_action_pressed('fire_down'):
		facing = 2
	elif Input.is_action_pressed('fire_up'):
		facing = 3
	else:
		is_firing = false
		
	if is_firing and time_since_fire <= 0.0:
		time_since_fire = firing_speed
		var new_snowball = snowball.instance()
		new_snowball.position = position
		new_snowball.set_direction(facing)
		get_parent().add_child(new_snowball)
		play_throw()

func _physics_process(delta):
	if time_since_fire > 0.0:
		time_since_fire -= delta
		
	move(delta)

func damage():
	if invincibility_time > 0.0:
		return
		
	health -= 1
	check_end()
	invincibility_time = invincible_duration
	set_visiblity(0.5)
	update_health_pool()
	camera.add_trauma(0.3)
	
	var new_splah = hit.instance()
	new_splah.position = position
	new_splah.rotation = rotation
	get_parent().add_child(new_splah)
	
func update_health_pool():
	var count = 1
	for node in health_pool.get_children():
		node.visible = count <= health
		count += 1
		
func set_visiblity(value):
	$Graphics/Down.self_modulate.a = value
	$Graphics/Side.self_modulate.a = value
	$Graphics/Up.self_modulate.a = value
	
func play_throw():
	$Throw.play()
	if facing == 0 or facing == 1:
		$Graphics/Side.frame = 0
		$Graphics/Side.play("throw")
	elif facing == 2:
		$Graphics/Down.frame = 0
		$Graphics/Down.play("throw")
	elif facing == 3:
		$Graphics/Up.frame = 0
		$Graphics/Up.play("throw")

func check_end():
	if health <= 0:
		Score.end_game()
		get_tree().change_scene("res://End/End.tscn")
