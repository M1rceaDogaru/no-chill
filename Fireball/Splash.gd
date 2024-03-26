extends CPUParticles2D

export (float) var life = 1.0

func _ready():
	emitting = true

func _physics_process(delta):
	life -= delta
	if life < 0.0:
		queue_free()
