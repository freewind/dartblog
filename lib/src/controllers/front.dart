part of _controllers;

index(Request req) {
    List topics = topicDao.listAll();
    req.response.send(views.index(topics));
}

topic(Request req) {
    String id = req.param("id");
    Topic topic = topicDao.get(id);
    req.response.send(views.topic(topic));
}

fix(Request req) {
    req.response.send("OK");
}
