import 'dart:async';
import 'dart:io';
import 'package:RythmDart/rythm.dart';
import 'package:pathos/path.dart' as path;

String TEMPLATES = "lib/views";

String TARGET = "lib/src/gen/views";

String rootLib = "_views";

const LIB_SEP = r"_$$_";

main() {
    var templatesDir = new Directory(TEMPLATES);
    var compiler = new Compiler();

    var dirs = templatesDir.listSync(recursive:true, followLinks:false).where((t) => t is Directory).toList();
    dirs.add(templatesDir);
    print("#### dirs: $dirs");

    List<List<String>> libraries = [];
    dirs.forEach((dir) {
        var items = path.split(path.relative(dir.path, from: templatesDir.path));
        libraries.add(items);
    });
    print("### libraries: $libraries");


    dirs.forEach((dir) {
        var relatives = path.split(path.relative(dir.path, from:TEMPLATES));
        print("### relatives: $relatives");

        var templateNames = [];
        var files = dir.listSync(recursive:false, followLinks:false);
        files.forEach((f) {
            print("found file: $f");
            if (f is File && f.path.endsWith(".html")) {
                print("compiling: ${f}");
                String dart = compiler.compile(f, rootLib, LIB_SEP, relatives);
                print(dart);

                var targetFileName = "${path.basenameWithoutExtension(f.path)}.dart";
                var target = new File(path.join(TARGET, path.joinAll(relatives), targetFileName));
                templateNames.add(targetFileName);
                target.directory.createSync(recursive:true);

                target.writeAsStringSync(dart);
                print("wrote to: ${target}");
            }
        });
        writeToLibrary(relatives, templateNames, libraries);
    });


}

writeToLibrary(List<String> relatives, List<String> templateNames, List<List<String>> libraries) {
    var targetLibFile = new File(path.join(TARGET, path.joinAll(relatives), "_views.dart"));

    var sb = new StringBuffer();

// library
    var libItems = [rootLib];
    libItems.addAll(relatives.where((i) => i != "."));
    sb.writeln("library ${libItems.join('.')};");

// import other view libraries
// God ~, [1] != [1] in Dart!
    libraries.where((ll) => ll.join(',') != relatives.join(',')).forEach((ll) {
        var importingLibPath = path.join(TARGET, path.joinAll(ll), "_views.dart");
        importingLibPath = path.relative(importingLibPath, from: targetLibFile.directory.path);

        var items = [rootLib];
        print(">>> items: $items");
        print(">>> ll: $ll");

        if (ll.join(',') != '.') {
            items.addAll(ll);
        }

        var asName = items.join(LIB_SEP);

        sb.writeln('import "${importingLibPath}" as $asName;');
    });

// parts
    templateNames.forEach((t) {
        sb.writeln('part "${t}";');
    });
    targetLibFile.writeAsStringSync(sb.toString());
}
