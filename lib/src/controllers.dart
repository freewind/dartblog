library _controllers;

import 'dart:io';
import "package:intl/intl.dart";
import '../gen/views/_views.dart' as views;
import "dao.dart";

part "controllers/front.dart";
part "controllers/admins.dart";

_now() {
    return new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
}

_getPostData(req, handler(postData)) {
    print("### getPostData");
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
        print("### map: $map");
        handler(map);
    });
}
