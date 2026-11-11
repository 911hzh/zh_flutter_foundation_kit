import 'package:flutter_foundation_kit/cutil/Codable.dart';
import 'package:flutter_foundation_kit/infra/PreferenceRepositoryImpl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PreferenceRepositoryImpl', () {
    test('stores nullable json map values', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = PreferenceRepositoryImpl('demo');

      await repository.setValue<String, Map<String, dynamic>>('profile', {
        'userId': 'u-1',
        'name': 'Flutter',
      });

      expect(
        await repository.getValue<String, Map<String, dynamic>>('profile'),
        {'userId': 'u-1', 'name': 'Flutter'},
      );
    });

    test('stores codable values as json maps', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = PreferenceRepositoryImpl('demo');

      await repository.setValue<String, _DemoCodable>(
        'codable',
        const _DemoCodable(id: 'u-1', count: 3),
      );

      expect(
        await repository.getValue<String, Map<String, dynamic>>('codable'),
        {'id': 'u-1', 'count': 3},
      );
    });

    test('rejects unsupported object values', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = PreferenceRepositoryImpl('demo');

      expect(
        () => repository.setValue<String, _UnsupportedObject>(
          'unsupported',
          _UnsupportedObject(),
        ),
        throwsArgumentError,
      );
    });

    test(
      'stores primitive values using shared preferences native types',
      () async {
        SharedPreferences.setMockInitialValues({});
        final repository = PreferenceRepositoryImpl('demo');

        await repository.setValue<String, String>('name', 'Flutter');
        await repository.setValue<String, int>('launchCount', 3);
        await repository.setValue<String, bool>('enabled', true);
        await repository.setValue<String, double>('ratio', 0.5);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('demo.name'), 'Flutter');
        expect(prefs.getInt('demo.launchCount'), 3);
        expect(prefs.getBool('demo.enabled'), isTrue);
        expect(prefs.getDouble('demo.ratio'), 0.5);

        expect(await repository.getValue<String, String>('name'), 'Flutter');
        expect(await repository.getValue<String, int>('launchCount'), 3);
        expect(await repository.getValue<String, bool>('enabled'), isTrue);
        expect(await repository.getValue<String, double>('ratio'), 0.5);
      },
    );

    test('delete removes stored value', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = PreferenceRepositoryImpl('demo');

      await repository.setValue<String, Map<String, dynamic>>('profile', {
        'userId': 'u-1',
      });
      await repository.delete('profile');

      expect(
        await repository.getValue<String, Map<String, dynamic>>('profile'),
        isNull,
      );
    });

    test('null value removes stored value', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = PreferenceRepositoryImpl('demo');

      await repository.setValue<String, Map<String, dynamic>>('profile', {
        'userId': 'u-1',
      });
      await repository.setValue<String, Map<String, dynamic>>('profile', null);

      expect(
        await repository.getValue<String, Map<String, dynamic>>('profile'),
        isNull,
      );
    });
  });
}

class _DemoCodable extends Codable {
  final String id;
  final int count;

  const _DemoCodable({required this.id, required this.count});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'count': count};
  }
}

class _UnsupportedObject {}
