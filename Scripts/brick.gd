extends StaticBody2D

var HP = 50

func _ready():
	$GPUParticles2D.emitting = false

func _process(delta):
	pass

func hit(dmg):
	modulate = Color.PALE_VIOLET_RED
	HP -= dmg
	await get_tree().create_timer(0.4).timeout
	modulate = Color.WHITE
	if HP <= 0:
		particles()
		await get_tree().create_timer(0.4).timeout
		queue_free()

func particles():
	$GPUParticles2D.emitting = true
