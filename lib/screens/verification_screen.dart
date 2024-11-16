import 'package:flutter/material.dart';
import 'services/email_otp.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  // Method to verify OTP
  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String otp = _otpController.text.trim();
      if (otp.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter the OTP.';
        });
        return;
      }

      // Verify OTP using EmailOTP library
      bool isValid = EmailOTP.verifyOTP(otp: otp);

      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verified Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen after successful verification
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Invalid OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to resend OTP
  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Resend OTP to the email
      bool otpSent = await EmailOTP.sendOTP(email: widget.email);

      if (otpSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP has been resent to your email.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to resend OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to ${widget.email}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                filled: true,
                fillColor: const Color(0xFF4B61DD).withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Verify OTP'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _resendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Resend OTP'),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
