extends AudioStreamPlayer

func _process(delta):
	if playing != true:
		play()