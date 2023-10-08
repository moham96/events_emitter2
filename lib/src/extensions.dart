extension ObjectExt on Object {
  String get objectId => '$runtimeType#$hashCode';
}
