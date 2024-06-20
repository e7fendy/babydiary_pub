import 'dart:async';

class DataStream<T> {
  final List<T> _data = [];
  final StreamController<List<T>> _controller = StreamController<List<T>>.broadcast();

  Stream<List<T>> get stream => _controller.stream;

  Future<void> addData(T item) async {
    _data.add(item);
    _controller.sink.add(List<T>.from(_data));
  }

  Future<void> updateData(int index, T newItem) async {
    if (index >= 0 && index < _data.length) {
      _data[index] = newItem;
      _controller.sink.add(List<T>.from(_data));
    }
  }

  Future<void> removeData(int index) async {
    if (index >= 0 && index < _data.length) {
      _data.removeAt(index);
      _controller.sink.add(List<T>.from(_data));
    }
  }

  Future<void> dispose() async {
    _controller.close();
  }
}