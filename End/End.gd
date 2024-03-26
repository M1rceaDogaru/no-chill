extends Node2D

func _ready():
	$Score.text = "Score: " + str(int(Score.current_score))
	$High.text = "High: " + str(int(Score.high_score))

func _on_TextureButton_pressed():
	get_tree().change_scene("res://Main/Main.tscn")
