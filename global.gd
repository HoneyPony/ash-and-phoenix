extends Node

# The next inputted string. Once you make N mistakes, the string is reset.
# Otherwise, we try to match it to existing Letter instances.
var next_input = ""

# The maximum number of allowed mistakes per word
var max_mistakes = 3

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event = event as InputEventKey
		var key_typed = PackedByteArray([key_event.unicode]).get_string_from_utf8()
		
		next_input += key_typed

func _process(delta):
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
	for letter in get_tree().get_nodes_in_group("Letter"):
		var measure = letter.measure_input(next_input)
		print(measure, " ", next_input)
		if measure[0] <= max_mistakes:
			has_valid_letter = true
		
		letter.render_text(measure[1])
	
