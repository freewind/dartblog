library _helper;

import "package:uuid/uuid.dart";

String nextId() {
    String id = new Uuid().v4();
    print("###id: $id");
    id = id.replaceAll("\-", "");
    print("###id: $id");
    return id;
}

String nextFileName() {
    return nextId();
}
