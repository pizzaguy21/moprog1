import 'package:flutter/material.dart';

class AccountSecuritiesScreen extends StatefulWidget {
  final String email;
  final String? phoneNumber; // Nullable untuk nomor telepon

  const AccountSecuritiesScreen({
    super.key,
    required this.email,
    this.phoneNumber,
  });

  @override
  _AccountSecuritiesScreenState createState() =>
      _AccountSecuritiesScreenState();
}

class _AccountSecuritiesScreenState extends State<AccountSecuritiesScreen> {
  String? phoneNumber;
  String securityLevel = "Weak";

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber; // Inisialisasi dengan nilai awal
    updateSecurityLevel();
  }

  void updateSecurityLevel() {
    setState(() {
      if (phoneNumber == null || phoneNumber!.isEmpty) {
        securityLevel = "Weak";
      } else {
        securityLevel = "Strong";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text(
          'Account Securities',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF4B61DD), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.black54),
                      const SizedBox(width: 8),
                      const Text(
                        'Security Level : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        securityLevel,
                        style: TextStyle(
                          fontSize: 16,
                          color: securityLevel == "Weak"
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Set password and email verification to make accounts more secure and convenient',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Email Section
            Text(
              'Email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.email,
                    style: const TextStyle(color: Colors.green),
                  ),
                  const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Phone Number Section
            Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // Navigasi ke layar input nomor telepon dan tunggu hasilnya
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPhoneScreen(),
                  ),
                );

                if (result != null && result is String) {
                  setState(() {
                    phoneNumber = result; // Update nomor telepon langsung
                    updateSecurityLevel(); // Perbarui level keamanan
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E4FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      phoneNumber ?? "Not Yet Set",
                      style: TextStyle(
                        color: phoneNumber == null ? Colors.red : Colors.green,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key});

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Phone Number'),
        backgroundColor: const Color(0xFF4B61DD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Your Phone Number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'e.g., +628123456789',
                errorText: _errorMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B61DD),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Phone number cannot be empty.';
      });
      return;
    }

    if (!_isValidPhoneNumber(phoneNumber)) {
      setState(() {
        _errorMessage = 'Please enter a valid phone number.';
      });
      return;
    }

    // Langsung kembali ke layar sebelumnya dengan mengirim nomor telepon
    Navigator.pop(context, phoneNumber);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Validasi sederhana nomor telepon
    final regex = RegExp(r'^\+?[0-9]{10,15}$');
    return regex.hasMatch(phoneNumber);
  }
}

