import 'package:fixnow/presentation/providers.dart';
import 'package:fixnow/presentation/providers/finances/finances_provider.dart';
import 'package:fixnow/presentation/providers/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;
    final paymentsState = ref.watch(homeProvider);
    return NavigationDrawer(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 300, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  {_copyTutorInfoToClipboard(userState.user?.id, context)},
              child: Row(

                children: [],
              ),
            ),
            Center(child: Icon(Icons.person, size: 120, color: colors.primary,)),
            Center(
              child: Text(
                '${userState.user?.fullname}',
                style:
                    TextStyle(fontSize: 16, color: Color(colors.onSurface.value)),
              ),
            ),
            Center(
              child: Text(
                '${userState.user?.email}',
                style:
                    TextStyle(fontSize: 16, color: Color(colors.onSurface.value)),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: ElevatedButton(
          onPressed: paymentsState.isLoadingPayment
              ? null
              : () {
                  ref
                      .read(homeProvider.notifier)
                      .createSuscription(userState.user!.id!);
                },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: Color(colors.primary.value),
              foregroundColor: Color(colors.onPrimary.value)),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Adquirir premium',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).logout('');
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: Color(colors.primary.value),
              foregroundColor: Color(colors.onPrimary.value)),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Salir',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    ]);
  }

  void _copyTutorInfoToClipboard(String? code, BuildContext context) {
    String clipboardText = "$code";
    Clipboard.setData(ClipboardData(text: clipboardText));
  }
}
