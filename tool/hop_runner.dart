library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'package:RythmDart/rythm.dart';
import '../bin/server.dart' as server;

void main() {
// addTask('test', createUnitTestTask(test.testCore));

// addTask('docs', createDartDocTask(_getLibs, linkApi: true));

    addTask('rythm', createCompileRythmTask());

//    addTask('server', runServer());

    runHop();
}

Future<List<String>> _getLibs() {
    return new Directory('lib').list()
    .where((FileSystemEntity fse) => fse is File )
    .map((File file) => file.path)
    .toList();
}


Task createCompileRythmTask() {
    return new Task.sync((TaskContext ctx) {
        print("entry rythm");

        String filename(File f) {
            var path = f.path;
            return path.split("/").last.split(".").first;
        }
        var templates = new Directory("lib/views");
        var compiler = new Compiler();
        var list = templates.listSync(recursive:false);
        list.forEach((f) {
            print("find file: $f");
            if (f is File && f.path.endsWith(".html")) {
                print("compiling: ${f}");
                String dart = compiler.compile(f);
                print(dart);
                var target = new File("lib/views/${filename(f)}.dart");
                target.writeAsStringSync(dart);
            }
        });
        return true;
    });
}

Task runServer() {
    return new Task.async((TaskContext ctx) {
        print("start...");
        server.main();
        print("end...");
        return true;
    });
}
