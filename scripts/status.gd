class_name Status extends Node

enum Type { Defense, Poison, Angel, Demon, KO }

var type: Type
var value: int = 0

func is_expired() -> bool:
	return value <= 0
