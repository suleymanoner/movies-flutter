import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/widgets/forgot_password.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignUp = false;
  bool _isLoginLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  Future _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoginLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          _isLoginLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        _showError(e.message!);
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  Future _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_passwordController.text.trim() !=
          _passwordAgainController.text.trim()) {
        _showError('Password\'s should be match!');
        return;
      }

      setState(() {
        _isLoginLoading = true;
      });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        CollectionReference usersCollection = firestore.collection('users');

        usersCollection.add({
          'name': _nameController.text.trim(),
          'surname': _surnameController.text.trim(),
          'email': _emailController.text.trim(),
        });

        setState(() {
          _isLoginLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoginLoading = false;
        });
        _showError(e.message!);
      }
    }
  }

  void _openForgotPassword() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => ForgotPassword(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            label: Text('Email'),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email field can not be empty.';
            } else if (!Constants.emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
          controller: _emailController,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            label: Text('Password'),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().length <= 5) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          controller: _passwordController,
          obscureText: true,
        ),
      ],
    );

    if (_isSignUp) {
      content = Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().length <= 1) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
            controller: _nameController,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Surname'),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().length <= 1) {
                return 'Surname must be at least 2 characters';
              }
              return null;
            },
            controller: _surnameController,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Email'),
            ),
            keyboardType: TextInputType.emailAddress,
            style: Theme.of(context).textTheme.bodyMedium,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email must be entered.';
              } else if (!Constants.emailRegExp.hasMatch(value)) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            controller: _emailController,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Password'),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().length <= 5) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Confirm Password'),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _passwordAgainController,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().length <= 5) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            obscureText: true,
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/movies_logo.png',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
                  ),
                  Card(
                    elevation: 15,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              content,
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isSignUp = !_isSignUp;
                                  });
                                  _emailController.text = '';
                                  _passwordController.text = '';
                                },
                                child: _isSignUp
                                    ? const Text(
                                        'You already have an account? Click to sign-in.')
                                    : const Text(
                                        'You don\'t have an account? Click to sign-up.'),
                              ),
                              _isLoginLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _isSignUp ? _signUp() : _login();
                                        },
                                        child: Text(
                                          _isSignUp ? 'Sign up' : 'Login',
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!_isSignUp)
              TextButton(
                onPressed: _openForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
