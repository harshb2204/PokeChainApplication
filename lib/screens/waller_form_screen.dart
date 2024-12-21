import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletFormScreen extends StatefulWidget {
  @override
  _WalletFormScreenState createState() => _WalletFormScreenState();
}

class _WalletFormScreenState extends State<WalletFormScreen> {
  final _walletController = TextEditingController();
  String? _walletDetails;
  List<dynamic> _ownedPokemon = [];
  String? _error;

  Future<void> _fetchWalletDetails() async {
    final walletAddress = _walletController.text.trim();
    if (walletAddress.isEmpty) {
      setState(() {
        _error = 'Please enter a valid wallet address.';
        _walletDetails = null;
        _ownedPokemon = [];
      });
      return;
    }

    final url = "http://192.168.26.172:8000/balance/$walletAddress";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _walletDetails = '''
Wallet Address: ${data['address']}
Balance: ${data['balance']} ETH
NFTs Owned: ${data['nfts'].length}
''';
          _ownedPokemon = data['nfts'];
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Error fetching wallet details: ${response.statusCode} ${response.reasonPhrase}';
          _walletDetails = null;
          _ownedPokemon = [];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching wallet details: $e';
        _walletDetails = null;
        _ownedPokemon = [];
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
                hintText: 'Enter your wallet address',
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
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (_walletDetails != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Details:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _walletDetails!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            if (_ownedPokemon.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'Owned Pokémon:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _ownedPokemon.length,
                itemBuilder: (context, index) {
                  final pokemon = _ownedPokemon[index];
                  return _buildPokemonCard(pokemon);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(dynamic pokemon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(pokemon['nft_image_location']),
        ),
        title: Text(
          pokemon['pokemon_name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Type: ${pokemon['pokemon_type']}'),
      ),
    );
  }
}
