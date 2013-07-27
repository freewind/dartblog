library topic_tests;

import 'package:unittest/unittest.dart';
import 'package:dart-sqlite/sqlite.dart';
import 'dart:io';
import '../lib/src/orm.dart';
import '../lib/src/dao.dart';
import '../lib/src/models.dart';
import '../lib/src/globals.dart';


initDB() {
    database = new Database.inMemory();
    runSqlFile("../db/create.sql");
    runSqlFile("../db/initdb.sql");
}

runSqlFile(String path) {
    File file = new File(path);
    var content = file.readAsStringSync();
    if (!content.isEmpty) {
        for (var sql in content.split(new RegExp(";"))) {
// notice: it can run a single sql each time
            database.execute(sql, []);
        }
    }
}

String _sampleId;

_createSample() {
    Topic topic = topicDao.newModel();
    topic.title = "Hello";
    topic.content = "world";
    topic.categoryId = "111";
    topic.tags = "ttt fff";
    topic.state = "ok";
    topic.viewCount = 222;
    topic.commentCount = 12;

    topic.insert();
    _sampleId = topic.id;
}

main() {
    setUp(() {
        initDB();
        _createSample();
    });

    tearDown(() {
        database.close();
    });

    test("new topic instance from dao", () {
        var topic = topicDao.newModel();
        expect(topic.runtimeType, Topic);
        expect(topic.id, isNull);
        expect(topic.createdAt, isNotNull);
    });

    test("insert topic", () {
        int preCount = topicDao.listAll().length;

        Topic topic = topicDao.newModel();
        topic.title = "Hello2";
        topic.content = "world2";
        topic.categoryId = "1112";
        topic.tags = "ttt fff2";
        topic.state = "ok2";
        topic.viewCount = 2222;
        topic.commentCount = 122;
        topic.insert();

        expect(topicDao.listAll().length, preCount + 1);


        var found = topicDao.get(topic.id);
        expect(found.id, topic.id);
        expect(found.title, "Hello2");
        expect(found.content, "world2");
        expect(found.categoryId, "1112");
        expect(found.tags, "ttt fff2");
        expect(found.state, "ok2");
        expect(found.viewCount, 2222);
        expect(found.commentCount, 122);
    });

    test("update topic", () {
        var topic = topicDao.get(_sampleId);
        topic.title = "aaa";
        topic.content = "bbb";
        topic.categoryId = "ccc";
        topic.tags = "ddd";
        topic.state = "eee";
        topic.commentCount = 333;
        topic.viewCount = 444;
        topic.update();

        expect(topicDao.listAll().length, 1);

        var found = topicDao.get(_sampleId);
        expect(found.id, topic.id);
        expect(found.title, "aaa");
        expect(found.content, "bbb");
        expect(found.categoryId, "ccc");
        expect(found.tags, "ddd");
        expect(found.state, "eee");
        expect(found.commentCount, 333);
        expect(found.viewCount, 444);
        expect(found.updatedAt, isNotNull);
    });

    test("delete topic by id", () {
        topicDao.deleteById(_sampleId);
        expect(topicDao.listAll().length, 0);
    });

    test("detele", () {
        var topic = topicDao.get(_sampleId);
        topic.delete();
        expect(topicDao.listAll().length, 0);
    });

}

