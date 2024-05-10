extends VehicleBody3D
class_name BaseCar

@export var debug : bool = true
@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
@export var max_engine_force_value = 300

var fwd_mps : float
var speed: float

@onready var grnd_det: RayCast3D = $GroundDetector
@onready var sound_player: AudioStreamPlayer3D = $"../Off"
var min_pitch_scale:float = 0.73
var max_pitch_scale: float = 1.7

func _ready():
	#%CarResetter.init()
	pass

func _physics_process(delta):
	if (debug):
		gravity_scale = 0
		if Input.is_action_pressed("forward"):
			position = position.move_toward(position + global_transform.basis.z, 200 * delta)
		if Input.is_action_pressed("backward"):
			position = position.move_toward(position - global_transform.basis.z, 100 * delta)
		var turn = Input.get_action_strength("left") - Input.get_action_strength("right")
		rotate(Vector3.UP, turn * delta)
		DebugDraw3D.draw_line(position, position + 100 * Vector3.DOWN, Color.DARK_RED)
	else:
		gravity_scale = 1
		speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
		fwd_mps = transform.basis.x.x
		traction(speed)
		process_accel(delta)
		process_steer(delta)
		#process_brake(delta)
		#%Hud/speed.text=str(round(speed*3.8))+"  KMPH"
	process_flip_over()
	process_engine_sound(delta)

func traction(speed):
	apply_central_force(Vector3.DOWN*speed)

func process_accel(delta):	
	if Input.is_action_pressed("forward"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = clamp(engine_force_value * 10 / speed, 0, max_engine_force_value)
			else:
				engine_force = engine_force_value
		return
	
	if Input.is_action_pressed("backward"):
	# Increase engine force at low speeds to make the initial acceleration faster.
		if speed < 20 and speed != 0:
			engine_force = -clamp(engine_force_value * 3 / speed, 0, max_engine_force_value)
		else:
			engine_force = -engine_force_value
		return
	
	engine_force = 0
	brake = 0	

func process_steer(delta):
	steer_target = Input.get_action_strength("left") - Input.get_action_strength("right")
	steer_target *= STEER_LIMIT
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

func process_brake(delta):
	if Input.is_action_pressed("ui_select"):
		brake=0.5
		$wheel_rear_left.wheel_friction_slip=2
		$wheel_rear_right.wheel_friction_slip=2
	else:
		$wheel_rear_left.wheel_friction_slip=2.9
		$wheel_rear_right.wheel_friction_slip=2.9

var vectr = Vector3(0, 0, 1)
func process_flip_over():
	#rotate_z(0.01)
	#raycast from bottom
	if speed < 0.1:
		var coll = grnd_det.get_collider()
		#print(coll)
		if not coll and engine_force > 0:
			vectr *= 1.1
			apply_torque_impulse(vectr)

func process_engine_sound(dt : float):
	var diapasone = max_pitch_scale - min_pitch_scale
	#eng   p
	#1000  diapasone
	var next = (engine_force / 1000 + 1) * diapasone
	#sound_player.pitch_scale = (engine_force / 1000 + 1) * diapasone
	sound_player.pitch_scale = move_toward(sound_player.pitch_scale, (engine_force / 1000 + 1) * diapasone, dt)
	pass
