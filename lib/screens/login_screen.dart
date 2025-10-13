import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _signIn() {
    // simple demo navigation to home
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                const Text(''),
              ]),
              const Spacer(),
              Column(
                children: [
                  const Icon(Icons.restaurant_menu,
                      size: 56, color: Colors.black54),
                  const SizedBox(height: 12),
                  const Text('hellofood',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone))),
                  const SizedBox(height: 12),
                  TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password', prefixIcon: Icon(Icons.lock))),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _signIn,
                        child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text('SIGN IN'))),
                  ),
                  const SizedBox(height: 12),
                  Row(children: const [
                    Expanded(child: Divider()),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Or')),
                    Expanded(child: Divider())
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                        onPressed: () {},
                        icon: const CircleAvatar(child: Text('f'))),
                    const SizedBox(width: 12),
                    IconButton(
                        onPressed: () {},
                        icon: const CircleAvatar(child: Text('G'))),
                  ]),
                ],
              ),
              const Spacer(flex: 2),
              TextButton(
                  onPressed: () {},
                  child: const Text("Don't have an account? Sign Up")),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
