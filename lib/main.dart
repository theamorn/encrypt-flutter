import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google DevFest 2024',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Encrypt Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 256 Bit Key, 32 Characters
  // Get this key from Key Exchange
  final realKey = enc.Key.fromUtf8('GoogleDevFestBangkok202401234567');

  String request = '';
  String decryptedData = '';
  String signature = '';
  String name = '';
  String userData = '';

  String generateNonce([int length = 16]) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(bytes).substring(0, length);
  }

  void _submitRequest() {
    // Prepare Encryption
    final timeStart = Stopwatch();
    timeStart.start();
    final realIV = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(realKey, mode: enc.AESMode.cbc));

    // Add nonce and timestamp to userData
    final Map<String, dynamic> jsonString = jsonDecode(userData);
    jsonString.addAll({
      'nonce': generateNonce(16),
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });

    // Encrypt userData and Decrypt userData
    final encrypted = encrypter.encrypt(jsonString.toString(), iv: realIV);
    final decrypted = encrypter.decrypt(encrypted, iv: realIV);

    // create digital signature from Encrypt userData
    final hashSignature = sha256.convert(utf8.encode(encrypted.base64));
    print("How Long it take to encrypt: ${timeStart.elapsedMilliseconds} ms");

    setState(() {
      request = encrypted.base64;
      decryptedData = decrypted;
      signature = hashSignature.toString();
      print("=======");
      debugPrint('request: $request');
      print('IV: ${realIV.base64}');
      print('Signature: $signature');
      print("=======");
      print(
          "JSON Request: {'response': '$request', 'signature': '$signature'}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your name',
                ),
                onChanged: (value) {
                  setState(() {
                    // generate json sample for transfer money for 30 fields of data
                    userData = '''{
  "name": "$value",
  "age": 30,
  "transfer_amount": 10000,
  "target_account": "1234567890",
  "sender_account": "9876543210",
  "transaction_id": "TRX${DateTime.now().millisecondsSinceEpoch}",
  "bank_code": "BANK123",
  "currency": "USD",
  "transfer_type": "INSTANT",
  "purpose": "Business Payment",
  "sender_address": "123 Main Street",
  "sender_city": "Bangkok",
  "sender_country": "Thailand",
  "sender_postal_code": "10110",
  "sender_phone": "+66123456789",
  "sender_email": "sender@email.com",
  "recipient_name": "John Doe",
  "recipient_address": "456 Second Road",
  "recipient_city": "Singapore",
  "recipient_country": "Singapore",
  "recipient_postal_code": "569420",
  "recipient_phone": "+6598765432",
  "recipient_email": "recipient@email.com",
  "transaction_fee": 15.00,
  "exchange_rate": 1.00
}''';
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRequest,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Submit Data:',
              ),
              Text(
                request,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              const Text(
                'DecryptData:',
              ),
              Text(
                decryptedData,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              const Text(
                'Signature:',
              ),
              Text(
                signature,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitRequest,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
