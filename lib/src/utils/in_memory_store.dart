import 'package:rxdart/subjects.dart';

//* It is important to read about `BehaviorSubject` and how they work

/// An in-memory state backed by `BehaviorSubject` that can be used to
/// store the data for all repos in the app
class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  /// The `BehaviorSubject` that holds the data
  final BehaviorSubject<T> _subject;

  /// The output stream that can be used to listen to data
  Stream<T> get stream => _subject.stream;

  /// A synchronous getter for the current value
  T get value => _subject.value;

  /// A setter for updating the value
  set value(T value) => _subject.add(value);

  /// Don't forget to call this method when done
  void close() => _subject.close();
}
