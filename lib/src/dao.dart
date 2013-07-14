part of app;

var userDao = new UserDao();
var topicDao = new TopicDao();
var categoryDao = new CategoryDao();
var linkDao = new LinkDao();
var tagDao = new TagDao();
var configDao = new ConfigDao();
var pageDao = new PageDao();
var commentDao = new CommentDao();

class CommentDao extends Dao {
    CommentDao(): super(Comment) {}
}

class PageDao extends Dao {
    PageDao(): super(Page){}
}

class ConfigDao extends Dao {
    ConfigDao():super(Config){}
}

class TagDao extends Dao {
    TagDao():super(Tag) {}
}

class LinkDao extends Dao {
    LinkDao():super(Link) {}
}

class CategoryDao extends Dao {
    CategoryDao():super(Category) {}
}

class UserDao extends Dao {
    UserDao():super(User) {
    }
}


class TopicDao extends Dao {
    TopicDao():super(Topic) {
    }
}

class Dao {

    Type hintClass;

    String get table => hintClass.toString();

    Dao(this.hintClass);

    newModel() {
        return new Model(hintClass);
    }

    get(id) {
        var sql = "select * from $table where id=?";
        return database.first(sql, [id]);
    }

    List listAll() {
        var sql = """
            select * from $table order by createdAt desc
        """;
        var list = [];
        database.execute(sql, [], (row) {
            list.add(new Model.fromRow(hintClass, row));
        });
        return list;
    }

    List findBy(String condition, List params) {
        var sql = """
            select * from $table where $condition
        """;
        var list = [];
        database.execute(sql, params, (row) {
            list.add(new Model.fromRow(hintClass, row));
        });
        return list;
    }

}
