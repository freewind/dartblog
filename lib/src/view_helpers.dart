library _view_helpers;

import "package:intl/intl.dart";

formatDateTime(int timeInMills, [String pattern = "yyyy-MM-dd"]) {
    return new DateFormat(pattern).format(new DateTime.fromMillisecondsSinceEpoch(timeInMills));
}
