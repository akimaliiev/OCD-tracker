import 'package:flutter/material.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); 
  }

  void _loadUserEmail() {
    final user = _authService.getCurrentUser();
    if (user != null && user.email != null) {
      _emailController.text = user.email!; 
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent successfully!')),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> _makePhoneCall() async {
    const phoneNumber = '+77761399787';
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We would love to hear from you!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Have any questions, feedback, or issues? Feel free to get in touch by filling out the form below.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown, width: 2),
                    ),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Your Message',
                    labelStyle: const TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: MyButton(
                    text: 'Send message',
                    onTap: _submitForm,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ' OR ',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Center(
                  child: TextButton.icon(
                    onPressed: _makePhoneCall,
                    icon: const Icon(Icons.phone, color: Colors.brown),
                    label: const Text(
                      'Call Us',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
