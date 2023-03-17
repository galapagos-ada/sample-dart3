import 'package:dart3_sample/feature/local_data/todo_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TodosDatabase db;

  setUp(() {
    db = TodosDatabase.test(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('fetchSingle', () {
    Future testInsert(Todo todo) async {
      await db.into(db.todos).insert(
            TodosCompanion.insert(
              title: todo.title,
              content: todo.content,
              status: todo.status,
              updatedAt: todo.updatedAt,
            ),
          );
    }

    test('指定したIDのTodoが取得できること', () async {
      const expectId = 1; // 1から自動採番される
      final expectTodo = Todo(
        id: expectId,
        title: 'テストタイトル',
        content: 'テスト内容',
        status: 'InProgress',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      await testInsert(expectTodo);

      final actual = await db.fetchSingle(expectId);
      expect(actual, expectTodo);
    });

    test('存在しないIDを指定した際にStateErrorを吐くこと', () async {
      const expectId = 1;
      final expectTodo = Todo(
        id: expectId,
        title: 'テストタイトル',
        content: 'テスト内容',
        status: 'InProgress',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      await testInsert(expectTodo);

      expect(() async => await db.fetchSingle(999), throwsStateError);
    });
  });

  group('upsert', () {
    TodosCompanion toCompanion(Todo todo) => TodosCompanion(
          title: Value(todo.title),
          content: Value(todo.content),
          status: Value(todo.status),
          updatedAt: Value(todo.updatedAt),
        );

    TodosCompanion toUniqueCompanion(Todo todo) => TodosCompanion(
          id: Value(todo.id),
          title: Value(todo.title),
          content: Value(todo.content),
          status: Value(todo.status),
          updatedAt: Value(todo.updatedAt),
        );

    test('IDが存在しない場合はIDが自動採番で新規登録できること', () async {
      final firstExpectTodo = Todo(
        id: 1,
        title: 'テストタイトル',
        content: 'テスト内容',
        status: 'InProgress',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      await db.upsert(toCompanion(firstExpectTodo));
      final firstTodo = await db.select(db.todos).getSingle();
      expect(firstTodo, firstExpectTodo);

      final secondExpectTodo = Todo(
        id: -1,
        title: 'テストタイトル2',
        content: 'テスト内容2',
        status: 'NotStarted',
        updatedAt: DateTime.parse('2023-03-12 10:24:30'),
      );
      await db.upsert(toCompanion(secondExpectTodo));
      final secondTodo = await (db.select(db.todos)
            ..where((todos) => todos.id.equals(2)))
          .getSingle();
      expect(secondTodo.id, 2);
      expect(secondTodo.title, secondExpectTodo.title);
      expect(secondTodo.content, secondExpectTodo.content);
      expect(secondTodo.status, secondExpectTodo.status);
      expect(secondTodo.updatedAt, secondExpectTodo.updatedAt);
    });

    test('IDが存在する場合は内容が更新されること', () async {
      Future testInsert(Todo todo) async {
        await db.into(db.todos).insert(
              TodosCompanion.insert(
                title: todo.title,
                content: todo.content,
                status: todo.status,
                updatedAt: todo.updatedAt,
              ),
            );
      }

      await testInsert(
        Todo(
          id: 1,
          title: 'title',
          content: 'content',
          status: 'status',
          updatedAt: DateTime.parse('2023-03-12 10:24:29'),
        ),
      );

      final expectedTodo = Todo(
        id: 1,
        title: 'updatedTitle',
        content: 'updatedContent',
        status: 'updatedStatis',
        updatedAt: DateTime.parse('2023-03-13 11:11:11'),
      );

      db.upsert(toUniqueCompanion(expectedTodo));
      final todo = await db.select(db.todos).getSingle();
      expect(todo, expectedTodo);
    });
  });

  group('deleteSingle', () {
    Future testInsert(Todo todo) async {
      await db.into(db.todos).insert(
            TodosCompanion.insert(
              title: todo.title,
              content: todo.content,
              status: todo.status,
              updatedAt: todo.updatedAt,
            ),
          );
    }

    Future<int> count() async => (await db.select(db.todos).get()).length;

    test('一致するIDがある場合は削除する', () async {
      final target = Todo(
        id: 1,
        title: 'title',
        content: 'content',
        status: 'status',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      await testInsert(target);
      expect(await count(), 1);

      db.deleteSingle(target.id);
      expect(await count(), 0);
    });

    test('一致するIDがない場合は何も起きない', () async {
      final target = Todo(
        id: 1,
        title: 'title',
        content: 'content',
        status: 'status',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      await testInsert(target);
      expect(await count(), 1);

      db.deleteSingle(999);
      expect(await count(), 1);
    });
  });

  group('watchAll', () {
    Future testInsert(Todo todo) async {
      await db.into(db.todos).insert(
            TodosCompanion.insert(
              title: todo.title,
              content: todo.content,
              status: todo.status,
              updatedAt: todo.updatedAt,
            ),
          );
    }

    Future testUpdate(Todo todo) async {
      await (db.update(db.todos)..where((tbl) => tbl.id.equals(todo.id)))
          .write(todo);
    }

    Future testDelete(int id) async {
      await (db.delete(db.todos)..where((tbl) => tbl.id.equals(id))).go();
    }

    test('Todo追加時に最新の内容が取得できること', () async {
      final firstTodo = Todo(
        id: 1,
        title: 'title1',
        content: 'content1',
        status: 'status1',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      final secondTodo = Todo(
        id: 2,
        title: 'title2',
        content: 'content2',
        status: 'status2',
        updatedAt: DateTime.parse('2023-03-12 10:24:30'),
      );
      await testInsert(firstTodo);

      final expectation = expectLater(
        db.watchAll(),
        emitsInOrder(
          [
            [firstTodo],
            [firstTodo, secondTodo],
          ],
        ),
      );

      await testInsert(secondTodo);
      await expectation;
    });

    test('Todo更新時に最新の内容が取得できること', () async {
      final firstTodo = Todo(
        id: 1,
        title: 'title1',
        content: 'content1',
        status: 'status1',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      final secondTodo = Todo(
        id: 2,
        title: 'title2',
        content: 'content2',
        status: 'status2',
        updatedAt: DateTime.parse('2023-03-12 10:24:30'),
      );
      await testInsert(firstTodo);
      await testInsert(secondTodo);

      final updatedTodo = Todo(
        id: 1,
        title: 'updated',
        content: 'updated',
        status: 'updated',
        updatedAt: DateTime.parse('2023-03-12 11:11:11'),
      );

      final expectation = expectLater(
        db.watchAll(),
        emitsInOrder(
          [
            [firstTodo, secondTodo],
            [updatedTodo, secondTodo],
          ],
        ),
      );
      testUpdate(updatedTodo);
      await expectation;
    });

    test('Todo削除時に最新の内容が取得できること', () async {
      final firstTodo = Todo(
        id: 1,
        title: 'title1',
        content: 'content1',
        status: 'status1',
        updatedAt: DateTime.parse('2023-03-12 10:24:29'),
      );
      final secondTodo = Todo(
        id: 2,
        title: 'title2',
        content: 'content2',
        status: 'status2',
        updatedAt: DateTime.parse('2023-03-12 10:24:30'),
      );
      await testInsert(firstTodo);
      await testInsert(secondTodo);

      final expectation = expectLater(
        db.watchAll(),
        emitsInOrder(
          [
            [firstTodo, secondTodo],
            [secondTodo],
          ],
        ),
      );
      testDelete(1);
      await expectation;
    });
  });
}
