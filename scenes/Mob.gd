extends Sprite

func _process(delta):
	get_parent().set_offset(get_parent().get_offset() + (50*delta))