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
	var do_disable_a 

	func _init(_text, _delay, _xpos, _yoffset):
		delay = _delay
		text = _text
		xpos = _xpos
		yoffset = _yoffset
		do_disable_a = false
		
	func disable_a():
		do_disable_a = true
		return self

class LetterChange:
	var next_letter
	func _init(_next_letter):
		next_letter = _next_letter
		
class WaitForWords:
	func _init():
		pass
		
class TimePassFX:
	var length
	
	func _init(_length):
		length = _length
		
class Chaos:
	func _init():
		pass
		
class ShowThanks:
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
func TIME_PASS(time):
	return TimePassFX.new(time)


# Stores the game data
var game_data = [
	WAIT(), # wait for entry button	
	
	CHANGE_ASH(),
	WORD("dear", 1.5, -70),
	WORD("phoenix", 1.9, 70),
	
	WAIT(),
	WORD("do", 0, -140),
	WORD("you", 0.4, 0),
	WORD("remember", 0.8, 140),
	WORD("our", 1.2, -140, 60),
	WORD("time", 1.6, 0, 60),
	WORD("capsule", 2.0, 140, 60),
	
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
	WORD("ago", 4.2, 210, 200),
	

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
	WORD("paper", 7.6, 210, 80),

	
	WAIT(),
	WORD("it's", 0, -210),
	WORD("been", 0.1, -70),
	WORD("a", 0.2, 70),
	WORD("while!", 0.3, 210),
	
	WAIT(),
	WORD("i", 0, 0),
	WORD("don't", 0.4, -140, 60),
	WORD("recall", 0.8, 0, 60),
	WORD("the", 1.2, 140, 60),
	WORD("last", 1.6, -210, 120),
	WORD("time", 2.0, -70, 120),
	WORD("we", 2.4, 70, 120),
	WORD("talked", 2.8, 210, 120),
	

	WAIT(),
	WORD("i", 0.0, -170),
	WORD("would", 0.4, -30),
	WORD("love", 0.8, 140),
	WORD("to", 1.2, -210, 60),
	WORD("hear", 1.6, -70, 60),
	WORD("all", 2.0, 70, 60),
	WORD("about", 2.4, 210, 60),
	WORD("what", 2.8, -210, 120),
	WORD("you're", 3.2, -70, 120),
	WORD("up", 3.6, 70, 120),
	WORD("to", 4.0, 210, 120),
	WORD("these", 4.4, 0, 180),
	WORD("days", 4.8, 140, 180),
	
	WAIT(),
	WORD("i", 0, -140),
	WORD("myself", 0.2, 0),
	WORD("decided", 0.4, 140),
	WORD("to", 0.8, -210, 60),
	WORD("drop", 1.2, -70, 60),
	WORD("everything", 1.4, 180, 60),
	
	WORD("a", 3.4, -210, 60),
	WORD("few", 3.8, -70, 60),
	WORD("years", 4.2, 70, 60),
	WORD("ago", 4.6, 210, 60),
	
	WORD("and", 6.4, -210, 60),
	WORD("pursue", 6.8, -70, 60),
	WORD("my", 7.2, 70, 60),
	WORD("dreams", 7.6, 210, 60),
	
	WORD("in", 8.8, -30, 120),
	WORD("music", 9.2, 100, 120),

	WAIT(),
	WORD("and", 0, 0),
	WORD("i", 1, -240, 60),
	WORD("have", 1.1, -120, 60),
	WORD("found", 1.2, 0, 60),
	WORD("some", 1.3, 120, 60),
	WORD("success!", 1.4, 240, 60),

	WAIT(),
	WORD("there's", 0, -210),
	WORD("a", 0.1, -80),
	WORD("really", 0.2, 50),
	WORD("cool", 0.3, 180),
	WORD("concert", 0.4, -180, 100),
	WORD("next", 0.5, -50, 100),
	WORD("year", 0.6, 80, 100),
	WORD("where", 1.6, -80, 100),
	WORD("i'm", 1.7, 50, 100),
	WORD("performing", 1.8, 180, 100),
	
	WORD("definitely", 4.8, -240, 100),
	WORD("looking", 5.0, -120, 100),
	WORD("forward", 5.2, 0, 100),
	WORD("to", 5.4, 120, 100),
	WORD("that", 5.6, 240, 100),
		
	# note on 7: -252, -168, -84, 0, 84, 168, 252
	WAIT(),
	WORD("i'm", 0, -70),
	WORD("hoping", 0.1, 70),
	WORD("to", 0.2, -240, 100), # originally "i", but that makes typing weird
	WORD("hear", 0.3, -120, 100),
	WORD("back", 0.4, 0, 100),
	WORD("from", 0.5, 120, 100),
	WORD("you!", 0.6, 240, 100),
	

	WORD("ash", 2.8, 210, 100), #Used to have a WAIT(), but I think it's cooler to do it
		# so that the signature is like, formatted on the same thing as the signoff
	
	WAIT(),
	CHANGE_PHOENIX(),
	WORD("dear", 0.8, -100),
	WORD("ash", 1.1, 40),
	
	WAIT(),
	WORD("what", 0, -210),
	WORD("a", 0.2, -70),
	WORD("pleasant", 0.4, 70),
	WORD("surprise!", 0.6, 210),
	
	WAIT(),
	WORD("i", 0, -140),
	WORD("hardly", 0.4, 0),
	WORD("remembered", 0.8, 140),
	WORD("our", 1.2, -140, 60),
	WORD("time", 1.6, 0, 60),
	WORD("capsule", 2.0, 140, 60),
	
	WAIT(),
	WORD("but", 0, -210),
	WORD("seeing", 0.4, -70),
	WORD("your", 0.8, 70),
	WORD("letter", 1.2, 210),
	
	WORD("the", 1.6, -180, 60),
	WORD("memories", 2.0, -40, 60),
	WORD("came", 2.4, 100, 60),
	WORD("rushing", 2.8, 40, 120),
	WORD("back", 3.2, 180, 120),
	

	
	WAIT(),
	WORD("and", 0, -70),
	WORD("thankfully", 0.2, 70),
	WORD("i", 1.2, -210, 60),
	WORD("still", 1.6, -70, 60),
	WORD("have", 2.0, 70, 60),
	WORD("my", 2.4, 210, 60),
	
	WORD("own", 2.8, -140, 120),
	WORD("ancient", 3.2, 0, 120),
	WORD("stationery", 3.6, 140, 120),
	
	WORD("for", 6.0, -200, 120),
	WORD("writing", 6.4, -60, 120),
	WORD("this", 6.8, 80, 120),
	WORD("reply", 7.2, 220, 120),

	WAIT(),
	WORD("it's", 0, -210),
	WORD("great", 0.4, -70),
	WORD("to", 0.8, 70),
	WORD("hear", 1.2, 210),
	
	WORD("that", 1.6, -210, 60),
	WORD("you're", 2.0, -70, 60),
	WORD("finding", 2.4, 70, 60),
	WORD("success", 2.8, 210, 60),
	
	WORD("with", 3.2, -140, 120), # originall "as a musician"
	WORD("your", 3.6, 0, 120),
	WORD("music", 4.0, 140, 120),
	

	WAIT(),
	WORD("but", 0, -140, 0),
	WORD("get", 0.4, 0, 0),
	WORD("this", 0.8, 140, 0),
	
	
	WORD("i", 3.4, -210),
	WORD("recently", 3.8, -70),
	WORD("bought", 4.2, 70),
	WORD("tickets", 4.6, 210),
	
	WORD("to", 5.0, -140, 60),
	WORD("a", 5.4, 0, 60),
	WORD("concert", 5.8, 140, 60),
	
	WORD("and", 7.0, 0, 120),
	WORD("it", 7.4, -140, 180),
	WORD("turns", 7.8, 0, 180),
	WORD("out", 8.2, 140, 180),
	WORD("it's", 9.3, -210, 240),
	WORD("the", 9.4, -70, 240),
	WORD("same", 9.5, 70, 240),
	WORD("one!", 9.6, 210, 240),
	

	
	WAIT(),
	WORD("it", 0, -80),
	WORD("appears", 0.4, 60),
	WORD("that", 0.8, 200),
	WORD("i'll", 1.6, -200, 60),
	WORD("see", 1.7, -60, 60),
	WORD("you", 1.8, 80, 60),
	WORD("there!", 1.9, 220, 60),
	
	
	
	WAIT(),
	WORD("as", 0, -160),
	WORD("for", 0.2, -20),
	WORD("what", 0.4, 120),
	WORD("i", 1.2, 0, 60),
	WORD("do", 2.0, -120, 120),
	WORD("these", 2.2, 20, 120),
	WORD("days", 2.4, 160, 120),
	
	WAIT(),
	WORD("well", 0, 0),
	WORD("as", 1.2, -210, 40),
	WORD("it", 1.4, -70, 40),
	WORD("turns", 1.6, 70, 40),
	WORD("out", 1.8, 210, 40),
	

	WAIT(),
	WORD("i", 0, -160),
	WORD("actually", 0.2, -20),
	WORD("volunteer", 0.4, 120),
	WORD("at", 0.6, -210, 60),
	WORD("this", 0.8, -70, 60), # originally 'a'
	WORD("dog", 1.0, 70, 60),
	WORD("rescue", 1.2, 210, 60),
	
	WORD("fostering", 3.2, -240, 60),
	WORD("dogs", 3.6, -120, 60),
	WORD("in", 4.0, 0, 60),
	WORD("my", 4.4, 120, 60),
	WORD("home", 4.8, 240, 60),

	WAIT(),
	WORD("it's", 0, -210),
	WORD("not", 0.4, -70),
	WORD("easy", 0.8, 70),
	WORD("work", 1.2, 210),
	
	WORD("but", 2.4, -240),
	WORD("there's", 2.8, -120),
	WORD("really", 3.0, 0),
	WORD("something", 3.1, 120),
	WORD("magical", 3.2, 240),

	WORD("about", 3.8, -200, 60),
	WORD("helping", 3.9, -60, 60),
	WORD("those", 4.0, 80, 60),
	WORD("animals", 4.1, 220, 60),

	WAIT(),
	WORD("sincerely", 0.6, -70),
	WORD("phoenix", 1.1, 70),
	
	WAIT(),
	CHANGE_ASH(),
	WORD("dear", 0.8, -70),
	WORD("phoenix", 1.1, 70),
	#[0, 0, -210, "i"],
	#[0, 1, -70, "don't"],
	#[0, 2, 70, "recall"],
	#[0, 3, 210, "the"]

	WAIT(),
	WORD("it", 0, -210),
	WORD("was", 0.3, -70),
	WORD("delightful", 0.6, 70),
	WORD("to", 0.9, -70, 80),
	WORD("see", 1.2, 70, 80),
	WORD("you", 1.5, 210, 80),
	WORD("at", 1.8, -210, 160),
	WORD("the", 2.1, -70, 160),
	WORD("concert!", 2.4, 70, 160),
	
	WAIT(),
	WORD("what", 0, -210),
	WORD("a", 0.2, -70),
	WORD("marvelous", 0.4, 70),
	WORD("coincidence!", 0.6, 210), # originally "coincidence that was", cut for format / time/ etc

	WAIT(),
	WORD("it", 0, -240),
	WORD("was", 0.4, -120),
	WORD("humbling", 0.8, 0),
	WORD("to", 1.2, 120),
	WORD("hear", 1.6, 240),
	WORD("about", 2.0, -240),
	WORD("the", 2.4, -120),
	WORD("work", 2.8, 0),
	WORD("you", 3.2, 120),
	WORD("do", 3.6, 240),
	
	WAIT(),
	WORD("the", 0, -240),
	WORD("dogs", 0.2, -120),
	WORD("in", 0.4, 0),
	WORD("your", 0.6, 120),
	WORD("care", 0.8, 240),
	
	WORD("are", 2.8, 0),
	
	WORD("quite", 5.8, -120),
	WORD("the", 6.2, 20),
	WORD("handful", 6.6, 160),	

	WAIT(),
	WORD("but", 0, -180),
	WORD("i", 0.4, -30),
	WORD("am", 0.8, 110),
	WORD("actually", 1.2, -110, 60),
	WORD("considering", 1.6, 30, 60),
	WORD("adopting", 2.0, 180, 60),
	
	WAIT(),
	WORD("a", 0, -210),
	WORD("pet", 0.4, -70),
	WORD("dog", 0.8, 70),
	WORD("soon", 1.2, 210),

	WAIT(),
	WORD("and", 0, -210).disable_a(),
	WORD("i", 0.2, -70),
	WORD("wonder", 0.4, 70),
	WORD("if", 0.6, 210),
	
	WORD("one", 0.8, -210, 60),
	WORD("of", 1.0, -70, 60),
	WORD("your", 2.0, 70, 60),
	WORD("dogs", 3.0, 210, 60),
	
	WORD("would", 3.4, -240, 120),
	WORD("be", 3.6, -120, 120),
	WORD("a", 3.8, 0, 120),
	WORD("good", 4.0, 120, 120),
	WORD("fit", 4.2, 240, 120),
	
		

	WAIT(),
	WORD("i", 0, -240),
	WORD("think", 0.2, -120),
	WORD("adopting", 0.4, 0),
	WORD("from", 0.6, 120),
	WORD("an", 0.8, 240),
	
	WORD("old", 1.0, -210, 60),
	WORD("friend's", 1.2, -70, 60),
	WORD("dog", 1.4, 70, 60),
	WORD("rescue", 1.6, 210, 60),
	
	WORD("would", 2.0, -100, 120),
	WORD("itself", 2.4, 40, 120),
	
	WORD("be", 2.8, -40, 180),
	WORD("rather", 3.2, 100, 180),
	WORD("magical", 4.0, 240, 180),

	WAIT(),
	WORD("let", 0, -210),
	WORD("me", 0.4, -70),
	WORD("know", 0.8, 70),
	WORD("ash", 2.4, 210, 0),
	

	WAIT(),
	CHANGE_PHOENIX(),
	WORD("dear", 1.5, -100),
	WORD("ash", 2.0, 40),
	
	WAIT(),
	WORD("i", 0, -210),
	WORD("hope", 0.4, -70),
	WORD("you", 0.8, 70),
	WORD("are", 1.2, 210),
	
	WORD("getting", 1.6, -180, 60),
	WORD("along", 2.0, -30, 60),
	WORD("well", 2.4, 110, 60),
	
	WORD("with", 2.8, -240, 120),
	WORD("your", 3.2, -120, 120),
	WORD("new", 3.6, 0, 120),
	WORD("pet", 4.0, 120, 120),
	WORD("dog", 4.4, 240, 120),
	

	WAIT(),
	WORD("i", 0, -210),
	WORD("know", 0.4, -70),
	WORD("we", 0.8, 70),
	WORD("already", 1.2, 210),

	WORD("discussed", 2.4, -210),
	WORD("her", 2.9, -70),
	WORD("medical", 3.4, 70),
	WORD("situation", 3.9, 210),
	WORD("at", 4.4, 60, 60),
	WORD("length", 4.9, 200, 60),
	
	WORD("but", 6.0, 0, 60),
	
	
	WAIT(),
	WORD("i", 0, -240),
	WORD("wanted", 0.2, -120),
	WORD("to", 0.4, 0),
	WORD("reach", 0.6, 120),
	WORD("out", 0.8, 240),
	
	WORD("and", 1.4, -180, 30),
	WORD("say", 1.6, -40, 30),
	
	WORD("if", 2.6, -240, 60),
	WORD("you", 2.8, -120, 60),
	WORD("ever", 3.0, 0, 60),
	WORD("run", 3.2, 120, 60),
	WORD("into", 3.4, 240, 60),
	
	WORD("any", 4.4, 40, 60),
	WORD("complications", 5.4, 180, 60),
	
	WORD("feel", 5.8, -180, 120),
	WORD("free", 6.2, -40, 120),
	
	WORD("to", 6.6, -240, 180),
	WORD("discuss", 7.0, -120, 180),
	WORD("them", 7.3, 0, 180),
	WORD("with", 7.5, 120, 180),
	WORD("me", 7.7, 240, 180),

	
	WAIT(),
	WORD("i'm", 0, -240),
	WORD("not", 0.2, -120),
	WORD("a", 0.4, 0),
	WORD("complete", 0.9, 120),
	WORD("expert", 1.2, 240),
	
	WORD("but", 2.4, -230),
	
	WAIT(),
	WORD("i", 0, -110),
	WORD("know", 0.2, 10),
	WORD("a", 0.4, 130),
	WORD("lot", 0.6, 250),
	
	WORD("and", 0.8, -240, 60),
	
	WAIT(),
	WORD("i", 0, -120, 0),
	WORD("did", 0.2, 0, 0),
	WORD("live", 0.4, 120, 0),
	WORD("with", 0.6, 240, 0),
	
	WORD("this", 0.8, -230, 60),
	WORD("dog", 1.0, -110, 60),
	WORD("for", 1.2, 10, 60),
	WORD("a", 1.4, 110, 60),
	WORD("while", 1.6, 230, 60),

	
	WAIT(),
	WORD("sincerely", 0, -70),
	WORD("phoenix", 0.5, 70),
	
	WAIT(),
	WORD("ps:", 0.0, -210),
	
	WAIT(),
	WORD("if", 0, -230),
	WORD("you", 0.2, -90),
	WORD("ever", 0.4, 50),
	WORD("settled", 0.6, 190),
	
	WORD("on", 1.0, -50, 60),
	WORD("her", 1.2, 90, 60),
	WORD("name", 1.4, 190, 60),
	
	WORD("i'd", 1.8, -240, 100),
	WORD("love", 1.9, -120, 100),
	WORD("to", 2.0, 0, 100),
	WORD("hear", 2.1, 120, 100),
	WORD("it!", 2.2, 240, 100),
	

	
	WAIT(),
	CHANGE_ASH(),
	WORD("dear", 0.8, -70),
	WORD("phoenix", 1.1, 70),
	
	WAIT(),
	WORD("thanks", 0, -210),
	WORD("for", 0.4, -70),
	WORD("reaching", 0.8, 70),
	WORD("out!", 1.2, 210),
	
	WAIT(),
	WORD("she's", 0, -140),
	WORD("doing", 0.4, 0),
	WORD("great!", 0.8, 140),

	
	WAIT(),
	WORD("i", 0, -240),
	WORD("decided", 0.4, -120),
	WORD("to", 0.8, 0),
	WORD("name", 1.2, 120),
	WORD("her", 1.6, 240),
	
	WORD("serendipity", 3.6, 0, 30),
	
	WORD("due", 4.6, -250, 90),
	WORD("to", 4.8, -130, 90),
	WORD("the", 5.0, -10, 90),
	WORD("incredible", 5.2, 110, 90),
	WORD("circumstances", 5.4, 230, 90),
	
	WORD("leading", 5.6, -210, 150),
	WORD("to", 5.8, -70, 150),
	WORD("her", 6.0, 70, 150),
	WORD("adoption", 6.2, 210, 150),

	
	WAIT(),
	WORD("stay", 0, -210),
	WORD("in", 0.4, -70),
	WORD("touch", 0.8, 70),
	WORD("ash", 2.4, 210, 0),
	
	WAIT(),
	WORD("ps:", 0, -210),
	
	WAIT(),
	WORD("attached", 0, -240),
	WORD("to", 0.2, -120),
	WORD("this", 0.4, 0),
	WORD("letter", 0.6, 120),
	WORD("are", 0.8, 240),
	
	WORD("some", 1.2, -140, 60),
	WORD("photos", 1.4, 0, 60),
	
	WAIT(),
	WORD("there's", 0, -240),
	WORD("her", 0.2, -120),
	WORD("on", 0.4, -240, 60),
	WORD("our", 0.6, -120, 60),
	WORD("first", 0.8, 0, 60),
	WORD("hike", 1.0, 120, 60),
	WORD("together", 1.2, 240, 60),
	
	WAIT(),
	WORD("there's", 0, -240),
	WORD("her", 0.2, -120),
	WORD("playing", 0.4, -70, 60),
	WORD("fetch", 0.6, 70, 60),
	
	WAIT(),
	WORD("there's", 0, -240),
	WORD("her", 0.2, -120),
	WORD("helping", 0.4, -210, 60),
	WORD("me", 0.6, -70, 60),
	WORD("practice", 0.8, 70, 60),
	WORD("guitar", 1.0, 210, 60),
	
	WAIT(),
	WORD("what", 0, -210),
	WORD("a", 0.2, -120),
	WORD("great", 0.4, 120),
	WORD("dog!", 0.6, 210),
	WAIT(),
	
		

	TIME_PASS(4),

	CHANGE_PHOENIX(),
	
	WORD("dear", 0.0, -100, 0),
	WORD("ash", 1.0, 40, 0).disable_a(),
	
	WORD("it's", 1.8, -240, 60),
	WORD("been", 2.0, -120, 60),
	WORD("a", 2.2, 0, 60),
	WORD("long", 2.4, 120, 60),
	WORD("time", 2.6, 240, 60),
	
	WAIT(),
	
	WORD("...", 0.0, -250, 90),
	WORD("i", 2.5, -150, 90),
	WORD("saw", 3.0, -50, 90),
	WORD("what", 3.5, 50, 90),
	WORD("you", 4.0, 150, 90),
	WORD("posted", 4.5, 250, 90),
	WORD("and", 5.0, -250, 90),
	WORD("...", 5.0, -150, 120),
	
	CHANGE_ASH(),
	WORD("dear", 5.0, -70, 0),
	WORD("phoenix", 5.5, 70, 0),
	
	WORD("i", 6.0, -240, 0),
	WORD("thought", 6.6, -120, 0),
	WORD("this", 7.2, 0, 0),
	WORD("would", 7.8, 120, 0),
	WORD("be", 8.4, 240, 0),
	
	WORD("the", 9, -240),
	WORD("most", 9.6, -120),
	WORD("appropriate", 10.2, 0),
	WORD("medium", 10.8, 120),
	WORD("to", 11.4, 240),
	
	WORD("tell", 12, -140),
	WORD("you", 12.6, 0),
	WORD("this", 13.2, 140),
	

	
	WORD("basically", 13.5, 0),
	WORD("well", 13.8, -140),
	WORD("serendipity", 14.1, 140),
	WORD("she.....", 14.6, 0, 20),
	WORD("...", 16, 0, 60),
	WORD("...", 18, 0, 60),
	
	Chaos.new(),

	WAIT(),
	WORD("but", 3.0, -210),
	
	WAIT(),
	WORD("thank", 0, -70),
	WORD("you", 0.04, 70),
	WORD("phoenix", 1.0, 210),
	
	WAIT(),
	WORD("for", 0, -240),
	WORD("all", 0.4, -120),
	WORD("the", 0.8, 0),
	WORD("good", 1.2, 120),
	WORD("times", 1.6, 240),
	
	WORD("i", 2.4, -210),
	WORD("shared", 2.8, -70),
	WORD("with", 3.2, 70),
	WORD("her.", 3.6, 210),
	
	WAIT(),
	ShowThanks.new()
]

