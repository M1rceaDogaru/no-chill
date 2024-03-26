extends Node

var game_in_progress = false

export var high_score : float = 0
export var current_score : float = 0

var score_per_second = 100

func _process(delta):
	if !game_in_progress:
		return
		
	current_score += score_per_second * delta
	
func add(score):
	if !game_in_progress:
		return
	current_score += score

func start_game():
	current_score = 0.0
	game_in_progress = true
	
func end_game():
	game_in_progress = false
	if high_score < current_score:
		high_score = current_score
