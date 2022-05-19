import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";
  String _privateKey = "";
  Web3Client? _client;
  bool isLoading = true;

  String? _abiCode;
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;
  ContractFunction? _yourName;
  ContractFunction? _yourprice;
  ContractFunction? _setName;

  String? deployedName;
  BigInt deployedprice = BigInt.from(0);
  ContractLinking(id) {
    _privateKey = id;
    //"85d9452bc56a1ae89388e4feeb660148fd6baab7f48959bc319f97736f0e7399";
    initialSetup();
  }

  initialSetup() async {
    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/HelloWorld.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client?.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "HelloWorld"), _contractAddress);

    // Extracting the functions, declared in contract.
    _yourName = _contract?.function("yourName");
    _yourprice = _contract?.function("price");
    _setName = _contract?.function("setName");
    getName();
    getPrice();
  }

  getName() async {
    // Getting the current name declared in the smart contract.
    var currentName = await _client
        ?.call(contract: _contract, function: _yourName, params: []);
    deployedName = currentName?[0];
    isLoading = false;
    notifyListeners();
  }

  getPrice() async {
    // Getting the current name declared in the smart contract.
    var currentName = await _client
        ?.call(contract: _contract, function: _yourprice, params: []);
    deployedprice = currentName?[0];
    isLoading = false;
    notifyListeners();
  }

  setName(String nameToSet, BigInt price) async {
    // Setting the name to nameToSet(name defined by user)
    print(price);
    isLoading = true;
    notifyListeners();
    await _client?.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _setName,
            parameters: [nameToSet, price]));
    getName();
    getPrice();
  }
}
