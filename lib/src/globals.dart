library _globals;

import 'dart:io';
import 'package:dart-sqlite/sqlite.dart';

const PORT = 3000;
var database = new Database("db/blog.db");

Request request = null;
