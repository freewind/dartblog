part of app;

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
    return views.index(topics);
}

writePage() {
    return views.writePage();
}

write(String title, String content) {
    Topic topic = topicDao.newModel();
    topic.title = title.trim();
    topic.content = content.trim();
    topic.categoryId = "23423";
    topic.createdAt = _now();
    topic.save();
    return "saved!";
}

oc() {
    return views.oc();
}

show() {
    return views.show();
}

login() {
    HttpRequest req = request.input;
    if (req.session.containsKey("userId")) {
        return req.session["userId"];
    }

    return views.login();
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
