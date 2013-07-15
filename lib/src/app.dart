library _app;

import "../gen/routes.dart";
import "package:start/start.dart";
import "globals.dart";

void main() {
    start(public: 'web', port: PORT).then((Server app) {

        routes(app);

        app.get('/public/{<.*>path}').listen((Request req) {
        });

        app.get('/topic/:id').listen((Request req) {
        });

        app.get('/hello/:name.:lastname?').listen((request) {
            request.response
            .header('Content-Type', 'text/html; charset=UTF-8')
            .send('Hello, ${request.param('name')} ${request.param('lastname')}');
        });

        app.ws('/socket').listen((socket) {
            socket.on('ping', (data) {
                socket.send('pong');
            })
            .on('pong', (data) {
                socket.close(1000, 'requested');
            });
        });

        print("server is started at $PORT");
    }
    );
}
