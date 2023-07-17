extends StaticBody2D

var HP = 50

signal block_destroyed()

@onready var sprite = $Sprite2D

func _ready():
	$GPUParticles2D.emitting = false


func _process(delta):
	block_explode()


func hit(dmg):
	sprite.use_parent_material = true
	HP -= dmg
	await get_tree().create_timer(0.1).timeout
	sprite.use_parent_material = false


func block_explode():
	if HP <= 0:
		particles()
		await get_tree().create_timer(0.4).timeout
		get_parent().set_cell(0, get_parent().local_to_map(position), 0, Vector2i(3,0) )
		queue_free()


func particles():
	$GPUParticles2D.emitting = true

