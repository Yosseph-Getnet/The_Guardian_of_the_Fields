func _soar(delta):
	path_follow.progress_ratio += path_follow_speed * delta
	global_position = path_follow.global_position
