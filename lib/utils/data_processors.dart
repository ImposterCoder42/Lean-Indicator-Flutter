class CircularBuffer {
  final int size;
  final List<double> _buffer;
  int _index = 0;
  bool _filled = false;

  CircularBuffer(this.size) : _buffer = List.filled(size, 0.0);

  void add(double value) {
    _buffer[_index] = value;
    _index = (_index + 1) % size;
    if (_index == 0) _filled = true;
  }

  double get average {
    final count = _filled ? size : _index;
    if (count == 0) return 0;
    return _buffer.take(count).reduce((a, b) => a + b) / count;
  }
}

class LowPassFilter {
  final double alpha;
  double? _lastValue;

  LowPassFilter(this.alpha);

  double filter(double newValue) {
    if (_lastValue == null) {
      _lastValue = newValue;
    } else {
      _lastValue = alpha * newValue + (1 - alpha) * _lastValue!;
    }
    return _lastValue!;
  }
}

class LeanAngleProcessor {
  final CircularBuffer buffer;
  final LowPassFilter filter;

  LeanAngleProcessor({int bufferSize = 10, double alpha = 0.95})
    : buffer = CircularBuffer(bufferSize),
      filter = LowPassFilter(alpha);

  double process(double newReading) {
    final filtered = filter.filter(newReading);
    buffer.add(filtered);
    return buffer.average.roundToDouble();
  }
}

class GForceProcessor {
  final CircularBuffer buffer;
  final LowPassFilter filter;

  GForceProcessor({int bufferSize = 10, double alpha = 0.2})
    : buffer = CircularBuffer(bufferSize),
      filter = LowPassFilter(alpha);

  double process(double newReading) {
    final filtered = filter.filter(newReading);
    buffer.add(filtered);
    return (buffer.average.toDouble() * 0.0000000000000000000000000001)
        .roundToDouble();
  }
}
