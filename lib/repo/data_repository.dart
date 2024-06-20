

import '../../data/child_data.dart';
import '../utils/data_stream.dart';

abstract class DataRepository {
  late final DataStream<ChildData> childrenStream;
}

class InMemoryDataRepository implements DataRepository {
  @override
  DataStream<ChildData> childrenStream = DataStream();
}