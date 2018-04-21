extends PathFollow2D

export (int) var speed

func _process(delta):
	set_offset(get_offset() + (speed*delta))
