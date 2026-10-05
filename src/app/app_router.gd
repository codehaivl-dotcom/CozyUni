extends Node

signal route_changed(route_id: String, payload: Dictionary)

const ShellFlowScript = preload("res://src/app/shell_flow.gd")

var _flow = ShellFlowScript.new()
var _payload: Dictionary = {}


func _ready() -> void:
	_flow.reset()


func get_route() -> String:
	return str(_flow.current_route)


func get_payload() -> Dictionary:
	return _payload.duplicate(true)


func navigate(route_id: String, payload: Dictionary = {}) -> bool:
	if not _flow.is_known_route(route_id):
		push_error("AppRouter: unknown route '%s'" % route_id)
		return false
	var from_route: String = str(_flow.current_route)
	if not _flow.transition(route_id):
		push_error("AppRouter: invalid transition %s -> %s" % [from_route, route_id])
		return false
	_payload = payload.duplicate(true)
	route_changed.emit(route_id, get_payload())
	return true