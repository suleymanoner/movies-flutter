import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  var _isSending = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  void _sendRecoveryEmail() async {
    try {
      if (_emailController.text.trim().isEmpty) {
        _showMsg('Please enter your email!');
        return;
      }

      setState(() {
        _isSending = true;
      });

      await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: _emailController.text.trim(),
          )
          .then(
            (value) =>
                _showMsg('Recovery email sent. Please check your email.'),
          );

      setState(() {
        _isSending = false;
      });

      _emailController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isSending = false;
      });
      _showMsg(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              _isSending
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: TextField(
                                controller: _emailController,
                                style: Theme.of(context).textTheme.bodyMedium,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: 'Please enter your email.'),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _sendRecoveryEmail,
                                child: Text(
                                  'Send recovery email.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
