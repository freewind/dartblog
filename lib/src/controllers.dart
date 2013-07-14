library _controllers;

import "package:intl/intl.dart";
import 'gen/views/front/_views.dart' as views_front;
import 'gen/views/admin/_views.dart' as views_admin;
import "dao.dart";

_now() {
    return new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
}

initData() {
    var t = topicDao.newModel();
    t.title = "Hello";
    t.content = "Dart";
    t.categoryId = "23423";
    t.createdAt = _now();
    t.save();

    t = topicDao.newModel();
    t.title = "Hello3 423";
    t.content = "Dart dfdsfd";
    t.categoryId = "23423";
    t.createdAt = _now();
    t.save();

    t = topicDao.newModel();
    t.title = "Hello fgg ";
    t.content = "Dart dfgdfg";
    t.categoryId = "23423";
    t.createdAt = _now();
    t.save();

    var user = userDao.newModel();
    user.email = "aaa@aaa.com";
    user.password = "aaa";
    user.name = "AAA";
    user.salt = "123";
    user.save();

    return "ok";
}

index() {
    List topics = topicDao.listAll();
    return views_front.index(topics);
}

writePage() {
    return views_admin.writePage();
}

write(String title, String content) {
    Topic topic = topicDao.newModel();
    print("### new topic");
    topic.title = title.trim();
    topic.content = content.trim();
    topic.categoryId = "23423";
    topic.createdAt = _now();
    print("### going to save");
    topic.save();
    print("### saved");
    return "saved!";
}

oc() {
    return "not found";
}

show() {
    return views_front.show();
}

login() {
    HttpRequest req = request.input;
    if (req.session.containsKey("userId")) {
        return req.session["userId"];
    }

    return views_admin.login();
}

doLogin(String email, String password) {
    var rs = userDao.findBy("email=? and password=?", [email, password]);
    if (rs.length == 1) {
        HttpRequest req = request.input;
        req.session.putIfAbsent("userId", () => rs.first.id);
    } else {
        return "not found";
    }
}
