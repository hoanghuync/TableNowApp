import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(fullName: _nameController.text, email: _emailController.text, phone: _phoneController.text, password: _passwordController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Dang ky thanh cong' : auth.error ?? 'Dang ky that bai')));
    if (ok) Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dang ky')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _formKey, child: Column(children: [
        CustomTextField(controller: _nameController, label: 'Ho ten', icon: Icons.person_outline, validator: (v) => validateRequired(v, 'ho ten')),
        const SizedBox(height: 12),
        CustomTextField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, validator: validateEmail),
        const SizedBox(height: 12),
        CustomTextField(controller: _phoneController, label: 'So dien thoai', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => validateRequired(v, 'so dien thoai')),
        const SizedBox(height: 12),
        CustomTextField(controller: _passwordController, label: 'Password', icon: Icons.lock_outline, obscureText: true, validator: validatePassword),
        const SizedBox(height: 20),
        Consumer<AuthProvider>(builder: (context, auth, child) => CustomButton(label: 'Tao tai khoan', isLoading: auth.isLoading, onPressed: _register)),
      ])),
    ),
  );
}
