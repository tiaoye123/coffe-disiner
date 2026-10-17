# Godot 4. Add as a child of any Control, drop the variations of one family into
# `variations`, and connect a button's `pressed` signal to `play_random`.
#
# It never plays the same clip twice in a row, and it never repeats until the
# whole set has been used. Plain `pick_random()` repeats: with 12 clips it plays
# the same one twice in a row about 8% of the time, which is exactly the
# repetition you paid to avoid. A shuffled bag cannot.

extends AudioStreamPlayer
class_name RandomSfx

@export var variations: Array[AudioStream] = []
## Small pitch spread on top of the built-in variation. Keep it low; these
## clips already differ from each other.
@export_range(0.0, 0.2) var pitch_jitter: float = 0.03

var _bag: Array[int] = []
var _last: int = -1


func _refill() -> void:
	# Built with a loop rather than `_bag = range(n)`. In Godot 4 `range()`
	# returns an untyped Array, and assigning that to an Array[int] is a
	# runtime error, not a silent conversion.
	_bag.clear()
	for i in variations.size():
		_bag.append(i)
	_bag.shuffle()
	# Stop a refill from producing a back-to-back repeat.
	if _bag.size() > 1 and _bag[0] == _last:
		var t := _bag[0]
		_bag[0] = _bag[1]
		_bag[1] = t


func play_random() -> void:
	if variations.is_empty():
		return
	if _bag.is_empty():
		_refill()
	_last = _bag.pop_front()
	stream = variations[_last]
	pitch_scale = 1.0 + randf_range(-pitch_jitter, pitch_jitter)
	play()
