extends Area2D

var speed = 550


func _physics_process(delta):
	position += transform.x * speed * delta
	
	await get_tree().create_timer(0.8).timeout
	queue_free()
	
#	if not get_node("OnScreen").is_on_screen():
#		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()
