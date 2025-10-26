class ContractConstants {
  ContractConstants._();

  // Contract Addresses (Sepolia Testnet)
  static const vaultAddress = '0x7C36608d403Ad1741990999a32b431FecE785aa4';
  static const usdcAddress = '0x1A1234Ea86cb80d7829F7c43A2DB35c192b8F966';
  static const creditorAddress = '0xF813e9134CF97f9D52fAD9F5F059115E87D8bF88';

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

///=== DEPLOYMENT ADDRESSES ===
//   Owner/Admin: 0x629B599B225cFD1289ADc3AB471f72c4e25A6b9E
//   TMRWAccessControl: 0x3a9eAd412f769C76F181a31805C4f7f37D23B08d
//   TMRWCredit: 0x1229bBE32BC91875b323fA7DD32B01e05E76E1d2
//   Treasury: 0xF32a3083a95641C6DEC7CB57ba0B9D4437D2847b
//   XPToken: 0x0EC91fC280dF5C88138824CBcFe1D269CFF19763
//   Creditor: 0x5D8F2E6F99a32C2B1EF5BEda94c56CD33893De3F
//   Lender: 0xa078fCE86e02E51df63A7A5c592543769D201f07
//   USDC: 0x350766c77737F96F3d9F085B7A08808D1d558210
//   Aave Pool: 0xcb10119f7c0093515e1e2B562c4A13F8D870F680
//   aToken: 0xa5B2Df514562d52934fADb87f82904EEfFbCd303
//   Vault: 0xA9BD537cd89906084c77D65865e8c49F0DFb76A9
