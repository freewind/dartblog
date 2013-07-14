import 'package:petitparser/petitparser.dart';
import 'dart:io';
import 'refParser.dart';

File routesFile = new File("conf/routes");

File targetRoutesFile = new File("lib/src/gen/routes.dart");

File controllerFile = new File("lib/src/controllers.dart");

main() {
    var routesContent = routesFile.readAsStringSync();
    var rs = new RoutesParser().start().parse(routesContent);

    if (rs is Failure) {
        var lineCol = Token.lineAndColumnOf(rs.buffer, rs.position);
        var line = lineCol[0];
        var col = lineCol[1];
        var errorLine = rs.buffer.split("\n")[line - 1];
        print("Invalid line: $errorLine");
    } else {
        var content = controllerFile.readAsStringSync();

        var defs = new ActionParser().start().parse(content).value;

        var sb = new StringBuffer();
        sb.write("""
            library _routes;

            import "../globals.dart";
            import "../controllers.dart";
            import "dart:io";

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

        _params(Rule rule) {
            var _list = defs.where((x) => x.name == rule.action).toList();
            var mDef = null;
            if (_list.length >= 1) {
                mDef = _list[0];
                return mDef.params.keys.map((k) => "_getValue(req, postData, '$k')").join(", ");
            } else {
                return "";
            }
        }

        for (Rule rule in rs.value) {

            if (rule.httpMethod == "get") {
                sb.write("""
                app.${rule.httpMethod}('${rule.path}').listen((req) {
                    request = req;
                    var postData = {};
                    var s = ${rule.action}(${_params(rule)});
                    req.response.send(s);
                });
                """);
            } else if (rule.httpMethod == "post") {
                sb.write("""
                app.${rule.httpMethod}('${rule.path}').listen((req) {
                    request = req;
                    _getPostData(req, (postData) {
                        var s = ${rule.action}(${_params(rule)});
                        req.response.send(s);
                    });
                });
                """);
            }
        }

        sb.write("}");
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
        & ref(action).flatten().trimInLine()
    ).map((each) => new Rule(each[0],each[1],each[2]));

    httpMethod() => string("*") | string("get") | string("post");

    path() => whitespace().neg().plus();

    action() => word().plus();

    commentLine() => (
        char('#') & char('\n').neg().star()
        | whitespaceInLine().star()
    );

}


class Rule {

    String httpMethod;

    String path;

    String action;

    Rule(this.httpMethod, this.path, this.action);

}


class ActionParser {
    start() => (ref(methodDef) | any()).star().map((each) => each.where((x) => x is MethodDef).toList());

    methodDef() => (
        word().plus().flatten()
        & char('(')
        & (
            word().plus().flatten().trim()
            & word().plus().flatten().trim()
        ).separatedBy(char(','), includeSeparators:false).optional([])
        & char(')')
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
}
