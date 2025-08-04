import 'package:flutter/material.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  final Key? key;
  const LoginPage({this.key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login', style: AppTextStyles.headline)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(key: Key('loadingIndicator')),
            );
          }
          if (state is Authenticated) {
            return Center(
              child: Text(
                'Welcome!',
                key: Key('successText'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }
          if (state is AuthError) {
            return Center(
              child: Text(
                state.message,
                key: Key('errorText'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }
          if (state is Unauthenticated) {
            return Center(
              child: Text(
                'Signed out',
                key: Key('signOutText'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        key: Key('emailField'),
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        key: Key('passwordField'),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        key: Key('signInButton'),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            SignInRequested(
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        key: Key('signOutButton'),
                        onPressed: () {
                          context.read<AuthBloc>().add(SignOutRequested());
                        },
                        child: Text(
                          'Sign Out',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
