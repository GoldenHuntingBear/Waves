extends Resource
class_name SinWave

@export var amplitude: float
@export var frequency: float
const START_SPEED = 10
var transition_time: float = 12
var start_time: float = 0


func _init(_amplitude: float, _frequency: float) -> void:
	self.amplitude = _amplitude
	self.frequency = _frequency


func multiply(value: float) -> SinWave:
	return SinWave.new(self.amplitude * value, self.frequency)


func function(time: float, slope: int = 0) -> float:
	var main_value = self.amplitude*sin(2*PI*self.frequency*time)

	if slope == 0:
		return main_value
	elif slope == -1:
		return diminishing_wave_factor(time) * main_value
	elif slope == 1:
		return augmenting_wave_factor(time) * main_value

	OS.alert("Wrong value for slope: %d" % slope, "ALERT")
	return 0


func tangent(time: float, slope: int = 0) -> float:
	#var temp = PI/2 + 2*PI*self.frequency*time
	#var dividor = floor(temp / (2*PI))
	#return - temp + dividor * 2 * PI + PI
	var main_value = 2*self.amplitude*self.frequency*cos(2*PI*self.frequency*time)

	if slope == 0:
		return main_value
	elif slope == -1:
		return diminishing_wave_factor(time) * main_value
	elif slope == 1:
		return augmenting_wave_factor(time) * main_value

	OS.alert("Wrong value for slope: %d" % slope, "ALERT")
	return 0


func diminishing_wave_factor(time: float) -> float:
	if time < start_time:
		return 1

	var transition = transition_time * START_SPEED
	var value = time/transition - start_time/transition

	return max(1-value, 0)


func augmenting_wave_factor(time: float) -> float:
	if time < start_time:
		return 0

	var transition = transition_time * START_SPEED
	var value = time/transition - start_time/transition

	return min(value, 1)


func to_str():
	return "SinWave(a:%f, f:%f)" % [amplitude, frequency]
