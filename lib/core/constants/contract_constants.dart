class ContractConstants {
  ContractConstants._();

  // Contract Addresses (Sepolia Testnet)
  static const String usdcAddress =
      '0xB507E196dC7F796b9D24Eb9Aa620Ee0447108AC6';
  static const String vaultAddress =
      '0xD18F0427eB6653ee81579bdcc5911A124eFA2fEA';

  // Network Configuration
  static const String networkName = 'Sepolia';
  static const int chainId = 11155111; // Sepolia Testnet

  // Free Sepolia RPC endpoints (for reading data only)
  // Using public RPC - transactions will be sent via WalletConnect
  static const String rpcUrl = 'https://ethereum-sepolia-rpc.publicnode.com';
  // Alternatives if the above doesn't work:
  // 'https://rpc.sepolia.org'
  // 'https://sepolia.gateway.tenderly.co'
  // 'https://gateway.tenderly.co/public/sepolia'

  // Gas Configuration
  static const int defaultGasLimit = 300000;
  static const int approveGasLimit = 100000;
  static const int mintGasLimit = 100000;
}
