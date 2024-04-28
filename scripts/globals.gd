extends Node

#static var inst : Globals = self
#static var I : Globals : 
	#get : 
		##if !inst:
			##inst = new()
		#return inst

static var debug_mode : bool = false

signal debug_mode_toggled(is_active)

func _ready() -> void:
	print("globals ready")

func _process(delta: float) -> void:
	if Input.is_action_just_released("toggle_debug"):
		debug_mode = !debug_mode
		debug_mode_toggled.emit(debug_mode)
	
	pass
