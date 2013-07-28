library _app;

import "package:start/start.dart";
import "globals.dart";
import "controllers.dart" as ctrl;

void main() {
    start(public: 'web', port: PORT).then((Server app) {

        app.get('/').listen(ctrl.index);
        app.get('/categories').listen(ctrl.categories);
        app.get('/categories/:name').listen(ctrl.categories);
        app.get('/fix').listen(ctrl.fix);

        app.get('/initData').listen(ctrl.initData);
        app.get('/write').listen(ctrl.writePage);
        app.get('/topic/:id').listen(ctrl.topic);
        app.get('/categories').listen(ctrl.categories);
        app.get('/categories/:name').listen(ctrl.categories);

        app.post('/write').listen(ctrl.adminSaveTopic);
        app.get('/admin/login').listen(ctrl.adminLogin);
        app.post('/admin/login').listen(ctrl.adminDoLogin);

        app.get('/admin/topics').listen(ctrl.adminTopics);
        app.get('/admin/editTopic/:id').listen(ctrl.adminEditTopic);
        app.get('/admin/deleteTopic/:id').listen(ctrl.adminDeleteTopic);
        app.get('/admin/categories').listen(ctrl.adminCategories);
        app.get('/admin/deleteCategory').listen(ctrl.adminDeleteCategory);
        app.post('/admin/createCategory').listen(ctrl.adminCreateCategory);
        app.get('/admin/editCategory/:id').listen(ctrl.adminEditCategory);
        app.post('/admin/editCategory').listen(ctrl.adminUpdateCategory);

        app.post('/pasteImage').listen(ctrl.pasteImage);
        app.post('/upload').listen(ctrl.uploadFile);

        app.get('/rss').listen(ctrl.rss);
        app.get('/rss.xml').listen(ctrl.rss);

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
    });
}
