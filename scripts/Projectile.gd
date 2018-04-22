extends KinematicBody2D

signal projectile_hit

export (int) var speed
var direction

const MOB_BIT = 1

func spawn(initial_velocity):
	direction = initial_velocity.normalized()

func _physics_process(delta):
	var collision_info = move_and_collide(direction*speed*delta)
	if collision_info:
		var collider = collision_info.collider
		var collider_layers = collision_info.collider.collision_layer
		# if it's a mob, grab the parent, because the collision object is not the root
		var object_collision
		if collider_layers & MOB_BIT:
			object_collision = collider.get_parent()
		elif collider_layers & collision_mask:
			object_collision = collider
		
		if object_collision and object_collision.has_method("projectile_hit"):
			object_collision.projectile_hit()
		
		emit_signal("projectile_hit")
		queue_free()

func _on_LifeTimer_timeout():
	queue_free()
