extends Area2D

var speed = 550

func _physics_process(delta):
	position += transform.x * speed * delta
	
	await get_tree().create_timer(0.8).timeout
	queue_free()
	
func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()
	
	if body.is_in_group("mobs"):
		body.take_damage(10)
		queue_free()
		
	if body.is_in_group("player"):
		body.take_damage(5)
		queue_free()
