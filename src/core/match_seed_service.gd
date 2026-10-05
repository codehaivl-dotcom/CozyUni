extends Node

var _counter: int = 0


func create_seed() -> int:
	_counter += 1
	var unix_ms: int = int(Time.get_unix_time_from_system() * 1000.0)
	var ticks: int = int(Time.get_ticks_usec())
	return unix_ms ^ ticks ^ (_counter * 2654435761)


func create_rng(seed_value: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return rng
