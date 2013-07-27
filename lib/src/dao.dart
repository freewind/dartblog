library _dao;

import "models.dart";
import "orm.dart";


class CommentDao extends Dao<Comment> {
}

class PageDao extends Dao<Page> {
}

class ConfigDao extends Dao<Config> {
}

class TagDao extends Dao<Tag> {
}

class LinkDao extends Dao<Link> {
}

class CategoryDao extends Dao<Category> {
}

class UserDao extends Dao<User> {
}

class TopicDao extends Dao<Topic> {
}

UserDao userDao = new UserDao();

TopicDao topicDao = new TopicDao();

CategoryDao categoryDao = new CategoryDao();

LinkDao linkDao = new LinkDao();

TagDao tagDao = new TagDao();

ConfigDao configDao = new ConfigDao();

PageDao pageDao = new PageDao();

CommentDao commentDao = new CommentDao();
