import 'package:co2app/providers/api_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The one-time setup screen: asks for the CO2 API URL and key and stores
/// them on the device.
class InitScreen extends ConsumerStatefulWidget {
  const InitScreen({super.key});

  @override
  ConsumerState<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends ConsumerState<InitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _apiKey = "";
  String _apiUrl = "";
  bool _obscureText = true;

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    ref
        .read(apiConfigNotifierProvider.notifier)
        .configure(_apiUrl, _apiKey);
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Column(children: [
                      const SizedBox(height: 50),
                      Image.asset(
                        "lib/assets/images/logo.png",
                        width: 200,
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        "Please enter your API URL and key",
                        style: TextStyle(
                            color: Color.fromRGBO(156, 180, 194, 1),
                            fontSize: 16),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'API URL',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.cloud_queue),
                        ),
                        enableInteractiveSelection: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your API URL';
                          }
                          if (!Uri.parse(value).isAbsolute) {
                            return 'Please enter a valid API URL';
                          }

                          return null;
                        },
                        style: const TextStyle(color: Colors.grey),
                        onSaved: (newValue) => _apiUrl = newValue ?? "",
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'API key',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: _toggleObscureText,
                            icon: _obscureText
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        enableInteractiveSelection: true,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your API key';
                          }

                          return null;
                        },
                        style: const TextStyle(color: Colors.grey),
                        onSaved: (newValue) => _apiKey = newValue ?? "",
                      ),
                      const SizedBox(height: 12),
                    ]),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                        backgroundColor:
                            const Color.fromRGBO(156, 180, 194, 1),
                        foregroundColor: Colors.grey[900],
                        onPressed: _saveForm,
                        label: const Text("Save"),
                        icon: const Icon(Icons.save_alt),
                        shape: ShapeBorder.lerp(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          0.5,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
