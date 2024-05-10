class_name FreeCam
extends Camera3D

@export var start_pos : Node3D

@export var acceleration = 50.0
@export var moveSpeed = 8.0
@export var mouseSpeed = 300.0
@export var controllerSpeed = 4.5
@export var controllerDeadZone = 0.04

var velocity = Vector3.ZERO
var lookAngles = Vector2.ZERO
var controllerLook = Vector2.ZERO

var is_enabled = true
var cashed_cam : Camera3D

func enable():
	is_enabled = true
	cashed_cam = get_viewport().get_camera_3d()
	cashed_cam.current = false
	(self as Camera3D).current = true
	pass


func disable():
	is_enabled = false
	(self as Camera3D).current = false
	cashed_cam.current = true
	pass


func _ready() -> void:
	if start_pos:
		self.position = start_pos.position
	pass


func _process(delta):  
	if !is_enabled: return
	
	if controllerLook.length_squared() > controllerDeadZone:
		lookAngles -= controllerLook * delta * controllerSpeed
	
	lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
	set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))
	
	var dir = updateDirection()
	if dir.length_squared() > 0:
		velocity += dir * acceleration * delta
	else:
		velocity += velocity.direction_to(Vector3.ZERO) * acceleration * delta
	if velocity.length() < 0.0005:
		velocity = Vector3.ZERO
	if velocity.length() > moveSpeed:
		velocity = velocity.normalized() * moveSpeed
	if Input.is_action_just_pressed("shift"):
		moveSpeed *= 2
	if Input.is_action_just_released("shift"):
		moveSpeed /= 2
	translate(velocity * delta)
  
  
	# Give the player's mouse back when ESC is pressed.
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func updateDirection():
	# Get the direction to move the camera from the input.
	var dir = Vector3()
	if Input.is_action_pressed("ui_up"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("ui_down"):
		dir += Vector3.BACK
	if Input.is_action_pressed("ui_left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("ui_right"):
		dir += Vector3.RIGHT
	
	return dir.normalized()


func _input(event):
	if !is_enabled: return
	
	# Update the look angles when the mouse moves.
	if event is InputEventMouseMotion:
		lookAngles -= event.relative / mouseSpeed
	
  ## Update the controllerLook when any axis on the controller moves.
	#if event is InputEventJoypadMotion:
		#if event.axis == JOY_AXIS_2:
			#controllerLook.x = event.axis_value
		#if event.axis == JOY_AXIS_3:
			#controllerLook.y = event.axis_value
	  
  # Steal the mouse from the player when they interact with the window using a
  # mouse button.      
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
