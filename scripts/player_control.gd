extends KinematicBody

export(NodePath) var animationtree

onready var _anim_tree = get_node(animationtree)
var gravity = Vector3.ZERO


func _physics_process(delta):
	var root_motion : Transform = _anim_tree.get_root_motion_transform()
	
	var v = root_motion.origin / delta
	if is_on_floor():
		gravity = Vector3.ZERO
	else:
		gravity += Vector3(0.0, -9.83, 0.0)
		
	v += gravity
	
	if Input.is_action_pressed("ui_select"):
		_anim_tree["parameters/playback"].travel("Running")
	else:
		_anim_tree["parameters/playback"].travel("Idle")
		
	move_and_slide(v, Vector3.UP)
