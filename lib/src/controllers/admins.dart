part of _controllers;

initData(Request req) {
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

    req.response.send("ok");
}

login(Request req) {
    HttpRequest req = request.input;
    if (req.session.containsKey("userId")) {
        req.response.send(req.session["userId"]);
        return;
    }
    req.response.send(views.login());
}

doLogin(Request req) {
    _getPostData(req, (postData) {
        String email = postData['email'], password = postData['password'];
        var rs = userDao.findBy("email=? and password=?", [email, password]);
        if (rs.length == 1) {
            HttpRequest req = request.input;
            req.session.putIfAbsent("userId", () => rs.first.id);
            req.response.send("ok");
        } else {
            req.response.send("not found");
        }
    });
}

writePage(Request req) {
    req.response.send(views.writePage());
}

write(Request req) {
    _getPostData(req, (postData) {
        String title = postData['title'], content = postData['content'];
        Topic topic = topicDao.newModel();
        topic.title = title.trim();
        topic.content = content.trim();
        topic.categoryId = "23423";
        topic.createdAt = _now();
        topic.save();
        req.response.send("saved!");
    });
}

categories(Request req) {
    req.response.send(views.categories());
}
