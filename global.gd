extends Node

var Letter = preload("res://letter/letter.tscn")

# The next inputted string. Once you make N mistakes, the string is reset.
# Otherwise, we try to match it to existing Letter instances.
var next_input = ""

# The maximum number of allowed mistakes per word
var max_mistakes = 3

# Used to see if there are new letters to spawn in
var timer = 0.0
var game_data_index = 0

# How long each "tick" of the game_data first column corresponds to, in seconds
var GAME_TIMER_FACTOR = 1

# Stores the game data
var game_data = [
	[0, -210, "hello"],
	[1, -70, "ludum"],
	[2, 70, "dare"],
	[3, 210, "game"]
]

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event = event as InputEventKey
		var key_typed = PackedByteArray([key_event.unicode]).get_string_from_utf8()
		
		next_input += key_typed
		
func check_game_data(delta):
	timer += delta
	
	if game_data_index >= game_data.size():
		return
	
	var next_entry = game_data[game_data_index]
	if next_entry[0] * GAME_TIMER_FACTOR <= timer:
		var letter = Letter.instantiate()
		letter.text = next_entry[2]
		letter.position.x = next_entry[1]
		get_node("/root/Game").add_child(letter)
		
		game_data_index += 1

func _process(delta):
	check_game_data(delta)
	
	# Can't do anything with no text input
	# TODO: Render letters with empty match...?
	if next_input.is_empty():
		return
	
	# So, we want to:
	# 1. Check if there's any letter for which the current input is valid
	#    (if there's too many mistakes, we reset it)
	# 2. Figure out if there's a letter who is done. If so, call it done.
	# 3. Render all the letters, to show the matched text.
	var has_valid_letter = false
	var has_completed_letter = false
	
	for letter in get_tree().get_nodes_in_group("Letter"):
		var measure = letter.measure_input(next_input)

		if measure[0] <= max_mistakes:
			has_valid_letter = true
			letter.render_text(measure[1], measure[0] > 0)
			
			# If the letter was completed, send it off! and
			# we will have to reset everything
			if letter.text.length() == measure[1]:
				has_completed_letter = true
				letter.complete()
				break
		else:
			# Clear letter's render
			letter.render_text(0, false)
		
		
	# If there's not a single valid letter, reset the typed text.
	# This is important for a few reasons:
	# 1. We don't *really* want an arbitrarily long string
	# 2. The first letter must always match exactly
	if not has_valid_letter:
		next_input = ""
		
	if has_completed_letter:
		next_input = ""
		for letter in get_tree().get_nodes_in_group("Letter"):
			letter.render_text(0, false)
	
