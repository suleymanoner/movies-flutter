import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  User user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              msg,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                  ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _changePassword() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (_passwordController.text.trim() !=
            _passwordAgainController.text.trim()) {
          _showDialog('Password\'s should be match!');
          return;
        }

        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(_passwordController.text.trim());

        _showDialog('Password changed successfully!');
      }
    } on FirebaseAuthException catch (e) {
      _showDialog(e.message!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    _oldPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Change Password',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    onChanged: (value) {},
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      label: Text('Old Password'),
                      alignLabelWithHint: true,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 5) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (value) {},
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      label: Text('New Password'),
                      alignLabelWithHint: true,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 5) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordAgainController,
                    onChanged: (value) {},
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      label: Text('Confirm Password'),
                      alignLabelWithHint: true,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 5) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: _changePassword,
              icon: const Icon(Icons.change_circle),
              label: const Text('Change Password'),
            ),
          ),
        ],
      ),
    );
  }
}
