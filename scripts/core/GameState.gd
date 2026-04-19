extends Node

var game_over := false

func lose():
	if game_over:
		return
	game_over = true
	print("DEFEAT: All units lost")

func win():
	if game_over:
		return
	game_over = true
	print("VICTORY: Enemy defeated")
