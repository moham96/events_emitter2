import 'package:events_emitter2/src/events_emitter.dart';
import 'package:test/test.dart';

abstract class CalculationEvent {}

class CalculationResults extends CalculationEvent {
  final num results;

  CalculationResults({required this.results});
}

class Calculator with EventsEmittable<CalculationEvent> {
  void add(num a, num b) {
    events.emit(CalculationResults(results: a + b));
  }
}

void main() {
  test('calculate', () {
    var emitter = Calculator();
    var listener = emitter.createListener();

    listener.on<CalculationResults>(
      (event) {
        expect(event.results, equals(3));
      },
    );
    emitter.add(1, 2);
    listener.dispose();
  });
}
