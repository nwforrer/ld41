extends CanvasLayer

func _on_Game_resources_updated(resources_collected, resources_available):
	$ResourcesLabel.text = str("Resources ", resources_collected, " / ", resources_available)
