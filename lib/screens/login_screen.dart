import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailController.text, _passwordController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Dang nhap thanh cong' : auth.error ?? 'Dang nhap that bai')));
    if (ok) Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Icon(Icons.table_restaurant_rounded, size: 76, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 18),
                Text('TableNow', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('Dat ban va dat mon truoc that nhanh', textAlign: TextAlign.center),
                const SizedBox(height: 32),
                CustomTextField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: validateEmail),
                const SizedBox(height: 14),
                CustomTextField(controller: _passwordController, label: 'Password', icon: Icons.lock_outline, obscureText: true, validator: validatePassword),
                const SizedBox(height: 20),
                Consumer<AuthProvider>(builder: (context, auth, child) => CustomButton(label: 'Login', icon: Icons.login, isLoading: auth.isLoading, onPressed: _login)),
                TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.register), child: const Text('Chua co tai khoan? Dang ky')),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
