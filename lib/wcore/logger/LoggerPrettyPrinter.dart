import 'package:logger/logger.dart' as logg;

class LoggerPrettyPrinter extends logg.PrettyPrinter {
  List<String> tag;

  LoggerPrettyPrinter({this.tag = const []})
    : super(
        stackTraceBeginIndex: 0,
        methodCount: 3,
        errorMethodCount: 1,
        lineLength: 120,
        colors: false,
        printEmojis: true,
        printTime: true,
        excludeBox: const {},
        noBoxingByDefault: true,
        excludePaths: const [
          "package:flutter_foundation_kit/wcore/logger/",
          "/flutter_foundation_kit/lib/wcore/logger/",
          "lib/wcore/logger/",
        ],
      );

  @override
  List<String> log(logg.LogEvent event) {
    var list = super.log(event);
    final timeIndex = list.indexWhere(_isTimeLine);
    final source = timeIndex > 0 ? _wrapSource(_normalizeSource(list.first)) : "";
    final time = timeIndex >= 0 ? list[timeIndex] : "";
    final messageLines = timeIndex >= 0 ? list.sublist(timeIndex + 1) : list;

    var icon = "";
    var messages = [];
    for (var i = 0; i < messageLines.length; i++) {
      var message = messageLines[i];
      if (message.length > 2) {
        icon = message.substring(0, 2);
        message = message.replaceRange(0, 2, "");
      }
      messages.add(message);
    }

    var tagStr = "";
    if (tag.isNotEmpty) {
      tagStr = "${tag.join(",")} ";
    }

    var out = "$icon$time $source $tagStr${messages.join("\n")}";
    return [out];
  }
}

bool _isTimeLine(String line) {
  return RegExp(r"^\d{2}:\d{2}:\d{2}\.\d{3} \(\+\d").hasMatch(line);
}

String _normalizeSource(String source) {
  final normalized = source.replaceFirst(RegExp(r"^#\d+\s+"), "");
  final locationMatch = RegExp(r"\(([^)]+)\)").firstMatch(normalized);
  final location = locationMatch?.group(1) ?? normalized;
  return _normalizeLocation(location);
}

String _wrapSource(String source) {
  return source.isEmpty ? "" : "[$source]";
}

String _normalizeLocation(String location) {
  final fileUriPrefix = "file://";
  if (location.startsWith(fileUriPrefix)) {
    return _toWorkspaceRelativePath(location.substring(fileUriPrefix.length));
  }

  const packagePrefix = "package:";
  if (location.startsWith(packagePrefix)) {
    final packagePath = location.substring(packagePrefix.length);
    final slashIndex = packagePath.indexOf("/");
    if (slashIndex < 0) {
      return packagePath;
    }
    final packageName = packagePath.substring(0, slashIndex);
    final packageFilePath = packagePath.substring(slashIndex + 1);
    if (packageName == "example") {
      return "lib/$packageFilePath";
    }
    if (packageName == "flutter_foundation_kit") {
      return "../lib/$packageFilePath";
    }
    return packagePath;
  }

  return location;
}

String _toWorkspaceRelativePath(String location) {
  const exampleLibPath = "/packages/flutter_foundation_kit/example/lib/";
  final exampleLibIndex = location.indexOf(exampleLibPath);
  if (exampleLibIndex >= 0) {
    return "lib/${location.substring(exampleLibIndex + exampleLibPath.length)}";
  }

  const packageLibPath = "/packages/flutter_foundation_kit/lib/";
  final packageLibIndex = location.indexOf(packageLibPath);
  if (packageLibIndex >= 0) {
    return "../lib/${location.substring(packageLibIndex + packageLibPath.length)}";
  }

  const packageRoot = "/packages/flutter_foundation_kit/";
  final packageRootIndex = location.indexOf(packageRoot);
  if (packageRootIndex >= 0) {
    return location.substring(packageRootIndex + packageRoot.length);
  }

  final testIndex = location.indexOf("/test/");
  if (testIndex >= 0) {
    return location.substring(testIndex + 1);
  }

  final libIndex = location.indexOf("/lib/");
  if (libIndex >= 0) {
    return location.substring(libIndex + 1);
  }

  return location;
}
