extends Camera2D

#func _input(event):
#	if event.is_action_pressed("add_mob"):
#		var clickLocation = get_local_mouse_position() 
#		var mobScene = load("res://scenes/Tower.tscn")
#		var instance = mobScene.instance()
#		instance.position = clickLocation
#		get_tree().get_root().get_node("Game").add_child(instance)