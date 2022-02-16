extends KinematicBody

var path = []
var path_index = 0
const move_speed = 8
onready var nav = get_parent()

onready var animation_tree = get_node("champion/AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_index = 0
		
func _physics_process(delta):
	if path_index < path.size():
		var move_vec = (path[path_index] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_index += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			animation_mode.travel("run")
	else:
		animation_mode.travel("idle")

func look(target_pos):
	look_at(target_pos, Vector3.UP)


