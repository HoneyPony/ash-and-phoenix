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

# Used to keep track of the current character "speaking."
# this is helpful because we usually have long runs of the same character,
# and it's easier to just change them occasionally.
var next_letter_is_phoenix = false

# How long each "tick" of the game_data first column corresponds to, in seconds
var GAME_TIMER_FACTOR = 1

class Word:
	var delay
	var text 
	var xpos
	var yoffset

	func _init(_text, _delay, _xpos, _yoffset):
		delay = _delay
		text = _text
		xpos = _xpos
		yoffset = _yoffset

class LetterChange:
	var next_letter
	func _init(_next_letter):
		next_letter = _next_letter
		
class WaitForWords:
	func _init():
		pass
		
func CHANGE_ASH():
	return LetterChange.new(false)
func CHANGE_PHOENIX():
	return LetterChange.new(true)
func WORD(text, delay, xpos, yoffset = 0):
	return Word.new(text, delay, xpos, yoffset)
func WAIT():
	return WaitForWords.new()


# Stores the game data
var game_data_1 = [
	CHANGE_ASH(),
	WORD("dear", 0, -70),
	WORD("phoenix", 0.4, 70),
	
	WAIT(),
	WORD("do", 0, -140),
	WORD("you", 0.4, 0),
	WORD("remember", 0.8, 140),
	WORD("our", 1.2, -140, 60),
	WORD("time", 1.6, 0, 60),
	WORD("capsule?", 2.0, 140, 60),
	
	WAIT(),
	WORD("it", 0, -210),
	WORD("was", 0.4, -70),
	WORD("finally", 0.8, 70),
	WORD("time", 1.2, 210),
	WORD("to", 1.6, -140, 60),
	WORD("open", 2.0, 0, 80),
	WORD("it", 2.4, 140, 100),
	WORD("not", 3.6, -210, 120),
	WORD("too", 3.8, -70, 140),
	WORD("long", 4.0, 70, 180),
	WORD("ago", 4.2, 210, 200),]
	
var game_data = [
	WAIT(),
	WORD("i", 0, -210),
	WORD("found", 0.4, -70),
	WORD("this", 0.8, 70),
	WORD("stationery", 1.2, 210),
	WORD("inside", 1.6, -30, 80),
	WORD("it", 2.0, 30, 200),
	
	WAIT(),
	WORD("i", 0, -70),
	WORD("remembered", 0.2, 70),
	WORD("my", 0.8, 210),
	WORD("promise", 1.2, -210, 60),
	WORD("to", 1.6, -70, 60),
	WORD("write", 2.0, 70, 60),
	WORD("you", 2.4, 210, 60),
	
	WORD("a", 5.0, -70, 60),
	WORD("letter", 5.4, 70, 60),
	
	WORD("on", 6.4, -210, 80),
	WORD("this", 6.8, -70, 80),
	WORD("ancient", 7.2, 70, 80),
	WORD("paper.", 7.6, 210, 80),
	
	
	
	#[0, 0, -210, "i"],
	#[0, 1, -70, "don't"],
	#[0, 2, 70, "recall"],
	#[0, 3, 210, "the"]
]

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event = event as InputEventKey
		var key_typed = PackedByteArray([key_event.unicode]).get_string_from_utf8()
		
		next_input += key_typed
		
func check_next_entry():
	if game_data_index >= game_data.size():
		return false
	
	var next_entry = game_data[game_data_index]
	
	if is_instance_of(next_entry, Word):
		if next_entry.delay * GAME_TIMER_FACTOR <= timer:
			var letter = Letter.instantiate()
			letter.text = next_entry.text
			letter.position.x = next_entry.xpos
			letter.is_letter2 = next_letter_is_phoenix
			letter.position.y = 500 + next_entry.yoffset# + next_entry[1] * 40
			#letter.is_letter2 = true
			get_node("/root/Game").add_child(letter)
			
			game_data_index += 1
			return true
		return false
	elif is_instance_of(next_entry, LetterChange):
		next_letter_is_phoenix = next_entry.next_letter
		game_data_index += 1
		return true
	elif is_instance_of(next_entry, WaitForWords):
		# Just wait for all the words to disappear.
		var ready = get_tree().get_nodes_in_group("Letter").is_empty()
		if ready:
			# Reset timer on wait
			timer = 0
			# finsih the command if it's ready
			game_data_index += 1
		return ready
	else:
		print("warning: unknown command encountered in command list")
		game_data_index += 1
		return true
	return false
		
func check_game_data(delta):
	timer += delta
	
	# Spawn any entries
	while check_next_entry():
		pass

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
	
