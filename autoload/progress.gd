extends Node

var hero1: Fighter = load("res://scenes/fight/hero.tscn").instantiate()
var hero2: Fighter = load("res://scenes/fight/hero.tscn").instantiate()

var gold: int = 0

signal gold_changed()
