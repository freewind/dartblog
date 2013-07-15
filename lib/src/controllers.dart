library _controllers;

import "package:intl/intl.dart";
import '../gen/views/front/_views.dart' as views_front;
import '../gen/views/admin/_views.dart' as views_admin;
import "dao.dart";

_now() {
    return new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
}

index() {
    List topics = topicDao.listAll();
    return views_front.index(topics);
}


oc() {
    return "not found";
}

show() {
    return views_front.show();
}


