library _model;

import 'package:dart-sqlite/sqlite.dart';
import 'dart:mirrors';
import 'package:uuid/uuid.dart';
import 'globals.dart';
import 'helper.dart';

Map<String, List<String>> fieldNameMap = {
};

class Model {

    Type hintClass;

    String get table => hintClass.toString();

    List<String> get fieldNames => fieldNameMap[table];

    Map<String, dynamic> fields = {
    };

    Model(this.hintClass) {
        initFieldNames();
    }

    Model.fromRow(this.hintClass, Row row) {
        initFieldNames();
        fields = row.asMap();
    }

    initFieldNames() {
        if (!fieldNameMap.containsKey(table)) {
            var fieldNames = [];
            ClassMirror cm = reflectClass(hintClass);
            for (var member in cm.members.values) {
                if (member is VariableMirror && !member.isStatic) {
                    fieldNames.add(MirrorSystem.getName(member.simpleName));
                }
            }
            fieldNameMap[table] = fieldNames;
        }
        print(fieldNames);
    }


    operator [](String name) {
        return fields[name];
    }


    save() {
        if (fields['id'] != null) {
            return update();
        } else {
            return insert();
        }
    }

    Model insert() {
        fields['id'] = newId();
        var sql = """
            insert into $table (${fieldNames.join(', ')})
            values (${fieldNames.map((_) => '?').join(', ')})
        """;
        print(sql);
        database.execute(sql, fieldNames.map((n) => this[n]).toList());
        return this;
    }


    bool update() {
        return false;
    }


    noSuchMethod(Invocation msg) {
        var name = MirrorSystem.getName(msg.memberName);
        if (msg.isSetter) {
            print("### setter name: $name");
            name = name.substring(0, name.length - 1);
        }

        if (fieldNames.contains(name)) {
            if (msg.isGetter) {
                if (fields.containsKey(name)) {
                    return fields[name];
                }
            } else if (msg.isSetter) {
                fields[name] = msg.positionalArguments [0];
                return;
            }
        }

        super.noSuchMethod(msg);
    }

}
