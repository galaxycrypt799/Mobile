import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback? onSignInSuccess;

  const SignInScreen({super.key, this.onSignInSuccess});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  IconData _passwordIcon = CupertinoIcons.eye_fill;
  String? _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _errorMsg = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in successfully')),
    );

    widget.onSignInSuccess?.call();
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
      _passwordIcon = _obscurePassword
          ? CupertinoIcons.eye_fill
          : CupertinoIcons.eye_slash_fill;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                errorText: _errorMsg,
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
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
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
                if (password.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
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
                    : const Text('Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
