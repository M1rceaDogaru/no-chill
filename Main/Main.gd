extends Node2D

export var score_length = 10

export var pig_spawn_interval = 3.0
export var elf_spawn_interval = 10.0

export var difficulty_jump = 0.4
export var difficulty_limit = 1
export var difficulty_change_interval = 10

onready var time_since_last_pig = pig_spawn_interval
onready var time_since_last_elf = elf_spawn_interval
onready var time_since_last_difficulty_change = difficulty_change_interval

var pig = preload("res://Pig/Pig.tscn")
var elf = preload("res://Elf/Elf.tscn")

func _ready():
	Score.start_game()
	randomize()

func _process(delta):
	if time_since_last_pig > 0.0:
		time_since_last_pig -= delta
	else:
		spawn_enemy(pig)
		time_since_last_pig = pig_spawn_interval
		
	if time_since_last_elf > 0.0:
		time_since_last_elf -= delta
	else:
		spawn_enemy(elf)
		time_since_last_elf = elf_spawn_interval
		
	update_score_ui()
	increase_difficulty(delta)

func increase_difficulty(delta):
	time_since_last_difficulty_change -= delta
	if time_since_last_difficulty_change > 0.0:
		return
	
	time_since_last_difficulty_change = difficulty_change_interval
	pig_spawn_interval -= difficulty_jump
	if pig_spawn_interval < difficulty_limit:
		pig_spawn_interval = difficulty_limit
	elf_spawn_interval -= difficulty_jump
	if elf_spawn_interval < difficulty_limit:
		elf_spawn_interval = difficulty_limit
		
func spawn_enemy(type):
	var new_enemy = type.instance()
	var spawn_point_index = int(rand_range(0, $SpawnPoints.get_child_count()))
	var spawn_point = $SpawnPoints.get_child(spawn_point_index)
	new_enemy.position = spawn_point.position
	add_child(new_enemy)

func update_score_ui():
	var score = str(int(Score.current_score))
	score = "0".repeat(score_length - score.length()) + score
	$UI/Score.text = score
