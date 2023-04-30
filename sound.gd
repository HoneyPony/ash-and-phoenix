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

func _ready():
	var writes = [write_1, write_2, write_3, write_4, write_5, write_6, write_7, write_8, write_9, write_10, write_11, write_12, write_13, write_14]
	for w in writes:
		w.start_db = -9
		w.volume_db = -9

func rand_write():
	var writes = [write_1, write_2, write_3, write_4, write_5, write_6, write_7, write_8, write_9, write_10, write_11, write_12, write_13, write_14]
	writes.pick_random().play_sfx()
