import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _changeSignInUp(String type) {
    _formKey.currentState?.reset();

    if (type == 'up') {
      setState(() {
        _isSignUp = true;
      });
    } else if (type == 'in') {
      setState(() {
        _isSignUp = false;
      });
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  Future _login() async {
    /*
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(child: CircularProgressIndicator()));
        */

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

      // navigatorKey.currentState!.popUntil((route) => route.isCurrent);
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
      } on FirebaseAuthException catch (e) {
        _showError(e.message!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        const SizedBox(height: 50),
        Image.asset(
          'assets/images/movies_logo.png',
          width: 250,
          height: 250,
        ),
        TextFormField(
          decoration: const InputDecoration(
            label: Text('Email'),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
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
        const SizedBox(height: 16),
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
          const SizedBox(height: 150),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Email'),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    content,
                    TextButton(
                        onPressed: () {
                          _isSignUp
                              ? _changeSignInUp('in')
                              : _changeSignInUp('up');
                          _emailController.text = '';
                          _passwordController.text = '';
                        },
                        child: _isSignUp
                            ? const Text(
                                'You have already account? Click to sign-in.')
                            : const Text(
                                'You don\'t have an account? Click to sign-up.')),
                  ]),
                ),
              ),
              _isLoginLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox(),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    _isSignUp ? _signUp() : _login();
                  },
                  child:
                      _isSignUp ? const Text('Sign up') : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
