import 'dart:async';
import 'dart:io';
import 'package:RythmDart/rythm.dart';

String filename(File f) {
    var path = f.path;
    return path.split("/").last.split(".").first;
}

var TEMPLATES = "lib/views";

var TARGET = "lib/src/gen/views";

main() {
    var templates = new Directory(TEMPLATES);
    var compiler = new Compiler();
    var list = templates.listSync(recursive:false);
    var templateNames = [];
    list.forEach((f) {
        print("find file: $f");
        if (f is File && f.path.endsWith(".html")) {
            print("compiling: ${f}");
            String dart = compiler.compile(f);
            print(dart);

            var target = new File("${TARGET}/${filename(f)}.dart");
            templateNames.add("${filename(f)}.dart");
            target.writeAsStringSync(dart);
        }
    });

    var libraryFile = new File("${TARGET}/views.dart");
    var sb = new StringBuffer();
    sb.writeln("library _views;");
    templateNames.forEach((t) {
        sb.writeln('part "${t}";');
    });
    libraryFile.writeAsStringSync(sb.toString());
}
