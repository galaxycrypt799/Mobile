import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onSignUpSuccess;

  const SignUpScreen({super.key, this.onSignUpSuccess});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  IconData _passwordIcon = CupertinoIcons.eye_fill;

  bool _containsUpperCase = false;
  bool _containsLowerCase = false;
  bool _containsNumber = false;
  bool _containsSpecialChar = false;
  bool _contains8Length = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPassword(String value) {
    setState(() {
      _containsUpperCase = value.contains(RegExp(r'[A-Z]'));
      _containsLowerCase = value.contains(RegExp(r'[a-z]'));
      _containsNumber = value.contains(RegExp(r'[0-9]'));
      _containsSpecialChar = value.contains(RegExp(r'[!@#\$&*~`)%\-(_+=;:,.<>/?"\[{\]}|^]'));
      _contains8Length = value.length >= 8;
    });
  }

  bool get _isStrongPassword =>
      _containsUpperCase &&
          _containsLowerCase &&
          _containsNumber &&
          _containsSpecialChar &&
          _contains8Length;

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
      _passwordIcon = _obscurePassword
          ? CupertinoIcons.eye_fill
          : CupertinoIcons.eye_slash_fill;
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully')),
    );

    widget.onSignUpSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Please fill in this field';
                }
                if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              onChanged: _checkPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: IconButton(
                  onPressed: _togglePassword,
                  icon: Icon(_passwordIcon),
                ),
              ),
              validator: (value) {
                final password = value ?? '';
                if (password.isEmpty) {
                  return 'Please fill in this field';
                }
                if (!_isStrongPassword) {
                  return 'Please enter a valid password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PasswordRule(text: '1 uppercase', isValid: _containsUpperCase),
                      _PasswordRule(text: '1 lowercase', isValid: _containsLowerCase),
                      _PasswordRule(text: '1 number', isValid: _containsNumber),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PasswordRule(text: '1 special character', isValid: _containsSpecialChar),
                      _PasswordRule(text: '8 minimum characters', isValid: _contains8Length),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(CupertinoIcons.person_fill),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) {
                  return 'Please fill in this field';
                }
                if (name.length > 30) {
                  return 'Name too long';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRule extends StatelessWidget {
  final String text;
  final bool isValid;

  const _PasswordRule({required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '⚈  $text',
        style: TextStyle(
          fontSize: 12,
          color: isValid ? Colors.green : Colors.grey.shade700,
        ),
      ),
    );
  }
}
