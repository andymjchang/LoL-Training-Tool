extends Spatial

#camera movement base values
const move_margin = 10
const move_speed = 50
const ray_length = 1800
onready var cam = $camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().set_input_as_handled()
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func calc_move(m_pos, delta):
	var v_size = get_viewport().get_size()
	var move_vec = Vector3()
	if m_pos.x < move_margin:
		move_vec.x -= 1
	if m_pos.y < move_margin:
		move_vec.z -= 1
	if m_pos.x > v_size.x - move_margin:
		move_vec.x += 1
	if m_pos.y > v_size.y - move_margin:
		move_vec.z += 1
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * move_speed)
	global_transform.origin.x = clamp(global_transform.origin.x, -30, 30)
	global_transform.origin.z = clamp(global_transform.origin.z, -30, 30)
	
func move_unit(m_pos):
	var result = raycast_from_mouse(m_pos, 1)
	if result:
		get_tree().call_group("champion", "move_to", result.position)
		get_tree().call_group("champion", "look", result.position)
		
func _process(delta) -> void:
	#access position of the player object through parent node
	var rootNode = get_parent()
	var playerNode = rootNode.get_node("Navigation").get_node("player")
	
	var current_y = transform.origin.y
	#locked camera mode is at the player position + blue side offset
	#global_transform.origin = Vector3(playerNode.global_transform.origin.x + 1.175, current_y, playerNode.global_transform.origin.z + 9.175)
	
	var m_pos = get_viewport().get_mouse_position()
	calc_move(m_pos, delta)
	if Input.is_action_just_pressed("move_click"):
		move_unit(m_pos)
		
func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
