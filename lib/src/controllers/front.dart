part of _controllers;

index(Request req) {
    List topics = topicDao.listAll();
    List categories = categoryDao.listAll("name asc");
    req.response.send(views.index(topics, categories));
}

topic(Request req) {
    String id = req.param("id");
    Topic topic = topicDao.get(id);
    req.response.send(views.topic(topic));
}

categories(req) {
    var name = req.param("name");
    var category = null;
    if (name != null && !name.trim().isEmpty) {
        category = categoryDao.findBy("name=?", [name]).first;
    }
    var categories = categoryDao.listAll("name asc");
    req.response.send(views.categories(category, categories));
}

rss(Request req) {
    var title = "Freewind.me";
    var url = "http://freewind.me";
    var description = "低调的折腾技术";
// Wed, 19 Jun 2013 11:03:25 +0000
// new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
// FIXME
    var lastBuildDate = "Wed, 19 Jun 2013 11:03:25 +0000";
    var items = [];
    for (Topic topic in topicDao.listAll()) {
        items.add({
            "title": topic.title,
            "content":topic.content,
            "url" : "/todo/url"
        });
    }
    req.response
    .header('Content-Type', 'text/xml; charset=UTF-8')
    .send(views.rss(title, url, description, lastBuildDate, items));
}

fix(Request req) {
    String password = req.param("password");
    if (password == null || password.trim().isEmpty) {
        password = "123456";
    }
    User user = new User();
    user.email = "nowind_lee@qq.com";
    user.name = "Freewind";
    user.password = password;
    user.salt = nextId();
    user.insert();
    req.response.send("OK");
}

todo(Request req) {
    req.response.send("TODO");
}

