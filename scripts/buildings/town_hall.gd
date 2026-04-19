extends Node2D

func deposit(worker):
	if worker.carrying > 0:
		ResourceManager.add_gold(worker.carrying)
		worker.carrying = 0
