extends Node2D

export (PackedScene) var Pickup

func _ready():
	randomize()

func clear_pickups():
	get_tree().call_group("resources", "queue_free")
	
func spawn_pickups(count):
	for pickup_index in count:
		$PickupPath/PickupSpawnLocation.set_offset(randi())
		var pickup = Pickup.instance()
		pickup.add_to_group("resources")
		pickup.position = $PickupPath/PickupSpawnLocation.position
		add_child(pickup)