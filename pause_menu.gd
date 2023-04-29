extends ColorRect

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		
	visible = get_tree().paused



func _on_resume_button_pressed():
	get_tree().paused = false
