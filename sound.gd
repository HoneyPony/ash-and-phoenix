extends Node

@onready var write_1 = $write1
@onready var write_2 = $write2
@onready var write_3 = $write3
@onready var write_4 = $write4
@onready var write_5 = $write5
@onready var write_6 = $write6
@onready var write_7 = $write7
@onready var write_8 = $write8
@onready var write_9 = $write9
@onready var write_10 = $write10
@onready var write_11 = $write11
@onready var write_12 = $write12
@onready var write_13 = $write13
@onready var write_14 = $write14

@onready var lslide_1 = $lslide1
@onready var lslide_2 = $lslide2
@onready var lslide_3 = $lslide3
@onready var lfold_1 = $lfold1
@onready var lfold_2 = $lfold2
@onready var lfold_3 = $lfold3

func _ready():
	var writes = [write_1, write_2, write_3, write_4, write_5, write_6, write_7, write_8, write_9, write_10, write_11, write_12, write_13, write_14]
	for w in writes:
		w.start_db = -9
		w.volume_db = -9
		
	var folds = [lfold_1, lfold_2, lfold_3]
	for f in folds:
		f.start_db = -6
		f.volume_db = -6
		
func rand_slide():
	var slides = [lslide_1, lslide_2, lslide_3]
	slides.pick_random().play_sfx()
func rand_fold():
	var folds = [lfold_1, lfold_2, lfold_3]
	folds.pick_random().play_sfx()

func rand_write():
	var writes = [write_1, write_2, write_3, write_4, write_5, write_6, write_7, write_8, write_9, write_10, write_11, write_12, write_13, write_14]
	writes.pick_random().play_sfx()
