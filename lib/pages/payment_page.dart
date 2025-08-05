import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:shandynotes/pages/homePage.dart';
import 'package:shandynotes/widgets/appbarWidgets.dart';

import '../widgets/navigationDrawer.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String pdfUrl;

  const PaymentPage({super.key, required this.pdfUrl, required this.amount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  bool _isScriptLoaded = false;
  String? _errorMessage;
  js.JsObject? _razorpay;

  @override
  void initState() {
    super.initState();
    _loadRazorpayScript();
  }

  void _loadRazorpayScript() {
    final script = html.ScriptElement()
      ..src = 'https://checkout.razorpay.com/v1/checkout.js'
      ..type = 'text/javascript'
      ..id = 'razorpay-script';

    script.onLoad.listen((event) {
      setState(() {
        _isScriptLoaded = true;
      });
    });

    script.onError.listen((event) {
      setState(() {
        _errorMessage = 'Failed to load payment gateway';
        _isScriptLoaded = false;
      });
    });

    html.document.head!.append(script);
  }

  void _handlePaymentSuccess(dynamic response) {
    setState(() => _isLoading = false);
    _showSuccessDialog();
  }

  void _handlePaymentError(dynamic error) {
    setState(() {
      _isLoading = false;
      _errorMessage =
          'Payment failed: ${error['description'] ?? 'Unknown error'}';
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Payment Successful'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thank you for your purchase!'),
              const SizedBox(height: 10),
              const Text('Your PDF is ready to download.'),
              const SizedBox(height: 20),
              Image.network(
                'https://cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/67ab90e40033b5adedc8/view?project=6719d1d0001cf69eb622&mode=admin',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadPDF();
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Download PDF'),
            ),
          ],
        );
      },
    );
  }

  void _downloadPDF() {
    // Open the PDF in a new tab
    html.window.open(widget.pdfUrl, '_blank');

    // Navigate to the homepage
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const Homepage()), // Replace with your homepage widget
      );
    });
  }

  // void _downloadPDF() {
  //   html.window.open(widget.pdfUrl, '_blank');
  // }

  void _startPayment() {
    if (_isLoading || !_isScriptLoaded) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final amountInPaise = (widget.amount * 100).toInt();

      js.context['razorpaySuccessHandler'] = (response) {
        _handlePaymentSuccess(response);
      };

      js.context['razorpayErrorHandler'] = (error) {
        _handlePaymentError(error);
      };

      final options = js.JsObject.jsify({
        'key': 'rzp_live_IgHUgvPYplZAk4',
        'amount': amountInPaise,
        'currency': 'INR',
        'name': 'Shandy Notes',
        'description': 'PDF Purchase',
        'handler': js.allowInterop((response) {
          js.context.callMethod('razorpaySuccessHandler', [response]);
        }),
        'prefill': {'name': '', 'email': '', 'contact': ''},
        'theme': {
          'color': '#2196F3',
        },
        'modal': {
          'ondismiss': js.allowInterop(() {
            setState(() => _isLoading = false);
          }),
        }
      });

      _razorpay = js.JsObject(js.context['Razorpay'], [options]);
      _razorpay?.callMethod('open');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error initializing payment: $e';
      });
    }
  }

  @override
  void dispose() {
    // Clear Razorpay instance
    _razorpay?.callMethod('destroy');
    // Remove script
    final scriptElement = html.document.getElementById('razorpay-script');
    if (scriptElement != null) {
      scriptElement.remove();
    }
    // Clear handlers
    js.context.deleteProperty('razorpaySuccessHandler');
    js.context.deleteProperty('razorpayErrorHandler');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: const ModernNavBar(),
      endDrawer: const MyNavigationDrawer(),
      body: Center(
        child: Container(
          width: isMobile ? 380 : 600,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurpleAccent,
                Colors.deepPurpleAccent,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.description,
                                size: 48,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Get Your Note !!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Amount: ₹${widget.amount.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.blue.shade700,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                            color: Colors.red.shade700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (!_isScriptLoaded)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Loading payment gateway...'),
                                  ],
                                ),
                              )
                            else
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _startPayment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Pay  ₹${widget.amount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.security,
                                    color: Colors.green.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  'Secure Payment',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade600,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Your payment is processed securely through Razorpay with bank-grade encryption.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFeatureItem(
                                    Icons.speed, 'Instant Access'),
                                const SizedBox(width: 24),
                                _buildFeatureItem(
                                    Icons.refresh, 'Non-Refundable'),
                                const SizedBox(width: 24),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
