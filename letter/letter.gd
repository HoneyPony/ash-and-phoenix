extends Node2D

@onready var text_display = $LetterDisplay/TextDisplay

var text = "preposterous"

var is_completed = false

var velocity_x = 0.0
var velocity_y = -300

var max_vel_y = -40

var disable_a = false

var is_letter2 = false # Whether to use the second variation
@export var letter2_frames: SpriteFrames
@export var letter2_font: Font

#func letter_shake():
#	var rng = Vector2.from_angle(randf_range(0, 6.28)) * randf_range(0, 8)
#	$LetterDisplay.position += (rng - $LetterDisplay.position) * 0.01

func _ready():
	text_display.text = "[center]" + text + "[/center]"
	
	#position.y = 400 + 100
	
	modulate.a = 0
	if is_letter2:
		$LetterDisplay/AnimatedSprite2D.sprite_frames = letter2_frames
		text_display.add_theme_font_override("normal_font", letter2_font)
		text_display.add_theme_font_size_override("normal_font_size", 78)
		text_display.position.y -= 10
		
	#position.x = randf_range(-40, 40)
	
func _process(delta):
	position.y += delta * velocity_y
	velocity_y += delta * 180 # decelerate
	velocity_y = min(velocity_y, max_vel_y) # can't go below -40
	if position.y > -300 or is_completed:
		modulate.a = min(modulate.a + delta * 0.7, 1.0)
	else:
		modulate.a = max(modulate.a - delta, 0.0)
	
	
	
	if is_completed:
		if abs(velocity_x) < 1:
			velocity_x = sign(position.x)
			if abs(position.x) < 1:
				velocity_x = 1
		velocity_x += sign(velocity_x) * 600 * delta
		position.x += velocity_x * delta
		
		if abs(position.x) > 270:
			remove_from_group("BlockingLetter")
		
		if abs(position.x) > 2000:
			queue_free()
	else:
		# DO NOT add back to Letter group after is_completed.
		if position.y <= 460:
			add_to_group("Letter")
		if position.y < -380:
			queue_free()

func render_text(correct: int, some_wrong: bool):
	text_display.text = "[center][color=#000]"
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
	
var measure_cache = [0, 0]

func measure_input(input: String):
	measure_cache = measure_input_uncached(input)
	return measure_cache

func measure_input_uncached(input: String):
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
