library _helper;

import "package:uuid/uuid.dart";

String nextId() {
    String id = new Uuid().v4();
    id = id.replaceAll("\-", "");
    return id;
}

String nextFileName() {
    return nextId();
}
