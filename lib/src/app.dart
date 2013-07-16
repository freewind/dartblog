library _app;

import "package:start/start.dart";
import "globals.dart";
import "controllers.dart" as ctrl;

void main() {
    start(public: 'web', port: PORT).then((Server app) {

        app.get('/').listen(ctrl.index);
        app.get('/write').listen(ctrl.writePage);
        app.post('/write').listen(ctrl.write);

        app.get('/topic/:id').listen(ctrl.topic);

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
