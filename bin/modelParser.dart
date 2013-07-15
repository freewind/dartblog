import 'package:petitparser/petitparser.dart';
import 'dart:io';
import 'refParser.dart';

var MODEL_FILE = new File("lib/src/models.dart");

var TARGET_FILE = new File("lib/gen/dao.dart");

main() {
    var content = MODEL_FILE.readAsStringSync();
    var rs = new ModelParser().start().parse(content);
    if (rs is Success) {
        List<Table> tables = rs.value;

        var sb = new StringBuffer();
        sb.write("""
            part of app;

            var c = new Database("/db/temp.db");
        """);

        tables.forEach((table) {
            sb.write("""

            class ${table.name}Dao {

                // get
                ${table.name} get(String id) {
                    Row rs = c.first("SELECT * from ${table.name} where id=?", [id]);
                    return row2model(rs);
                }

                // list
                List<${table.name}> list() {
                    var list = [];
                    c.execute("SELECT * FROM ${table.name}", callback: (row) {
                        list.add(row2model(row));
                    });
                    return list;
                }

                // insert
                ${table.name} insert(${table.name} m) {
                    m.id = new Uuid().v4();
                    var sql = '''insert into ${table.name} (
                        ${_columnsOf(table)}
                    ) values (
                        ${_placeHoldersOf(table)}
                    )''';
                    var params = [
                        ${table.map.keys.map((k) => "m.$k").join(",")}
                    ];
                    c.execute(sql, params);
                    return m;
                }

                // update
                bool update(${table.name} m) {
                    var sql = "update ${table.name} set ${_updateSql(table)}";
                    var params = [${_updateParams(table)}];
                    return c.execute(sql, params) == 1;
                }

                // row2model
                ${table.name} row2model(Row row) {
                    var m = new ${table.name}();
                    ${table.map.keys.map((k) => "m.$k = row['$k'];").join("\n")}
                    return m;
                }
            }
            """);
        });

        var code = sb.toString();


        TARGET_FILE.writeAsStringSync(code);

        print("write to file: $TARGET_FILE");

    } else {
        print("Parse models.dart failed");
        print(rs);
    }
}

String _columnsOf(Table table) {
    return table.map.keys.map((k) => "'$k'").join(",");
}

String _placeHoldersOf(Table table) {
    return table.map.keys.map((_) => "?").join(",");
}

String _updateSql(Table table) {
    var sb = new StringBuffer();
    sb.write("update ${table.name} set ");
    sb.write(table.map.keys.where((k) => k != 'id').map((k) => "$k=?").join(", "));
    sb.write(" where id=?");
    return sb.toString();
}

String _updateParams(Table table) {
    var keys = table.map.keys.toList();
    keys.remove("id");
    keys.add("id");
    return keys.map((k) => "m.$k").join(", ");
}

class ModelParser {
    start() => (
        ref(table)
        | any()
    ).star()
    .map((each) => each.where((x) => x is Table).toList());

    table() => (
        string("class").trim()
        & ref(name)
        & char('{').trim()
        & (
            ref(name)
            & ref(name)
            & char(';')
        ).star()
        & char('}').trim()
    ).permute([1, 3])
    .map((each) {
        var map = {
        };
        for (var item in each[1]) {
            map[item[1]] = item [0];
        }
        return new Table(each[0], map);
    });

    name() => word().plus().trim().flatten().map((x) => x.trim());
}


class Table {
    String name;

    Map<String, String> map;

    Table(this.name, this.map);
}
