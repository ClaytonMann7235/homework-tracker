import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';
import '../main_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

    @override
    State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _presente = AuthPresenter();

    String? _errorMessage;

    void _handleLogin() async {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        if (email.isEmpty) {
            setState(() => _errorMessage = 'Enter your email address.');
            return;
        }
        if (password.isEmpty) {
            setState(() => _errorMessage = 'Enter your password.');
            return;
        }

        final error = await _presente.login(
        email,
        password);

        if (!mounted) return;
        if (error != null) {
            setState(()=> _errorMessage = error);
        } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
            );
        }
    }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Login'),
                automaticallyImplyLeading: false,
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        if (_errorMessage != null)
                            Text(_errorMessage!, style:const TextStyle(color: Colors.red)),
                            TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(labelText: 'Email')
                            ),
                            TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(labelText: 'Password'),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: _handleLogin,
                                child: const Text('Login'),
                            ),
                            TextButton(
                                onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                    );
                                },
                                child: const Text('Don\'t have an account? Sign up'),
                            ),
                        
                    ],
                ),
            ),
        );
    }
}

