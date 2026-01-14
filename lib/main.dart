import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'view_models/app_view_model.dart';
import 'views/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        ChangeNotifierProvider(
          create: (context) {
            final storageService = context.read<StorageService>();
            final appVM = AppViewModel(storageService);
            appVM.initialize();
            return appVM;
          },
        ),
      ],
      child: const AppRouter(),
    );
  }
}
