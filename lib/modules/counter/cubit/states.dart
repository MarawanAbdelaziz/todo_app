abstract class CounterStates {}

class CounterInitialStates extends CounterStates {}

class CounterPlusStates extends CounterStates {
  final int counter;

  CounterPlusStates(this.counter);
}

class CounterMinusStates extends CounterStates {
  final int counter;

  CounterMinusStates(this.counter);
}
