extends Area2D

var selected_mob

func _process(delta):
	if selected_mob != null and not overlaps_body(selected_mob):
		selected_mob = null

func _on_Tower_body_entered(body):
	if selected_mob == null:
		selected_mob = body


func _on_FireTimer_timeout():
	if selected_mob == null:
		return
	
	var vector_to_mob = selected_mob.global_position - global_position
	var projectile = load("res://scenes/Projectile.tscn").instance()
	projectile.spawn(vector_to_mob.normalized())
	add_child(projectile)
