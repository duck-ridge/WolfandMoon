extends Node

var spectrum
var volume

func _ready():
	var record_idx = AudioServer.get_bus_index("Record")
	spectrum = AudioServer.get_bus_effect_instance(record_idx, 0)

	
func _physics_process(delta):
	# monitor the frequency
	volume = spectrum.get_magnitude_for_frequency_range(500, 15000).length()
	volume = clamp(volume * 10, 0.1, volume * 10)
