extends Area2D

var speed = 550
var bullet_damage = 10

@onready var sparks: PackedScene = preload("res://Scenes/bullet_sparks.tscn")

func _ready():
	pass

func _physics_process(delta):
	position += transform.x * speed * delta
	
func create_sparks():
	var instance = sparks.instantiate()
	instance.emitting = true
	instance.rotation = rotation
	instance.position = position + Vector2(8 ,0).rotated(rotation) 
	get_parent().add_child(instance)

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(bullet_damage)
		create_sparks()
		queue_free()
	
	if body.is_in_group("mobs"):
		body.take_damage(bullet_damage)
		create_sparks()
		queue_free()
		
	if body.is_in_group("player"):
		body.take_damage(bullet_damage)
		create_sparks()
		queue_free()
		
#	if body.is_in_group("blocks"):
#		var bullet_pos = position
#		body.destroy_block(bullet_pos)		
#		queue_free()
