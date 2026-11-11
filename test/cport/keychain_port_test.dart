import 'package:flutter_foundation_kit/cport/KeychainPort.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeychainPort', () {
    test('stores nullable json map values', () async {
      final keychainPort = TestKeychainPort();

      await keychainPort.setValue<String, Map<String, dynamic>>('auth', {
        'token': 'abc',
        'expiresIn': 3600,
      });

      expect(
        await keychainPort.getValue<String, Map<String, dynamic>>('auth'),
        {'token': 'abc', 'expiresIn': 3600},
      );

      await keychainPort.setValue<String, Map<String, dynamic>>('auth', null);

      expect(
        await keychainPort.getValue<String, Map<String, dynamic>>('auth'),
        isNull,
      );
    });
  });
}

class TestKeychainPort extends KeychainPort {
  TestKeychainPort() : super('test_keychain');

  final Map<String, Map<String, dynamic>?> _values = {};

  @override
  Future<V?> getValue<K, V>(K key) async {
    return _values[key.toString()] as V?;
  }

  @override
  Future<void> setValue<K, V>(K key, V? value) async {
    _values[key.toString()] = value as Map<String, dynamic>?;
  }

  @override
  Future<void> delete<K>(K key) async {
    _values.remove(key.toString());
  }
}
