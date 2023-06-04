extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emitting = true
	await get_tree().create_timer(lifetime / speed_scale).timeout
	queue_free()
