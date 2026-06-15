import 'package:flutter_foundation_kit/api/RestResponse.dart';
import 'package:flutter_foundation_kit/cutil/Codable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RestResponse", () {
    test("test rest response value ", () {
      final restResponse = RestResponse<Map<String, dynamic>>(
        statusCode: 200,
        message: "OK",
        data: {"hello": "world"},
        headers: {"Content-Type": "text/plain"},
      );
      expect(restResponse.statusCode, 200);
      expect(restResponse.message, "OK");
      expect(restResponse.data, {"hello": "world"});
      expect(restResponse.headers, {"Content-Type": "text/plain"});
    });
    test("test rest response to model", () async {
      final restResponse = Future.value(
        RestResponse<Map<String, dynamic>>(
          statusCode: 200,
          message: "OK",
          data: {"hello": "world"},
          headers: {"Content-Type": "text/plain"},
        ),
      );
      final model = await restResponse.toModel(
        (json) => HelloModel.fromJson(json),
      );
      print("222 ${model.data.toJson()}");
      expect(model.statusCode, 200);
      expect(model.message, "OK");
      expect(model.data.hello, "world");
      expect(model.isOk(), isTrue);
      expect(model.headers, {"Content-Type": "text/plain"});
    });
    test("test rest response to model sub thread", () async {
      final restResponse = Future.value(
        RestResponse<Map<String, dynamic>>(
          statusCode: 200,
          message: "OK",
          data: {"hello": "world"},
          headers: {"Content-Type": "text/plain"},
        ),
      );
      final model = await restResponse.toModelSubThread(
        (json) => HelloModel.fromJson(json),
      );
      print("111${model.data.hello}");
      expect(model.statusCode, 200);
      expect(model.message, "OK");
      expect(model.data.hello, "world");
      expect(model.isOk(), isTrue);
      expect(model.headers, {"Content-Type": "text/plain"});
    });
    test("test rest response to map", () async {
      final restResponse = Future.value(
        RestResponse<Map<String, dynamic>>(
          statusCode: 200,
          message: "OK",
          data: {"Hello": "world"},
          headers: {"Content-Type": "text/plain"},
        ),
      );
      final map = await restResponse.toMap();
      expect(map.statusCode, 200);
      expect(map.message, "OK");
      expect(map.data, {"Hello": "world"});
      expect(map.isOk(), isTrue);
      expect(map.headers, {"Content-Type": "text/plain"});
    });
    test("test rest response extract model", () async {
      final restResponse = Future.value(
        RestResponse<Map<String, dynamic>>(
          statusCode: 200,
          message: "OK",
          data: {"hello": "world"},
          headers: {"Content-Type": "text/plain"},
        ),
      );
      final model = await restResponse.extractModel(
        (json) => HelloModel.fromJson(json),
      );
      expect(model.statusCode, 200);
      expect(model.message, "OK");
      expect(model.data.toJson(), {"hello": "world"});
      expect(model.data.hello, "world");
      expect(model.isOk(), isTrue);
      expect(model.headers, {"Content-Type": "text/plain"});
    });
    test("test rest response extract model sub thread", () async {
      final restResponse = Future.value(
        RestResponse<Map<String, dynamic>>(
          statusCode: 200,
          message: "OK",
          data: {"hello": "world"},
          headers: {"Content-Type": "text/plain"},
        ),
      );
      final model = await restResponse.extractModelSubThread(
        (json) => HelloModel.fromJson(json),
      );
      expect(model.statusCode, 200);
      expect(model.message, "OK");
      expect(model.data.toJson(), {"hello": "world"});
      expect(model.data.hello, "world");
      expect(model.isOk(), isTrue);
      expect(model.headers, {"Content-Type": "text/plain"});
    });
  });
}

class HelloModel implements Codable {
  final String hello;
  HelloModel({required this.hello});
  factory HelloModel.fromJson(Map<String, dynamic> json) {
    return HelloModel(hello: json["hello"] as String? ?? "");
  }
  @override
  Map<String, dynamic> toJson() => {"hello": hello};
}
