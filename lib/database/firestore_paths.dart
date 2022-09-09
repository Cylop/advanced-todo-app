class FirestorePath {
  /// Users
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';

  ///TodoLists
  static String todoLists() => 'todo_lists';
  static String todoList(String listId) => 'todo_lists/$listId';

  ///Todos
  static String todos(String listId) => 'todo_lists/$listId/todos';
  static String todo(String listId, String todoId) => 'todo_lists/$listId/todos/$todoId';
}
