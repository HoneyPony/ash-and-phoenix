extends Node2D

@onready var text_display = $TextDisplay

var text = "preposterous"

func _ready():
	text_display.text = "[center]" + text + "[/center]"

func render_text(correct: int):
	text_display.text = "[center][color=green]"
	for i in range(0, correct):
		text_display.text += text[i]
	text_display.text += "[/color]"
	for i in range(correct, text.length()):
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
	# Return a tuple of [mismatched, matched, has completed word]
	
	# Fail safe
	if text.is_empty():
		print("Warning: Empty Letter spawned in")
		return [0, 0, true]
		
	# If the input is empty, then there are no mismatches, and its incomplete
	if input.is_empty():
		print("Warning: empty input measured") # For now... IDK if this should ever happen
		return [0, 0, false]
	
	if input[0] != text[0]:
		# Return a total mismatch
		return [GS.max_mistakes + 1, 0, false]
		
	var mistakes = 0
	var	input_idx = 1
	for i in range(1, text.length()):
		if input_idx >= input.length():
			# Once we reach the input length, we are done.
			return [mistakes, i, false]
		
		var next_char = text[i]
		
		if input[input_idx] == next_char:
			# This input character matches! Increment the input_idx
			# to move past it.
			# 
			# And, if we have matched all the characters -- if this is the
			# last character in the string -- then we are done, return true.
			
			input_idx += 1
			if i == text.length():
				return [mistakes, i, true]
		else:
			# If we don't immediately match, that's a mistake.
			mistakes += 1
			
			# Early exit condition
			#if mistakes > GS.max_mistakes:
			#	return [mistakes, i, false]
				
			input_idx += 1 # Move past the mistaken character
				
			# Okay, now try to find the character in the input.
			while input_idx < input.length():
				if input[input_idx] == next_char:
					break
				
				input_idx += 1 # Increment must happen right before loop check
				
			if input_idx >= input.length():
				return [mistakes, i, false]
		
	# Hmm... idk
	return [mistakes, text.length() - mistakes, false]
