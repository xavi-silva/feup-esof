import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {
  bool _emailVerified = false;
  @override
  Future<void> sendEmailVerification(
          [ActionCodeSettings? actionCodeSettings]) =>
      super.noSuchMethod(
        Invocation.method(#sendEmailVerification, []),
        returnValue: Future.value(),
      );
  set emailVerified(bool value) {
    _emailVerified = value;
  }

  @override
  bool get emailVerified => _emailVerified;
  @override
  Future<void> reload() => super.noSuchMethod(
        Invocation.method(#reload, []),
        returnValue: Future.value(),
      );
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  MockUser? _currentUser;
  MockFirebaseAuth(this._currentUser);

  @override
  User? get currentUser => _currentUser;

  set currentUser(User? user) {
    _currentUser = user as MockUser?;
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
        Invocation.method(#signInWithEmailAndPassword, [email, password]),
        returnValue: Future.value(MockUserCredential()),
      );

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
        Invocation.method(#signInWithEmailAndPassword, [email, password]),
        returnValue: Future.value(MockUserCredential()),
      );

  @override
  Future<void> sendPasswordResetEmail(
          {required String? email, ActionCodeSettings? actionCodeSettings}) =>
      super.noSuchMethod(
        Invocation.method(#sendPasswordResetEmail, [email]),
        returnValue: Future.value(),
      );
}

void main() {
  late MockUser mockUser;
  late MockFirebaseAuth mockAuth;
  late AuthController authController;

  setUp(() {
    mockUser = MockUser();
    mockAuth = MockFirebaseAuth(mockUser);
    authController = AuthController(mockAuth);
  });

  test("Test signIn function", () async {
    final mockUserCredential = MockUserCredential();
    when(mockAuth.signInWithEmailAndPassword(email: any, password: any))
        .thenAnswer((_) async => mockUserCredential);
    await authController.signIn("johndoe@mail.pt", "johnpassword");
    verify(mockAuth.signInWithEmailAndPassword(
            email: "johndoe@mail.pt", password: "johnpassword"))
        .called(1);
    verifyNoMoreInteractions(mockAuth);
  });

  test("Test signIn function with error", () async {
    when(mockAuth.signInWithEmailAndPassword(email: any, password: any))
        .thenThrow(FirebaseAuthException(code: 'invalid-email'));
    expect(() async => await authController.signIn("testEmail", "testPassword"),
        throwsA(isA<FirebaseAuthException>()));
    verify(mockAuth.signInWithEmailAndPassword(
            email: "testEmail", password: "testPassword"))
        .called(1);
    verifyNoMoreInteractions(mockAuth);
  });
  test("Test signUp function", () async {
    final mockUserCredential = MockUserCredential();
    when(mockAuth.createUserWithEmailAndPassword(email: any, password: any))
        .thenAnswer((_) async => mockUserCredential);
    await authController.signUp("johndoe@mail.pt", "johnpassword");
    verify(mockAuth.createUserWithEmailAndPassword(
            email: "johndoe@mail.pt", password: "johnpassword"))
        .called(1);
    verifyNoMoreInteractions(mockAuth);
  });

  test("Test signUp function with error", () async {
    when(mockAuth.createUserWithEmailAndPassword(email: any, password: any))
        .thenThrow(FirebaseAuthException(code: 'invalid-email'));
    expect(() async => await authController.signUp("testEmail", "testPassword"),
        throwsA(isA<FirebaseAuthException>()));
    verify(mockAuth.createUserWithEmailAndPassword(
            email: "testEmail", password: "testPassword"))
        .called(1);
  });

  test("Test sendVerificationEmail function", () async {
    when(mockUser.sendEmailVerification()).thenAnswer((_) => Future.value());
    await authController.sendVerificationEmail();
    expect(mockAuth.currentUser, mockUser);
    verify(mockUser.sendEmailVerification()).called(1);
    verifyNoMoreInteractions(mockUser);
    verifyNoMoreInteractions(mockAuth);
  });

  test("Test isEmailVerified function", () async {
    expect(mockAuth.currentUser, mockUser);
    when(mockUser.reload()).thenAnswer((_) => Future.value());
    mockUser.emailVerified = true;
    final isVerified = await authController.isEmailVerified();
    verify(mockUser.reload()).called(1);
    expect(isVerified, true);
    mockUser.emailVerified = false;
    final isVerified2 = await authController.isEmailVerified();
    verify(mockUser.reload()).called(1);
    expect(isVerified2, false);
    verifyNoMoreInteractions(mockUser);
    verifyNoMoreInteractions(mockAuth);
  });

  test("Test resetPassword function", () async {
    when(mockAuth.sendPasswordResetEmail(email: any))
        .thenAnswer((_) async => Future.value());
    await authController.resetPassword("johndoe@mail.pt");
    verify(mockAuth.sendPasswordResetEmail(email: "johndoe@mail.pt")).called(1);
    verifyNoMoreInteractions(mockAuth);
  });

  test("Test resetPassword function with error", () async {
    when(mockAuth.sendPasswordResetEmail(email: any))
        .thenThrow(FirebaseAuthException(code: 'invalid-email'));
    expect(() async => await authController.resetPassword("testEmail"),
        throwsA(isA<FirebaseAuthException>()));
    verify(mockAuth.sendPasswordResetEmail(email: "testEmail")).called(1);
    verifyNoMoreInteractions(mockAuth);
  });

  test("Test validateEmail function with valid email", () {
    final result = authController.validateEmail("test@example.com");
    expect(result, null);
  });

  test("Test validateEmail function with empty email", () {
    final result = authController.validateEmail("");
    expect(result, 'Email address is required');
  });

  test("Test validateEmail function with invalid email format", () {
    final result = authController.validateEmail("invalid_email");
    expect(result, 'Enter a valid email');
  });

  test("Test validatePassword function with valid password", () {
    final result = authController.validatePassword("strongpassword");
    expect(result, null);
  });

  test("Test validatePassword function with empty password", () {
    final result = authController.validatePassword("");
    expect(result, 'Enter min. 6 characters');
  });

  test("Test validatePassword function with password less than 6 characters",
      () {
    final result = authController.validatePassword("12345");
    expect(result, 'Enter min. 6 characters');
  });

  test("Test validateEmail function with null email", () {
    final result = authController.validateEmail(null);
    expect(result, 'Email address is required');
  });

  test("Test validatePassword function with null password", () {
    final result = authController.validatePassword(null);
    expect(result, 'Enter min. 6 characters');
  });
}
