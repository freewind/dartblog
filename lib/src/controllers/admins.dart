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
    HttpRequest req = request.input;
    if (req.session.containsKey("userId")) {
        req.response.send(req.session["userId"]);
        return;
    }
    req.response.send(views.login());
}

adminDoLogin(Request req) {
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
    var categories = categoryDao.listAll("name asc");
    req.response.send(views.writePage(categories));
}

write(Request req) {
    _getPostData(req, (postData) {
        String title = postData['title'],
        content = postData['content'],
        tags = postData['tags'],
        categoryId = postData['categoryId'];

        Topic topic = topicDao.newModel();
        topic.title = title.trim();
        topic.content = content.trim();
        topic.categoryId = categoryId;
        topic.tags = tags;
        topic.createdAt = _now();
        topic.save();
        req.response.send("saved!");
    });
}

adminCategories(Request req) {
    var categories = categoryDao.listAll("displayOrder desc");
    print("### categories: $categories");
    req.response.send(views.categories(categories));
}

adminDeleteCategory(req) {
    var id = req.param("id");
    categoryDao.deleteById(id);
    adminCategories(req);
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

