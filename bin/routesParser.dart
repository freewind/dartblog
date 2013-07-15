import 'dart:io';
import 'package:petitparser/petitparser.dart';
import 'package:pathos/path.dart' as path;
import 'refParser.dart';

File routesFile = new File("conf/routes");

File targetRoutesFile = new File("lib/gen/routes.dart");

Directory controllersDir = new Directory("lib/src");

const CTRL_LIB_NAME = "_controllers";

main() {
    var routesContent = routesFile.readAsStringSync();
    var ruleRs = new RoutesParser().start().parse(routesContent);

    if (ruleRs is Failure) {
        var lineCol = Token.lineAndColumnOf(ruleRs.buffer, ruleRs.position);
        var line = lineCol[0];
        var col = lineCol[1];
        var errorLine = ruleRs.buffer.split("\n")[line - 1];
        print("Invalid line: $errorLine");
    } else {

// libNameItems -> actionMethods
        Map<File, List<String>> libItemMap = {
        };
        Map<File, List<MethodDef>> actionMap = {
        };
        var files = controllersDir.listSync(recursive: true, followLinks: false);
        for (File file in files) {
            print("### parse controller: $file");

            var content = file.readAsStringSync();
            var libParser = new LibraryParser();
            var libRs = libParser.start().parse(content);
            if (libRs is Success) {
                print("### success");
                List<String> names = libRs.value;
                var defs = new ActionParser().start().parse(content).value;
                libItemMap[file] = names;
                actionMap[file] = defs;
            }
        }

        importControllers() {
// import "../src/controllers.dart";
            return libItemMap.keys.map((k) {
                var v = libItemMap[k];
                print(k.path);
                print(targetRoutesFile.path);
                var relaPath = path.relative(k.path, from:targetRoutesFile.directory.path);
                var asName = v.join(r"_$$_");
                return "import '${relaPath}' as ${asName};";
            }).join('\n');
        }

        var sb = new StringBuffer();
        sb.write("""
            library _routes;

            import "dart:io";
            import "../src/globals.dart";
            ${importControllers()}

            _getPostData(req, handler(postData)) {
                req.input.transform(new StringDecoder()).toList().then((data) {
                    var body = data.join('');
                    var map = {
                    };
                    body.split("&").forEach((kv) {
                        var k_v = kv.split("=");
                        var k = Uri.decodeQueryComponent(k_v[0]);
                        var v = Uri.decodeQueryComponent(k_v[1]);
                        map[k] = v;
                    });
                    handler(map);
                });
            }

            _getValue(req, postData, key) {
                var v1 = postData[key];
                var v2 = req.param(key);
                return v1 != null ? v1 : v2;
            }

            routes(app) {
        """);

        List<MethodDef> _findMethodDefsByRule(Rule rule) {
            List<String> actions = [CTRL_LIB_NAME];
            actions.addAll(rule.actions);
            actions.removeLast();

            var file = null;
            for (File k in libItemMap.keys) {
                var v = libItemMap[k];
                if (actions.join(',') == v.join(',')) {
                    file = k;
                    break;
                }
            }
            return file == null ? [] : actionMap[file];
        }

        _params(Rule rule) {
            var defs = _findMethodDefsByRule(rule);
            print("#### defs for rule: $defs");
            var _list = defs.where((def) => def.name == rule.actions.last).toList();
            var mDef = null;
            if (_list.length >= 1) {
                mDef = _list[0];
                return mDef.params.keys.map((k) => "_getValue(req, postData, '$k')").join(", ");
            } else {
                return "";
            }
        }

        for (Rule rule in ruleRs.value) {
            _funcInvocation() {
                var actions = [CTRL_LIB_NAME];
                actions.addAll(rule.actions);
                var funcName = actions.removeLast();
                return "${actions.join(r'_$$_')}.$funcName";
            }
            if (rule.httpMethod == "get") {
                sb.writeln("""
                app.${rule.httpMethod}('${rule.path}').listen((req) {
                    request = req;
                    var postData = {};
                    var s = ${_funcInvocation()}(${_params(rule)});
                    req.response.send(s);
                });
                """);
            } else if (rule.httpMethod == "post") {
                sb.writeln("""
                app.${rule.httpMethod}('${rule.path}').listen((req) {
                    request = req;
                    _getPostData(req, (postData) {
                        var s = ${_funcInvocation()}(${_params(rule)});
                        req.response.send(s);
                    });
                });
                """);
            }
        }

// more
        for (File file in libItemMap.keys) {
            List<String> libItems = libItemMap[file];
            List<MethodDef> mDefs = actionMap[file];
            print(mDefs);
            for (var def in mDefs.where((m) => m.params.isEmpty)) {
                List<String> pathItems = _copyList(libItems);
                pathItems.add(def.name);
                pathItems.removeAt(0);

                sb.writeln("""
                app.get('/${pathItems.join("/")}').listen((req) {
                  var s = ${libItems.join(r'_$$_')}.${def.name}();
                  req.response.send(s);
                });
                """);
            }
        }

        sb.writeln("}");
        targetRoutesFile.writeAsStringSync(sb.toString());
        print("wrote to file: $targetRoutesFile");
    }
}

class RoutesParser {

    start() => (
        (
            ref(line)
            | commentLine()
        ).separatedBy(char('\n'), includeSeparators:false)
    ).end('Found invalid line')
    .map((each) => each.where((x) => x is Rule).toList());


    line() => (
        ref(httpMethod).flatten().trimInLine()
        & ref(path).flatten().trimInLine()
        & ref(actions).trimInLine()
    ).map((each) => new Rule(each[0], each[1], each[2]));

    httpMethod() => string("*") | string("get") | string("post");

    path() => whitespace().neg().plus();

    actions() => (
        word().plus().flatten().separatedBy(char('.'), includeSeparators: false)
    );

    commentLine() => (
        char('#') & char('\n').neg().star()
        | whitespaceInLine().star()
    );

}


class Rule {

    String httpMethod;

    String path;

    List<String> actions;

    Rule(this.httpMethod, this.path, this.actions);

}


class ActionParser {
    start() => (ref(methodDef) | any()).star().map((each) => each.where((x) => x is MethodDef && !x.name.startsWith('_')).toList());

    methodDef() => (
        word().plus().flatten()
        & char('(')
        & (
            word().plus().flatten().trim()
            & word().plus().flatten().trim()
        ).separatedBy(char(','), includeSeparators:false).optional([])
        & char(')')
        & char('{').trim()
    ).permute([0, 2])
    .map((each) {
        var map = {
        };
        List list = each[1];
        for (var item in list) {
            map[item[1]] = item[0];
        }
        return new MethodDef(each[0], map);
    });
}


class MethodDef {
    String name;

    Map<String, String> params;

    MethodDef(this.name, this.params);

    toString() => "$name($params)";
}


class LibraryParser {
    start() => (
        string("library").flatten().trim()
        & string(CTRL_LIB_NAME)
        & (
            char('.').trim()
            & ref(name).separatedBy(char('.').trim(), includeSeparators:false)
        ).pick(1).optional([])
        & char(';')
    ).permute([1, 2])
    .map((each) {
        var names = [each[0]];
        names.addAll(each[1]);
        print("### names: $names");
        return names;
    });

    name() => word().plus().flatten();
}


_copyList(List list) {
    var newList = [];
    newList.addAll(list);
    return newList;
}
