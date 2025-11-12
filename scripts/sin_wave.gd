extends Resource
class_name SinWave

@export var amplitude: float
@export var frequency: float


func _init(_amplitude: float, _frequency: float) -> void:
	self.amplitude = _amplitude
	self.frequency = _frequency


func multiply(value: float) -> SinWave:
	return SinWave.new(self.amplitude * value, self.frequency)


func function(time: float) -> float:
	return self.amplitude*sin(2*PI*self.frequency*time)


func tangent(time: float) -> float:
	#var temp = PI/2 + 2*PI*self.frequency*time
	#var dividor = floor(temp / (2*PI))
	#return - temp + dividor * 2 * PI + PI
	return 2*PI*self.amplitude*self.frequency*cos(2*PI*self.frequency*time)
