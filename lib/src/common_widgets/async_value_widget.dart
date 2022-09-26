import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
      {super.key,
      required this.value,
      required this.builder,
      required this.refresh});

  final AsyncValue<T> value;
  final Widget Function(BuildContext, T) builder;
  final Future<void> Function() refresh;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (data) => builder(context, data),
      error: (error, stackTrace) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error.toString()),
          const SizedBox(height: 24),
          value.isRefreshing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: refresh, child: const Text('Refresh')),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
