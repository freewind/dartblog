library _orm;

import 'package:dart-sqlite/sqlite.dart';
import 'package:uuid/uuid.dart';
import 'dart:mirrors';
import 'globals.dart';
import 'helper.dart';

class Dao<T> {

    String get table => T.toString();

    newModel() {
        var cm = reflectClass(T);
        var ins = cm.newInstance(new Symbol(""), []);
        return ins.reflectee;
    }

    get(id) {
        var sql = "select * from $table where id=?";
        return newModel()..fromRow(database.first(sql, [id]));
    }

    List listAll([orderBy="createdAt desc"]) {
        var sql = """
            select * from $table order by $orderBy
        """;
        var list = [];
        database.execute(sql, [], (row) {
            list.add(newModel()..fromRow(row));
        });
        return list;
    }

    List findBy(String condition, List params) {
        var sql = """
            select * from $table where $condition
        """;
        var list = [];
        database.execute(sql, params, (row) {
            list.add(newModel()..fromRow(row));
        });
        return list;
    }

    bool deleteById(String id) {
        var sql = """
            delete from $table where id=?
        """;
        return database.execute(sql, [id]) == 1;
    }

}


Map<String, List<String>> table2FieldNames = {
};

abstract class Model {

    Type get modelType => this.runtimeType;

    String get table => modelType.toString();

    String id;

    List<String> get fieldNames => table2FieldNames[table];

    InstanceMirror im ;

    getFieldValue(String name) {
        return im.getField(new Symbol(name)).reflectee;
    }

    Model() {
        _initFieldNames();
        im = reflect(this);
    }


    _initFieldNames() {
        if (!table2FieldNames.containsKey(table)) {
            var fieldNames = [];
            ClassMirror cm = reflectClass(modelType);
            for (var member in cm.members.values) {
                if (member is VariableMirror && !member.isStatic) {
                    fieldNames.add(MirrorSystem.getName(member.simpleName));
                }
            }
            table2FieldNames[table] = fieldNames;
        }
        print(fieldNames);
    }

    fromRow(Row row) {
        assert(row != null);
        var fields = row.asMap();
        var im = reflect(this);
        for (var name in fields.keys) {
            im.setField(new Symbol(name), fields[name]);
        }
    }


    save() {
        if (id != null) {
            return update();
        } else {
            return insert();
        }
    }

    insert() {
        preInsert();
        id = nextId();
        var sql = """
            insert into $table (${fieldNames.join(', ')})
            values (${fieldNames.map((_) => '?').join(', ')})
        """;
        print(sql);
        database.execute(sql, fieldNames.map((n) => getFieldValue(n)).toList());
        postInsert();
    }


    bool update() {
        preUpdate();
        var listWithoutId = fieldNames.where((name) => name != "id");
        var sets = listWithoutId.map((name) => "$name=?").join(", ");
        var params = listWithoutId.map((name) => getFieldValue(name)).toList()..add(getFieldValue("id"));
        var sql = """
            update $table set ${sets} where id=?
        """;
        print(sql);
        postUpdate();
        return database.execute(sql, params) == 1;
    }

    delete() {
        var sql = """
            delete from $table where id=?
        """;
        return database.execute(sql, [getFieldValue("id")]) == 1;
    }

    preUpdate() {
    }

    postUpdate() {
    }

    preInsert() {
    }

    postInsert() {
    }

//    noSuchMethod(Invocation msg) {
//        var name = MirrorSystem.getName(msg.memberName);
//        if (msg.isSetter) {
//            print("### setter name: $name");
//            name = name.substring(0, name.length - 1);
//        }
//
//        if (fieldNames.contains(name)) {
//            if (msg.isGetter) {
//                if (fields.containsKey(name)) {
//                    return fields[name];
//                }
//            } else if (msg.isSetter) {
//                fields[name] = msg.positionalArguments [0];
//                return;
//            }
//        }
//
//        super.noSuchMethod(msg);
//    }

}
