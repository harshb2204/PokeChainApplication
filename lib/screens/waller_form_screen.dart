import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class WalletFormScreen extends StatefulWidget {
  @override
  _WalletFormScreenState createState() => _WalletFormScreenState();
}

class _WalletFormScreenState extends State<WalletFormScreen> {
  final _walletController = TextEditingController();
  String? _walletDetails;
  late Web3Client _web3Client;

  final String _rpcUrl = "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"; // Replace with your Infura Project ID

  @override
  void initState() {
    super.initState();
    _web3Client = Web3Client(_rpcUrl, Client());
  }

  Future<void> _fetchWalletDetails() async {
    final walletAddress = _walletController.text.trim();
    if (walletAddress.isEmpty || !walletAddress.startsWith('0x') || walletAddress.length != 42) {
      setState(() {
        _walletDetails = "Please enter a valid wallet address.";
      });
      return;
    }

    try {
      final EthereumAddress ethAddress = EthereumAddress.fromHex(walletAddress);

      // Fetch balance
      final EtherAmount balance = await _web3Client.getBalance(ethAddress);

      // Dummy NFTs Owned for now
      const int dummyNftsOwned = 3;

      setState(() {
        _walletDetails = '''
          Wallet Address: $walletAddress
          Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH
          NFTs Owned: $dummyNftsOwned
        ''';
      });
    } catch (e) {
      setState(() {
        _walletDetails = "Error fetching wallet details: $e";
      });
    }
  }

  @override
  void dispose() {
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Wallet'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Wallet Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _walletController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Wallet Address',
                hintText: 'Enter your wallet address (42 characters starting with 0x)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchWalletDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.black, width: 2),
              ),
              child: Text('Fetch Details'),
            ),
            SizedBox(height: 20),
            if (_walletDetails != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(
                  _walletDetails!,
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
