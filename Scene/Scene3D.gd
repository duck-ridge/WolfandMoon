extends Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	#var record_idx = AudioServer.get_bus_index("Record")
	#spectrum = AudioServer.get_bus_effect_instance(record_idx, 0)
	pass
func _process(delta):
	pass
	
func _physics_process(delta):
	#volume = spectrum.get_magnitude_for_frequency_range(500, 15000).length()
	#volume = clamp(volume * 10, 0.1, volume * 10)
	#if volume > 0.2:
		#$CharacterBody3D/AudioStreamPlayer.play()
		#turn_red()
	pass
			
func turn_red():
	var tween = create_tween()
	tween.tween_property($DirectionalLight3D, "light_color", $DirectionalLight3D.light_color - Color(0, 0.1, 0.1, 0), 0.5).from_current()
	
	
func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		print("WOLF!")
		pass

var peer = ENetMultiplayerPeer.new()
@onready var Players = $Players
@onready var PLAYER = preload("res://Player/Henren3d.tscn")

func _on_create_pressed():
	var error = peer.create_server(7788)
	if error != OK:
		print("failed")
		return
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	add_player(multiplayer.get_unique_id())
	
func add_player(id: int):
	print("add_player")
	print(id)
	var player = PLAYER.instantiate()
	
	player.name = str(id)
	print(player.name)
	print("print(player.name)")
	Players.add_child(player)

func _on_peer_connected(id: int):
	print("player connected, ID: " + str(id))

	add_player(id)
	pass
	
	
func _on_join_pressed():
	peer.create_client("127.0.0.1", 7788)
	multiplayer.multiplayer_peer = peer