var chaos_src = "i don't know how to say this phoenix she's gone phoenix and i don't know what to do anymore she's GONE and i'm a wreck and i can't think straight and i can't even seem to send this letter and all i can do is think of just everything we used to do and how that's all just gone now you know like how do you even deal with that"
var chaos_arr = []
var chaos_idx = 0
var chaos_counter = 0
var chaos_rate = 0.8 # start slow, then speed up

func _ready():
	# Setup chaos.. easier to program this way
	chaos_arr = Array(chaos_src.split(" "))

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key_event = event as InputEventKey
		var key_typed = PackedByteArray([key_event.unicode]).get_string_from_utf8()
		
		next_input += key_typed
		
func check_next_entry():
	if game_data_index >= game_data.size():
		return false
	
	var next_entry = game_data[game_data_index]
	
	if is_instance_of(next_entry, Chaos):
		# randomly spawn these things very very quickly
		if timer > randf_range(max(0.016666, chaos_rate), max(0.2, chaos_rate)):
			chaos_rate = max(chaos_rate - 0.04, 0)
			timer = 0 # reset timer
			var letter = Letter.instantiate()
			letter.text = chaos_arr[chaos_idx]
			letter.max_vel_y = randf_range(-240, -120)
			if chaos_rate > 0.5:
				letter.max_vel_y = -160
			chaos_idx += 1
			if chaos_idx >= chaos_arr.size():
				chaos_idx = 0
				chaos_arr.shuffle()
				
			letter.position.x = randf_range(-240, 240)
			letter.is_letter2 = false
			letter.position.y = 500 + randf_range(0, 30)
			get_node("/root/Game").add_child(letter)
			
			chaos_counter += 1
			if chaos_counter > 160:
				# Finally done
				game_data_index += 1
				return true # not really necessary but technically correct
				
			return false # Only execute once per tick
		return false
	elif is_instance_of(next_entry, Word):
		if next_entry.delay * GAME_TIMER_FACTOR <= timer:
			var letter = Letter.instantiate()
			letter.text = next_entry.text
			letter.position.x = next_entry.xpos
			letter.is_letter2 = next_letter_is_phoenix
			letter.disable_a = next_entry.do_disable_a
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
		# Use BlockingLetter because Letter is not added at spawn time.
		var ready = get_tree().get_nodes_in_group("BlockingLetter").is_empty()
		if ready:
			# Reset timer on wait
			timer = 0
			# finsih the command if it's ready
			game_data_index += 1
		return ready
	elif is_instance_of(next_entry, TimePassFX):
		# TODO: Sound effect...?
		if next_entry.length <= timer:
			game_data_index += 1
			timer = 0 # Reset timer on TIME_PASS
			return true
		# wait
		return false
	elif is_instance_of(next_entry, ShowThanks):
		if timer > 8.0: # 8 second wait for the message
			timer = 0
			game_data_index += 1
			get_node("/root/Game/PlayMsg").show()
			return true
		return false
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
	
	#var has_completed_candidate = false
	var best_match_length = 0
	
	# DIsable a applies to the first (in-order) scan because it deals with order
	var disable_a = false
	
	for letter in get_tree().get_nodes_in_group("Letter"):
		var measure = letter.measure_input(next_input)

		if measure[1] > best_match_length:
			best_match_length = measure[1]
			
		if disable_a and letter.text == "a":
			letter.render_text(0, false) # clear!
			continue

		if measure[0] <= max_mistakes:
			if measure[1] > 0:
				if letter.disable_a:
					disable_a = true
			has_valid_letter = true
			letter.render_text(measure[1], measure[0] > 0)
		else:
			# Clear letter's render
			letter.render_text(0, false)
			
	# Second pass, to check for completed letter
	for letter in get_tree().get_nodes_in_group("Letter"):
		var measure = letter.measure_cache # resuse measurement
		
		# special logic for disabling a
		if letter.text == "a" and disable_a:
			continue
		
		# If the letter was completed, send it off! and
		# we will have to reset everything
		if letter.text.length() == measure[1]:
			# Don't allow mistakes to allow a worse overall match from stealing the input
			if measure[1] >= best_match_length:
				has_completed_letter = true
				letter.complete()
				break
		
		
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
	
