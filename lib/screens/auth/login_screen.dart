import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool register = false;
  final name = TextEditingController(text: 'Nguyen Van A');
  final email = TextEditingController(text: 'customer@rustic.dev');
  final phone = TextEditingController(text: '090 123 4567');
  final password = TextEditingController(text: '123456');

  @override
  void dispose() { name.dispose(); email.dispose(); phone.dispose(); password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(padding: const EdgeInsets.all(28), children: [
        const SizedBox(height: 42),
        Text('Rustic Kitchen', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary, fontSize: 44)),
        const SizedBox(height: 12),
        Text(register ? 'Tao tai khoan de dat ban va goi mon.' : 'Dang nhap de tiep tuc trai nghiem am thuc.', textAlign: TextAlign.center),
        const SizedBox(height: 38),
        if (register) ...[TextField(controller: name, decoration: const InputDecoration(labelText: 'Ho ten')), const SizedBox(height: 14), TextField(controller: phone, decoration: const InputDecoration(labelText: 'So dien thoai')), const SizedBox(height: 14)],
        TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 14),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Mat khau')),
        const SizedBox(height: 22),
        FilledButton(onPressed: () { context.read<AppState>().loginAsCustomer(); context.go('/home'); }, child: Text(register ? 'Dang ky' : 'Dang nhap')),
        TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'Da co tai khoan? Dang nhap' : 'Chua co tai khoan? Dang ky')),
        const Divider(height: 36),
        OutlinedButton.icon(onPressed: () { context.read<AppState>().loginAsAdmin(); context.go('/admin'); }, icon: const Icon(Icons.admin_panel_settings), label: const Text('Vao che do Admin demo')),
      ]),
    ),
  );
}
