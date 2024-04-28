extends Node

@onready var free_cam: FreeCam = $free_cam

var is_active : bool = false

func _ready() -> void:
	Globals.debug_mode_toggled.connect(on_debug_mode_toggled)
	pass


func on_debug_mode_toggled(debug_mode : bool):
	is_active = debug_mode
	if is_active:
		free_cam.enable()
	else:
		free_cam.disable()
	pass


func _process(delta: float) -> void:
	#var b = Globals.debug_mode_toggled.is_connected(on_debug_mode_toggled)
	#print("is connected: %s" % b)
	pass
