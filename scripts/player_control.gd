extends KinematicBody

export(NodePath) var animationtree
export(NodePath) onready var camera = get_node(camera)

onready var _anim_tree = get_node(animationtree)
var gravity = Vector3.ZERO

var _last_pos
var _pressed : bool = false

func _physics_process(delta):
	var root_motion : Transform = _anim_tree.get_root_motion_transform()
	
	var v = root_motion.origin / delta
	if is_on_floor():
		gravity = Vector3.ZERO
	else:
		gravity += Vector3(0.0, -9.83, 0.0)
		
	v += gravity
	
	var dir : Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		dir.z += 1.0
	if Input.is_action_pressed("backward"):
		dir.z -= 1.0
	if Input.is_action_pressed("left"):
		dir.x += 1.0
	if Input.is_action_pressed("right"):
		dir.x -= 1.0
	
	if dir.length_squared() > 0.01:
		dir = dir.rotated(Vector3.UP, camera.setup.rotation.y)
		
		var player_heading_2d := Vector2(self.transform.basis.z.x, self.transform.basis.z.z)
		var desired_heading_2d := Vector2(dir.x, dir.z)
		
		var phi : float = desired_heading_2d.angle_to(player_heading_2d)
		phi = phi * delta * 3.0 # change settings to smoothen out character movement
		self.rotation.y += phi
		v = v.rotated(Vector3.UP, self.rotation.y)
		if Input.is_action_pressed("sprint"):
			_anim_tree["parameters/playback"].travel("Running")
		else:
			_anim_tree["parameters/playback"].travel("Walking")
	else:
		_anim_tree["parameters/playback"].travel("Idle")
		v = v.rotated(Vector3.UP, self.rotation.y)
	
	
	move_and_slide(v, Vector3.UP)
