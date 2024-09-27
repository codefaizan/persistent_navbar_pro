import 'package:flutter/material.dart';
import 'package:persistent_navbar_pro/persistent_navbar_pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dash(),
    );
  }
}

class Dash extends StatelessWidget {
  const Dash({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentNavbar(screens: const [
      Home(),
      Settings()
    ], items: [
      NavBarItem(
        icon: const Icon(Icons.home),
        label: "Home",
      ),
      NavBarItem(
        icon: const Icon(Icons.settings),
        label: "Settings",
      ),
    ]);
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text("Home"),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeSubPage())),
                child: const Text("Sub Page"))
          ],
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Settings"),
      ),
    );
  }
}

class HomeSubPage extends StatelessWidget {
  const HomeSubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Home Sub Page 1"),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeSubPage2())),
              child: const Text("Go To Home Sub Page 2"))
        ],
      ),
    );
  }
}

class HomeSubPage2 extends StatelessWidget {
  const HomeSubPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("SubPage 2"),
      ),
    );
  }
}
