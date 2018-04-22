extends CanvasLayer

var mob_boosts = []

func _ready():
	set_resources_text(0, 0)

func _on_Game_resources_updated(resources_collected, resources_available):
	set_resources_text(resources_collected, resources_available)

func set_resources_text(resources_collected, resources_available):
	$ResourcesLabel.text = str("Resources ", resources_collected, " / ", resources_available)
	
func add_mob_boost(boost):
	var label = Label.new()
	label.text = boost
	
	var prev
	if mob_boosts.size() == 0:
		prev = $MobBoostsLabel
	else:
		prev = mob_boosts.back()
	label.rect_position = Vector2(prev.rect_position.x, prev.rect_position.y + prev.rect_size.y + 10)
	
	add_child(label)
	mob_boosts.append(label)

func countdown(time):
	var display_time = round(time)
	if display_time == 0:
		$Countdown.hide()
	else:
		$Countdown.text = str(display_time)
		$Countdown.show()