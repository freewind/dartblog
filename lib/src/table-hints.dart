library _table_hints;

import "model.dart";

abstract class User implements Model {

    String id;

    String email;

    String name;

    String password;

    String salt;

}


abstract class Config implements Model {

    String id;

    String code;

    String value;

    String desc;

    int displayOrder;

}


abstract class Page implements Model {

    String id;

    String name;

    String title;

    String content;

    int displayOrder;


}


abstract class Category implements Model {

    String id;

    String name;

    int displayOrder;

    int topicCount;

}


abstract class Topic implements Model {

    String id;

    String title;

    String content;

    String categoryId;

    String createdAt;

    String updatedAt;

    String tags;

    String state;

    int viewCount;

    int commentCount;

}


abstract class Tag implements Model {

    String id;

    String name;

    int topicCount;

}


abstract class Comment implements Model {

    String id;

    String topicId;

    String parentCommentId;

    String content;

    String username;

    String email;

    String website;

    String createdAt;

    String updatedAt;

    String state;

}


abstract class Link implements Model {

    String id;

    String link;

    String name;

    int displayOrder;

}

