library _controllers;

import 'dart:io';
import 'dart:json' as json;
import "package:intl/intl.dart";
import 'package:crypto/crypto.dart';
import 'helper.dart';
import '../gen/views/_views.dart' as views;
import "dao.dart";

part "controllers/utils.dart";
part "controllers/front.dart";
part "controllers/admins.dart";

_now() {
    return new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
}

_getBody(req, handler(String body)) {
    req.input.transform(new StringDecoder()).toList().then((data) {
        var body = data.join('');
        handler(body);
    });
}

_getPostData(req, handler(postData)) {
    _getBody(req, (body) {
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
