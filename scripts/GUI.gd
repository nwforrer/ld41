extends CanvasLayer

var mob_boosts = []

var winning = false

func _ready():
	set_resources_text(0, 0)
	
	$MobBoostsLabel/Health.hide()
	$MobBoostsLabel/Speed.hide()
	$MobBoostsLabel/Spawn.hide()
	
	$Spawning.hide()
	$Winning.hide()
	$Countdown.hide()

func _on_Game_resources_updated(resources_collected, resources_needed):
	set_resources_text(resources_collected, resources_needed)

func set_resources_text(resources_collected, resources_needed):
	$ResourcesLabel.text = str("Resources ", resources_collected, " / ", resources_needed)
	
func add_mob_boost(boost):
	if boost == 'health':
		$MobBoostsLabel/Health.show()
	elif boost == 'spawn':
		$MobBoostsLabel/Spawn.show()
	elif boost == 'speed':
		$MobBoostsLabel/Speed.show()

func win_countdown(time):
	winning = true
	var display_time = round(time)
	$Winning.show()
	$Countdown.text = str(display_time)
	$Countdown.show()

func countdown(time, spawning):
	if winning:
		$Spawning.hide()
	else:
		var display_time = round(time)
		if display_time == 0:
			$Countdown.hide()
			$Spawning.hide()
		else:
			if spawning:
				$Spawning.show()
			$Countdown.text = str(display_time)
			$Countdown.show()