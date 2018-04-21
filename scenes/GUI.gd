extends CanvasLayer

var resources_available = 0
var resources_collected = 0

func add_resources_collected(count):
	resources_collected += count
	$HBoxContainer/Label.text = str("Resources ", resources_collected, " / ", resources_available)

func add_resources_available(count):
	resources_available += count
	$HBoxContainer/Label.text = str("Resources ", resources_collected, " / ", resources_available)