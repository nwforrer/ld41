extends Node

func _process(delta):
	if Input.is_action_just_pressed("add_mob"):
		pass
		
func _input(event):
	if event.is_action_pressed("add_mob"):
		print("Mouse click at: ", event.position)
		var mobScene = load("res://scenes/Tower.tscn")
		var instance = mobScene.instance()
		instance.position = event.position
		add_child(instance)