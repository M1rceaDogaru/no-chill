extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Die")

func _on_animation_finished(anim_name):
	get_parent().queue_free()
