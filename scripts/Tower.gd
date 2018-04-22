extends Area2D

var active_bodies = []
var can_fire = false

func _process(delta):
	if can_fire and active_bodies.size() > 0:
		var selected_mob = active_bodies[0]
		var vector_to_mob = selected_mob.global_position - global_position
		var projectile = load("res://scenes/Projectile.tscn").instance()
		projectile.spawn(vector_to_mob.normalized())
		projectile.connect("projectile_hit", get_parent(), "on_projectile_hit")
		add_child(projectile)
		
		$FireTimer.start()
		can_fire = false

func _on_Tower_body_entered(body):
	if body.collision_layer & collision_mask:
		active_bodies.append(body)

func _on_Tower_body_exited(body):
	var body_index = active_bodies.find(body)
	if body_index >= 0:
		active_bodies.remove(body_index)

func _on_FireTimer_timeout():
	$FireTimer.stop()
	can_fire = true