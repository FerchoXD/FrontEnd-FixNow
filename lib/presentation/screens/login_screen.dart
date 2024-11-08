import 'package:fixnow/presentation/providers.dart';
import 'package:fixnow/presentation/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final loginState = ref.watch(loginFormProvider);

    // ref.listen(authProvider, (previous, next) {
    //   if (next.authStatus == AuthStatus.authenticated) {
    //     context.go('/home');
    //   }
    // });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        // Centrar toda la columna
        child: SingleChildScrollView(
          // Scroll para evitar overflow con teclado
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            width: double.infinity, // Para ocupar todo el ancho disponible
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bienvenido',
                    style: TextStyle(
                      color: Color(0xFF4C98E9),
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Por favor ingresa tus datos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 114, 114, 114),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: 'Correo eletrónico',
                  onChanged:
                      ref.read(loginFormProvider.notifier).onEmailChanged,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Contraseña',
                  isObscureText: true,
                  onChanged:
                      ref.read(loginFormProvider.notifier).onPasswordChanged,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: loginState.isPosting
                          ? null
                          : () {
                              ref
                                  .read(loginFormProvider.notifier)
                                  .onFormSubmit();
                            },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 17),
                        child: Text(
                          'Inicio de sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(height: 60),
                const Text(
                  'O conéctate con',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de Google
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Google',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/facebook.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Facebook',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
                TextButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Color.fromARGB(255, 81, 113, 218)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
