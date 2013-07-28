part of _controllers;

index(Request req) {
    List topics = topicDao.listAll();
    req.response.send(views.index(topics));
}

topic(Request req) {
    String id = req.param("id");
    Topic topic = topicDao.get(id);
    Category category = null;
    if (topic.categoryId.isNotEmpty) {
        category = categoryDao.get(topic.categoryId);
    }
    req.response.send(views.topic(topic, category));
}

list(req) {
    var topics = topicDao.listAll();
    req.response.send(views.list(topics));
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
    req.response.send("todo");
}

todo(Request req) {
    req.response.send("TODO");
}

