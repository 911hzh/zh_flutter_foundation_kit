import 'package:flutter_foundation_kit/flutter_foundation_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("flutter_foundation_kit exports", () {
    test("exposes settings APIs from package entrypoint", () {
      expect(AppEnvironment.development.name, "development");
      expect(_ExportedSettingsLoader(), isA<SettingsLoader>());
      expect(
        _ExportedSettings(
          packageName: "demo",
          environment: AppEnvironment.test,
        ),
        isA<SettingsBase>(),
      );
    });

    test("exposes rest client implementation APIs from package entrypoint", () {
      final restClient = RestClientImpl(
        restAdapter: _ExportedRestClientAdapter(),
        networkProxy: _ExportedNetworkProxy(),
      );

      expect(restClient, isA<RestClient>());
      expect(restClient.dio.options.baseUrl, "https://example.com");
    });
  });
}

final class _ExportedSettings implements SettingsBase {
  @override
  final String packageName;

  @override
  final AppEnvironment environment;

  const _ExportedSettings({
    required this.packageName,
    required this.environment,
  });

  @override
  Map<String, dynamic> toJson() => {
    "packageName": packageName,
    "environment": environment.name,
  };
}

final class _ExportedSettingsLoader extends SettingsLoader {
  @override
  String getPackageName() => "demo";

  @override
  AppEnvironment getEnvironment({required String packageName}) =>
      AppEnvironment.development;

  @override
  String assetPathForEnvironment(AppEnvironment environment) => "unused.json";
}

final class _ExportedRestClientAdapter extends RestClientAdapter {
  @override
  String getBaseUrl() => "https://example.com";
}

final class _ExportedNetworkProxy extends NetworkProxy {
  _ExportedNetworkProxy() : super(proxyIp: null);
}
