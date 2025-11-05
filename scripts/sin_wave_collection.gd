extends Resource
class_name SinWaveCollection

var amplitude:float
var waves: Array[SinWave]


func _init(_amplitude: float, _waves: Array[SinWave]) -> void:
	self.amplitude = _amplitude
	self.waves = _waves


func change_amplitude(new_amplitude: float) -> SinWaveCollection:
	var new_waves: Array[SinWave]
	for wave in waves:
		new_waves.append(wave.multiply(self.amplitude))

	return SinWaveCollection.new(new_amplitude, new_waves)


func add(collection: SinWaveCollection) -> void:
	var new_collection = collection.change_amplitude(1)
	self.waves += new_collection.waves


func function(time: float) -> float:
	var result = 0

	for wave in waves:
		result += wave.function(time)

	return amplitude * result
