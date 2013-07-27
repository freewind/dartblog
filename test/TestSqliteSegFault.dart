library seg_tests;

import 'package:dart-sqlite/sqlite.dart';
import 'dart:io';



main() {
    var db = new Database.inMemory();
//    db.execute("""
//        CREATE TABLE Topic (
//          id           text PRIMARY KEY,
//          title        text NOT NULL,
//          content      text,
//          categoryId   text NOT NULL,
//          createdAt    int  NOT NULL,
//          updatedAt    int,
//          tags         text,
//          state        text,
//          viewCount    int,
//          commentCount int
//        );
//    """, []);
//    db.execute("""
//    insert into Topic(id, title, content, categoryId, createdAt, updatedAt, tags, state, viewCount, commentCount)
//        values(?,?,?,?,?,?,?,?,?,?);
//    """, ["11", "22", "33", "44", 555, 666, "777", "888", 999, 1000]);
//
//    db.execute("select * from Topic where id=?", ["11"], (row) {
//        print(row.id);
//    });

    db.execute("select 1",[], (row){
        print(row);
    });

   db.close();

}

