import 'package:patching/patching.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('replaceholder Test', () {
      // expect(awesome.isAwesome, isTrue);
      var sql = 'select * from users where id="?"';
      var stmt = replaceholder(sql);
      expect(stmt.contains('"?"'), isFalse);

      stmt = replaceholder(sql, returning: ['name', 'email']);
      expect(stmt.contains('RETURNING'), isFalse);

      sql = 'delete from users where id="?"';
      stmt = replaceholder(sql, returning: ['id', 'name', 'email']);
      expect(stmt.contains('RETURNING'), isTrue);
    });
  });
}
