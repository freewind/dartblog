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

fix(Request req) {
    req.response.send("OK");
}

todo(Request req) {
    req.response.send("TODO");
}

