part of _controllers;

initData(Request req) {
    Category category = categoryDao.newModel();
    category.name = "Scala";
    category.save();

    category = categoryDao.newModel();
    category.name = "Java";
    category.save();

    category = categoryDao.newModel();
    category.name = "Dart";
    category.save();

    category = categoryDao.newModel();
    category.name = "其它语言";
    category.save();

    category = categoryDao.newModel();
    category.name = "未分类";
    category.save();

    req.response.send("ok");
}

adminLogin(Request req) {
    HttpRequest httpRequest = request.input;
    if (httpRequest.session.containsKey("userId")) {
        req.response.send(httpRequest.session["userId"]);
        return;
    }
    req.response.send(views.login());
}

adminDoLogin(Request req) {
    _getPostData(req, (postData) {
        String email = postData['email'], password = postData['password'];
        var rs = userDao.findBy("email=? and password=?", [email, password]);
        if (rs.length == 1) {
            HttpRequest httpRequest = request.input;
            httpRequest.session.putIfAbsent("userId", () => rs.first.id);
            req.response.send("ok");
        } else {
            req.response.send("not found");
        }
    });
}

writePage(Request req) {
    var id = req.param("id");
    var categories = categoryDao.listAll("name asc");
    var topic = null;
    if (id != null && !id.isEmpty) {
        topic = topicDao.get(id);
    }
    req.response.send(views.writePage(categories, topic));
}

adminSaveTopic(Request req) {
    _getPostData(req, (postData) {
        String id = postData['id'],
        title = postData['title'],
        content = postData['content'],
        tags = postData['tags'],
        categoryId = postData['categoryId'];

        Topic topic = null;
        if (id != null && !id.isEmpty) {
            topic = topicDao.get(id);
            topic.updatedAt = new DateTime.now().millisecondsSinceEpoch;
        } else {
            topic = topicDao.newModel();
            topic.createdAt = new DateTime.now().millisecondsSinceEpoch;
        }

        topic.title = title.trim();
        topic.content = content.trim();
        topic.categoryId = categoryId;
        topic.tags = tags;
        topic.save();
        req.response.send("saved!");
    });
}

adminTopics(Request req) {
    var topics = topicDao.listAll();
    req.response.send(views.adminTopics(topics));
}

adminEditTopic(Request req) {
    var id = req.param("id");
    var topic = topicDao.get(id);
    List categories = categoryDao.listAll("name asc");
    req.response.send(views.writePage(categories, topic));
}

adminDeleteTopic(Request req) {
    var id = req.param("id");
    var topic = topicDao.deleteById(id);
    req.response.send("ok");
}

adminCategories(Request req) {
    var categories = categoryDao.listAll("displayOrder desc");
    print("### categories: $categories");
    req.response.send(views.adminCategories(categories));
}

adminDeleteCategory(req) {
    var id = req.param("id");
    categoryDao.deleteById(id);
    adminCategories(req);
}

adminEditCategory(req) {
    req.response.send("TODO");
}

adminCreateCategory(req) {
    _getPostData(req, (postData) {
        var name = postData["name"];
        var category = categoryDao.newModel();
        category.name = name;
        category.save();
        adminCategories(req);
    });
}
