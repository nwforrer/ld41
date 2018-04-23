extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed('ui_accept'):
		get_tree().change_scene('res://scenes/Game.tscn')
	elif Input.is_action_just_pressed('ui_cancel'):
		get_tree().quit()