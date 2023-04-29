extends Node2D

@onready var text_display = $LetterDisplay/TextDisplay

var text = "preposterous"

var is_completed = false

func _ready():
	text_display.text = "[center]" + text + "[/center]"
	
	position.y = 400 + 100
	#position.x = randf_range(-40, 40)
	
func _process(delta):
	position.y -= delta * 80
	
	if is_completed:
		if abs(position.x) < 1:
			position.x = 1
		position.x *= 1.02
		
		if abs(position.x) > 2000:
			queue_free()
	else:
		# DO NOT add back to Letter group after is_completed.
		if position.y <= 460:
			add_to_group("Letter")

func render_text(correct: int, some_wrong: bool):
	text_display.text = "[center][color=green]"
	for i in range(0, correct):
		text_display.text += text[i]
	text_display.text += "[/color]"
	
	var no_status_index = correct
	
	if some_wrong:
		var index = correct
		if index < text.length():
			text_display.text += "[color=red]" + text[index] + "[/color]"
			no_status_index += 1
			
	for i in range(no_status_index, text.length()):
		text_display.text += text[i]
	text_display.text += "[/center]"
	

func measure_input(input: String):
	# Idea: 
	# If the first character does not match at all, then it plainly
	# does not match.
	#
	# Otherwise, we count any match that is in the same order as a match.
	# But. We also count how many non-matches we encountered. Once this
	# number reaches some max cap, we decide that it's not valid.
	#
	# Return a tuple of [mismatched, matched]
	
	# Fail safe
	if text.is_empty():
		print("Warning: Empty Letter spawned in")
		return [0, 0]
		
	# If the input is empty, then there are no mismatches, and its incomplete
	if input.is_empty():
		print("Warning: empty input measured") # For now... IDK if this should ever happen
		return [0, 0]
	
	if input[0] != text[0]:
		# Return a total mismatch
		return [GS.max_mistakes + 1, 0]
		
	var	input_idx = 1
	for i in range(1, text.length()):
		if input_idx >= input.length():
			# Once we reach the input length, we are done.
			return [0, i]
		
		var next_char = text[i]
		
		if input[input_idx] == next_char:
			# This input character matches! Increment the input_idx
			# to move past it.
			# 
			# And, if we have matched all the characters -- if this is the
			# last character in the string 
			
			input_idx += 1
		else:
			# Start counting mistakes.
			# Once we reach max mistakes in all words, the GS will end our
			# run.
			
			# However, if we encounter the correct letter without hitting too
			# many mistakes, then we consider the word OK.
			
			var mistakes = 0
			while input[input_idx] != next_char:
				mistakes += 1
				if mistakes > GS.max_mistakes:
					return [mistakes, i]
				
				input_idx += 1 # Move past next mistaken char
				if input_idx >= input.length():
					return [mistakes, i]
					
			# Ok, we made it here. That means we found the char before hitting
			# too many mistakes. So, it's actually fine. Move past the correct
			# char.
			input_idx += 1
		
	# Got through every character. We're done.
	return [0, text.length()]


func complete():
	# Don't let the GS see this letter anymore.
	remove_from_group("Letter")
	
	# May not be needed anymore
	is_completed = true
	$AnimationPlayer.play("Complete")
