library _models;

import "orm.dart";

class User extends Model {

    String id;

    String email;

    String name;

    String password;

    String salt;

    bool checkPassword(String pwd) {
        return password == pwd + salt;
    }
}


class Config extends Model {

    String id;

    String code;

    String value;

    String desc;

    int displayOrder;

}


class Page extends Model {

    String id;

    String name;

    String title;

    String content;

    int displayOrder;


}


class Category extends Model {

    String id;

    String name;

    int displayOrder;

    int topicCount;

}


class Topic extends Model {

    String id;

    String title;

    String content;

    String categoryId;

    int createdAt = new DateTime.now().millisecondsSinceEpoch;

    int updatedAt;

    String tags;

    String state;

    int viewCount;

    int commentCount;

    preUpdate() {
        this.updatedAt = new DateTime.now().millisecondsSinceEpoch;
    }

}


class Tag extends Model {

    String id;

    String name;

    int topicCount;

}


class Comment extends Model {

    String id;

    String topicId;

    String parentCommentId;

    String content;

    String username;

    String email;

    String website;

    int createdAt = new DateTime.now().millisecondsSinceEpoch;

    int updatedAt;

    String state;

}


class Link extends Model {

    String id;

    String link;

    String name;

    int displayOrder;

}

