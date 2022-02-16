extends Spatial



func _ready():
	$AnimationPlayer.get_animation("ashe_skin17_run_base").set_loop(true)
	$AnimationPlayer.get_animation("Idle1_Base").set_loop(true)
	#$AnimationPlayer.set_current_animation("ashe_skin17_run_base")


