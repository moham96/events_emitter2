import 'package:events_emitter2/src/events_emitter.dart';

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

void main(List<String> args) {
  var calculator = Calculator();
  var listener = calculator.createListener();
  listener
      .on<CalculationResults>((event) => print("Got results ${event.results}"));
  calculator.add(1, 2);
  listener.dispose();
}
