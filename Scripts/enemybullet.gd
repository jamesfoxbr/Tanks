extends Area2D

var speed = 250


func _physics_process(delta):
	position += transform.x * speed * delta
	
	await get_tree().create_timer(3).timeout
	queue_free()
	

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()
	
	if body.is_in_group("player"):
		body.take_damage(10)
		queue_free()
	


