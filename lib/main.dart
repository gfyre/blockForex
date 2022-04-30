import 'package:cryptocurrency_app/constants/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'provider/settings_provider.dart';
import 'ui/home.dart';
import 'package:cryptocurrency_app/constants/utils.dart' as Utils;

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(cryptoSettings);

    final themeMode = settings.maybeWhen(
        data: (data) => Utils.getThemeMode(data.themeMode),
        orElse: () => ThemeMode.system);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LoginScreen(),
      // home: Home(),
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}

const users = const {
  'hi@gmail.com': '12345',
  'drumil@gmail.com': 'drumil',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User does not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User does not exists';
      }
      return 'User Found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
        pageColorDark: Colors.black,
        pageColorLight: Colors.black,
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        // cardTheme: CardTheme(
        //   color: Colors.white,
        // ),
        primaryColor: Color.fromRGBO(1, 0, 0, 1),
        buttonTheme: LoginButtonTheme(
          backgroundColor: (Color.fromRGBO(76, 175, 80, 1)),
        ),
      ),
      title: 'BlocForex',
      logo: AssetImage('assets/icon/bflogo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
