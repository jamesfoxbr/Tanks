extends StaticBody2D

var HP = 50

@onready var sprite = $Sprite2D

func _ready():
	$GPUParticles2D.emitting = false

func _process(delta):
	pass

func hit(dmg):
	sprite.use_parent_material = true
	HP -= dmg
	await get_tree().create_timer(0.1).timeout
	sprite.use_parent_material = false
	if HP <= 0:
		particles()
		await get_tree().create_timer(0.4).timeout
		queue_free()

func particles():
	$GPUParticles2D.emitting = true

