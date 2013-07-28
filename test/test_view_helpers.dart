library test_view_helpers;

import "package:unittest/unittest.dart";
import "../lib/src/view_helpers.dart" as helper;

main() {
  test("format with default pattern", (){
    expect( helper.formatDateTime(1374991818755), "2013-07-28");
    expect( helper.formatDateTime(1374991818755, "yyyy-MM-dd HH:mm:ss"), "2013-07-28 14:10:18");
  });
}