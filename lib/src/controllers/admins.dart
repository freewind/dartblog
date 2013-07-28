part of _controllers;

const USER_ID_KEY = "userId";

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
    HttpRequest httpRequest = req.input;
    if (httpRequest.session.containsKey(USER_ID_KEY)) {
        req.response.send(httpRequest.session[USER_ID_KEY]);
        adminTopics(req);
        return;
    }
    req.response.send(views.login());
}

adminDoLogin(Request req) {
    print("### in admiNDoLogin");
    _getPostData(req, (postData) {
        String email = postData['email'], password = postData['password'];
        var users = userDao.findBy("email=?", [email]);
        if (users.isEmpty) {
            req.response.send("not found");
        } else {
            var user = users.first;
            if (user.checkPassword(password)) {
                HttpRequest httpRequest = req.input;
                httpRequest.session[USER_ID_KEY] = user.id;
                req.response.send("ok");
            } else {
                req.response.send("invalid password");
            }
        }
    });
}

writePage(Request req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    var id = req.param("id");
    var categories = categoryDao.listAll("name asc");
    var topic = null;
    if (id != null && !id.isEmpty) {
        topic = topicDao.get(id);
    }
    req.response.send(views.writePage(categories, topic));
}

adminSaveTopic(Request req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

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
    if (_isNotLoggedIn(req)) return adminLogin(req);

    var topics = topicDao.listAll();
    req.response.send(views.adminTopics(topics));
}

adminEditTopic(Request req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    var id = req.param("id");
    var topic = topicDao.get(id);
    List categories = categoryDao.listAll("name asc");
    req.response.send(views.writePage(categories, topic));
}

adminDeleteTopic(Request req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    var id = req.param("id");
    var topic = topicDao.deleteById(id);
    req.response.send("ok");
}

adminCategories(Request req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    var categories = categoryDao.listAll("displayOrder desc");
    print("### categories: $categories");
    req.response.send(views.adminCategories(categories));
}

adminDeleteCategory(req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    var id = req.param("id");
    categoryDao.deleteById(id);
    adminCategories(req);
}

adminEditCategory(req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    req.response.send("TODO");
}

adminCreateCategory(req) {
    if (_isNotLoggedIn(req)) return adminLogin(req);

    _getPostData(req, (postData) {
        var name = postData["name"];
        var category = categoryDao.newModel();
        category.name = name;
        category.save();
        adminCategories(req);
    });
}

bool _isNotLoggedIn(Request req) {
    HttpRequest httpRequest = req.input;
    var userId = httpRequest.session[USER_ID_KEY];
    print("### userId : $userId");
    return userId == null || userId.trim().isEmpty;
}
