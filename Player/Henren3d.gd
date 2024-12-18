extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	var record_idx = AudioServer.get_bus_index("Record")
	spectrum = AudioServer.get_bus_effect_instance(record_idx, 0)
	
	#if not is_multiplayer_authority():
		#return
	
	position = Vector3(0, 5, 0)

var spectrum
var volume
func play_bigger():
	var tween = create_tween()
	tween.tween_property($CharSprite3D, "scale", 1.5 * $CharSprite3D.scale, 0.5).from_current()
func _physics_process(delta):
	volume = spectrum.get_magnitude_for_frequency_range(500, 15000).length()
	volume = clamp(volume * 10, 0.1, volume * 10)
	print(volume)
	if volume > 0.2:
		$AudioStreamPlayer.play()
		play_bigger()
		#turn_red()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



var can_upstair: bool = false
func _on_area_3d_body_entered(body):
	if body is Tower:
		$UpIcon.show()
		can_upstair = true


func _on_area_3d_body_exited(body):
	if body is Tower:
		$UpIcon.hide()
		can_upstair = false

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and can_upstair == true:
		position.y += 6
		
	if Input.is_action_just_pressed("ui_cancel"):
		var authority = get_multiplayer().get_unique_id()
		print(authority)
		print("authority")
