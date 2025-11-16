# Onchain Amex - Technical Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Core Components](#core-components)
6. [User Roles & Features](#user-roles--features)
7. [Blockchain Integration](#blockchain-integration)
8. [State Management](#state-management)
9. [Navigation System](#navigation-system)
10. [API Architecture](#api-architecture)
11. [Security & Storage](#security--storage)
12. [Development Guidelines](#development-guidelines)
13. [Testing & Debugging](#testing--debugging)
14. [Deployment](#deployment)
15. [Troubleshooting](#troubleshooting)

---

## Project Overview

**Onchain Amex** is a Flutter-based, crypto-native Point-of-Sale (POS) terminal that enables merchants to accept stablecoin payments (USDC, USDT, DAI) directly on the Ethereum blockchain. The application is built for three distinct user roles with separate navigation flows and feature sets.

### Key Characteristics
- **Platform**: Flutter 3.4.1+ (iOS, Android)
- **Blockchain**: Ethereum Sepolia Testnet (chainId: 11155111)
- **Architecture**: Clean Architecture with feature-based modules
- **State Management**: Riverpod 2.5.1 with code generation
- **Network**: Ethereum Sepolia via public RPC nodes
- **Wallet Integration**: Reown AppKit (WalletConnect v2)

### Core Value Propositions
- ✅ Zero platform fees
- ✅ Direct on-chain stablecoin payments
- ✅ Self-custodied wallets
- ✅ Multi-role support (Borrower, Lender, Merchant)
- ✅ NFC & QR payment support
- ✅ Real-time blockchain transactions

---

## System Architecture

### Clean Architecture Pattern

The application follows Clean Architecture principles with a clear separation of concerns across three layers:

```
lib/[role]/[feature]/
  ├── presentation/     # UI Layer (Screens, Controllers)
  │   ├── screens/      # Flutter widgets and pages
  │   ├── controllers/  # Riverpod state controllers
  │   └── widgets/      # Reusable UI components
  ├── business/         # Domain Layer (Repository Interfaces)
  │   └── repository/   # Abstract repository contracts
  └── data/             # Data Layer (Implementation)
      ├── repositories/ # Concrete repository implementations
      ├── dto/          # Data Transfer Objects
      └── models/       # Domain models
```

### Architectural Benefits
- **Separation of Concerns**: Each layer has distinct responsibilities
- **Testability**: Business logic isolated from UI and data sources
- **Maintainability**: Clear boundaries enable easier modifications
- **Scalability**: New features follow established patterns

### Layer Responsibilities

#### Presentation Layer
- Renders UI components using Flutter widgets
- Manages user interactions and input validation
- Consumes Riverpod providers for state
- Navigates between screens using GoRouter

#### Business Layer
- Defines repository interfaces (contracts)
- Contains business rules and use case logic
- Acts as a bridge between presentation and data

#### Data Layer
- Implements repository interfaces
- Handles API communication via Dio
- Manages blockchain interactions via Web3
- Transforms DTOs to domain models

---

## Technology Stack

### Core Framework
```yaml
Flutter SDK: >=3.4.1 <4.0.0
Dart: >=3.4.1
```

### State Management
- **flutter_riverpod: ^2.5.1** - Reactive state management
- **riverpod_annotation: ^2.3.5** - Code generation for providers
- **riverpod_generator: ^2.4.0** - Build-time code generation
- **riverpod_lint: ^2.3.10** - Linting rules for Riverpod

### Navigation
- **go_router: ^15.1.2** - Declarative routing with deep linking support

### Networking
- **dio: ^5.8.0+1** - HTTP client with interceptors
- **connectivity_plus: ^6.1.4** - Network connectivity monitoring

### Blockchain & Web3
- **reown_appkit: ^1.7.4** - WalletConnect v2 integration (successor to walletconnect_dart)
- Smart contracts on Ethereum Sepolia testnet

### Storage & Security
- **flutter_secure_storage: ^9.2.4** - Encrypted key-value storage (iOS Keychain, Android EncryptedSharedPreferences)
- **shared_preferences: ^2.5.3** - Local storage for non-sensitive data

### UI Components
- **flutter_svg: ^2.1.0** - SVG rendering
- **cached_network_image: ^3.4.1** - Image caching
- **pinput: ^5.0.1** - OTP input fields
- **flutter_rating_bar: ^4.0.1** - Star ratings
- **flutter_spinkit: ^5.2.1** - Loading indicators
- **photo_view: ^0.15.0** - Image zoom/pan
- **smooth_page_indicator: ^1.2.1** - Page indicators
- **skeletonizer: ^2.1.0+1** - Skeleton loading screens

### Device Features
- **mobile_scanner: ^7.0.1** - QR code scanning
- **nfc_manager: ^4.1.1** - NFC tag reading
- **flutter_nfc_hce: ^0.1.8** - NFC Host Card Emulation (Android only)
- **image_picker: ^1.1.2** - Camera/gallery access
- **file_picker: ^10.2.0** - File system access
- **device_info_plus: ^12.1.0** - Device information
- **package_info_plus: ^8.1.2** - App version info

### Utilities
- **intl: ^0.20.2** - Internationalization and date/number formatting
- **phone_numbers_parser: ^9.0.3** - Phone number validation
- **country_code_picker: ^3.3.0** - Country code selection
- **country_picker: ^2.0.27** - Country selection
- **clipboard: ^2.0.2** - Clipboard operations
- **qr_flutter: ^4.1.0** - QR code generation
- **url_launcher: ^6.3.2** - Open URLs and external apps
- **app_settings: ^6.1.1** - Navigate to system settings

### Development Tools
- **flutter_lints: ^3.0.0** - Dart/Flutter linting rules
- **build_runner: ^2.4.15** - Code generation runner
- **flutter_launcher_icons: ^0.14.4** - App icon generation
- **change_app_package_name: ^1.5.0** - Package name modification

---

## Project Structure

### Root Directory Layout

```
onchain-amex/
├── android/                    # Android-specific configuration
├── ios/                        # iOS-specific configuration
├── web/                        # Web platform support (limited)
├── assets/                     # Static assets
│   ├── app_icons/             # App launcher icons
│   ├── contracts/             # Smart contract ABIs (JSON)
│   ├── dummy/                 # Mock data for development
│   ├── icons/                 # UI icons (SVG, PNG)
│   ├── images/                # Images and illustrations
│   ├── rings/                 # Visual assets
│   └── tires/                 # Visual assets
├── fonts/                      # Custom fonts
│   ├── inter/                 # Inter font family
│   └── segoe_pro/             # Segoe Pro font family
├── lib/                        # Application source code
│   ├── main.dart              # Application entry point
│   ├── borrower/              # Borrower (customer) role features
│   ├── lender/                # Lender (investor) role features
│   ├── merchant/              # Merchant (payment receiver) features
│   ├── core/                  # Shared utilities and resources
│   └── infrastructure/        # Cross-cutting concerns
├── test/                       # Unit and widget tests
├── .github/                    # GitHub configuration
│   └── copilot-instructions.md # AI coding assistant guidelines
├── pubspec.yaml               # Dependencies and assets
├── analysis_options.yaml      # Linting rules
└── README.md                  # Project overview
```

### Feature Module Structure (per role)

Each role (`borrower`, `lender`, `merchant`) contains feature modules:

```
lib/borrower/
├── add_and_repay/             # Credit management
├── cards/                     # Virtual card management
├── delete_account/            # Account deletion
├── home/                      # Dashboard
├── invite_friend/             # Referral system
├── kyc/                       # Identity verification
├── more/                      # Settings and profile
├── onboard/                   # User onboarding
├── payment_methods/           # Payment options
├── rewards/                   # Rewards program
├── signin/                    # Authentication
├── skeleton/                  # Loading states
├── spends/                    # Payment transactions
├── splash/                    # App launch screen
├── transactions/              # Transaction history
└── wallet/                    # Wallet management
```

### Infrastructure Layer

```
lib/infrastructure/
├── database/                  # Local database (sqflite)
├── di/                        # Dependency Injection (GetIt)
│   ├── get_it_service.dart   # Service locator configuration
│   └── global_providers.dart # Riverpod global providers
├── error/                     # Error handling
│   └── app_error_handler.dart # Global error handler
├── navigation/                # Routing configuration
│   ├── app_nav.dart          # GoRouter setup with 3 shells
│   └── rt_nm.dart            # Route name constants
└── network/                   # API communication
    ├── api_urls.dart         # API endpoint constants
    ├── connectivity_service.dart # Network status monitoring
    ├── dio_service.dart      # HTTP client wrapper
    ├── headers_service.dart  # Request header management
    ├── response_model.dart   # API response wrapper
    └── result.dart           # Result type for error handling
```

### Core Layer

```
lib/core/
├── constants/                 # App-wide constants
│   └── contract_constants.dart # Blockchain addresses & config
├── extensions/                # Dart/Flutter extensions
├── resources/                 # Static resources
│   ├── app_colors.dart       # Color palette
│   ├── app_strings.dart      # Text constants
│   └── app_values.dart       # Numeric constants
├── services/                  # Shared services
│   └── secured_storage_service.dart # Encrypted storage
├── themes/                    # App theming
│   └── app_themes.dart       # Light/dark themes
├── use_cases/                 # Shared business logic
├── utils/                     # Helper functions
└── widgets/                   # Reusable widgets
    └── dialogs.dart          # Custom dialog components
```

---

## Core Components

### 1. Dependency Injection (GetIt)

**Location**: `lib/infrastructure/di/get_it_service.dart`

The application uses GetIt as a service locator for managing singleton instances:

```dart
final getIt = GetIt.instance;

// Service Registration (in main.dart or initialization)
getIt.registerSingleton(SecuredStorageService());
getIt.registerSingleton(ConnectivityService());
getIt.registerSingleton(DioService(headersService: HeadersService()));

// Service Access (anywhere in the app)
final storage = getIt<SecuredStorageService>();
final dio = getIt<DioService>();
final connectivity = getIt<ConnectivityService>();
```

**Registered Services**:
- `SecuredStorageService`: Encrypted local storage
- `ConnectivityService`: Internet connectivity monitoring
- `DioService`: HTTP client with interceptors
- `HeadersService`: Manages API request headers

### 2. State Management with Riverpod

**Global Providers** (`lib/infrastructure/di/global_providers.dart`):

```dart
// Secure Storage Provider
@riverpod
SecuredStorageService securedStorageService(SecuredStorageServiceRef ref) {
  return getIt<SecuredStorageService>();
}

// Logged-in User Provider
@riverpod
FutureOr<RegisterModel?> loggedInUser(LoggedInUserRef ref) async {
  final storage = ref.watch(securedStorageServiceProvider);
  return await storage.getLoggedInUser();
}

// Theme Mode Provider
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode? build() => null;
  
  void setThemeMode(ThemeMode mode) => state = mode;
}
```

**Feature-Specific Controllers** (example: `lib/borrower/signin/presentation/controllers/sign_in_controller.dart`):

```dart
@riverpod
class SignInController extends _$SignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    required String email,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    
    final repo = SignInRepo();
    final result = await repo.signIn(SignInDto(email: email));
    
    switch (result) {
      case Ok(:final data):
        AppNav.goRouter.push(RtNm.otpScreen, extra: email);
      case Error(:final error):
        showErrorDialog(context: context, message: error.message);
    }
    
    state = const AsyncData(null);
  }
}
```

### 3. Navigation System (GoRouter)

**Route Constants** (`lib/infrastructure/navigation/rt_nm.dart`):

```dart
class RtNm {
  RtNm._();
  
  // Authentication Routes
  static const splashScreen = '/';
  static const onboardScreen = '/onboard-screen';
  static const loginScreen = '/login-screen';
  static const otpScreen = '/otp-screen';
  
  // Borrower Routes
  static const homeScreen = '/home-screen';
  static const spendsScreen = '/spends-screen';
  static const cardsScreen = '/cards-screen';
  static const rewardsScreen = '/rewards-screen';
  static const moreScreen = '/more-screen';
  
  // Lender Routes
  static const lenderHomeScreen = '/lender-home-screen';
  static const depositScreen = '/deposit-screen';
  
  // Merchant Routes
  static const merchantHomeScreen = '/merchant-home-screen';
  static const paymentScreen = '/payment-screen';
}
```

**Router Configuration** (`lib/infrastructure/navigation/app_nav.dart`):

The app uses three separate navigation shells for each user role:

```dart
class AppNav {
  static final navKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  
  static final goRouter = GoRouter(
    navigatorKey: navKey,
    initialLocation: RtNm.splashScreen,
    routes: [
      // Auth Routes (no shell)
      ..._authRoutes,
      
      // Borrower Shell (bottom navigation with 5 tabs)
      StatefulShellRoute.indexedStack(
        branches: _borrowerShellRoutes,
        // Home, Spends, Cards, Rewards, More tabs
      ),
      
      // Lender Shell (separate navigation)
      StatefulShellRoute.indexedStack(
        branches: _lenderShellRoutes,
      ),
      
      // Merchant Routes (POS terminal UI)
      ..._merchantRoutes,
    ],
  );
}
```

**Context-Free Navigation**:

```dart
// Push a new route
AppNav.goRouter.push(RtNm.paymentScreen, extra: scannedData);

// Replace current route
AppNav.goRouter.go(RtNm.homeScreen);

// Pop current route
AppNav.goRouter.pop();

// Await result from pushed screen
final result = await AppNav.goRouter.push(RtNm.otpScreen, extra: email);
```

### 4. API Communication Layer

**Base Configuration** (`lib/infrastructure/network/api_urls.dart`):

```dart
class ApiUrls {
  ApiUrls._();
  
  static const urlBase = 'http://44.221.101.170:3000/api/v1';
  
  // Auth Endpoints
  static const signIn = '$urlBase/auth/login';
  static const verifyOtp = '$urlBase/auth/verify-otp';
  static const register = '$urlBase/auth/register';
  
  // User Endpoints
  static const getProfile = '$urlBase/user/profile';
  static const updateProfile = '$urlBase/user/profile';
  
  // Transaction Endpoints
  static const getTransactions = '$urlBase/transactions';
  static const createTransaction = '$urlBase/transactions';
}
```

**HTTP Client** (`lib/infrastructure/network/dio_service.dart`):

```dart
class DioService {
  final Dio _dio;
  final HeadersService _headersService;
  
  DioService({required HeadersService headersService})
      : _headersService = headersService,
        _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        )) {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }
  
  Future<ResponseModel> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool useTokenizeHeader = false,
  }) async {
    try {
      final headers = useTokenizeHeader
          ? await _headersService.getTokenizedHeaders()
          : _headersService.getHeaders();
      
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ResponseModel.fromResponse(response);
    } on DioException catch (e) {
      return ResponseModel.fromDioException(e);
    }
  }
  
  Future<ResponseModel> post(
    String url, {
    dynamic data,
    bool useTokenizeHeader = false,
  }) async {
    try {
      final headers = useTokenizeHeader
          ? await _headersService.getTokenizedHeaders()
          : _headersService.getHeaders();
      
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      
      return ResponseModel.fromResponse(response);
    } on DioException catch (e) {
      return ResponseModel.fromDioException(e);
    }
  }
}
```

**Response Handling** (`lib/infrastructure/network/response_model.dart`):

```dart
class ResponseModel {
  final bool success;
  final String message;
  final dynamic body;
  final int? statusCode;
  
  ResponseModel({
    required this.success,
    required this.message,
    this.body,
    this.statusCode,
  });
  
  factory ResponseModel.fromResponse(Response response) {
    return ResponseModel(
      success: true,
      message: 'Success',
      body: response.data,
      statusCode: response.statusCode,
    );
  }
  
  factory ResponseModel.fromDioException(DioException e) {
    return ResponseModel(
      success: false,
      message: _extractErrorMessage(e),
      body: e.response?.data,
      statusCode: e.response?.statusCode,
    );
  }
  
  Result<T> toResult<T>({
    required T Function(dynamic data) dataHandler,
  }) {
    if (success) {
      return Ok(data: dataHandler(body));
    } else {
      return Error(error: ErrorModel(message: message, code: statusCode));
    }
  }
}
```

**Result Pattern** (`lib/infrastructure/network/result.dart`):

```dart
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  final T data;
  const Ok({required this.data});
}

final class Error<T> extends Result<T> {
  final ErrorModel error;
  const Error({required this.error});
}

// Usage in repositories
Future<Result<UserModel?>> getUser() async {
  final response = await getIt<DioService>().get(
    ApiUrls.getProfile,
    useTokenizeHeader: true,
  );
  
  return response.toResult<UserModel?>(
    dataHandler: (json) => json != null ? UserModel.fromJson(json) : null,
  );
}

// Usage in controllers
switch (result) {
  case Ok(:final data):
    // Handle success
    print('User: ${data.name}');
  case Error(:final error):
    // Handle error
    showErrorDialog(context: context, message: error.message);
}
```

### 5. Secure Storage Service

**Location**: `lib/core/services/secured_storage_service.dart`

```dart
class SecuredStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  // Token Management
  Future<void> saveUserTokens(RegisterModel user) async {
    await _storage.write(
      key: 'user_data',
      value: jsonEncode(user.toJson()),
    );
  }
  
  Future<RegisterModel?> getLoggedInUser() async {
    final jsonString = await _storage.read(key: 'user_data');
    if (jsonString == null) return null;
    return RegisterModel.fromJson(jsonDecode(jsonString));
  }
  
  Future<String?> getAccessToken() async {
    final user = await getLoggedInUser();
    return user?.accessToken;
  }
  
  Future<void> clearUserData() async {
    await _storage.delete(key: 'user_data');
  }
}
```

### 6. Dialog System

**Location**: `lib/core/widgets/dialogs.dart`

```dart
void showSuccessDialog({
  required BuildContext context,
  required String message,
  VoidCallback? onOk,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Icon(Icons.check_circle, color: Colors.green, size: 48),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onOk?.call();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showErrorDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Icon(Icons.error, color: Colors.red, size: 48),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showLoadingDialog({
  required BuildContext context,
  String? message,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message ?? 'Loading...'),
          ],
        ),
      ),
    ),
  );
}

void hideDialog() {
  if (AppNav.navKey.currentContext != null) {
    Navigator.of(AppNav.navKey.currentContext!).pop();
  }
}
```

---

## User Roles & Features

### Role 1: Borrower (Customer)

**Navigation Shell**: Bottom navigation with 5 tabs

#### Home Tab (`lib/borrower/home/`)
- Dashboard with credit overview
- Available credit display
- Quick action buttons
- Recent transactions summary

#### Spends Tab (`lib/borrower/spends/`)
- **Payment Screen**: Scan QR codes to make payments
- **Manual Payment Screen**: Manually enter wallet address and amount
- Transaction history
- Payment confirmation

#### Cards Tab (`lib/borrower/cards/`)
- Virtual card management
- Card details (number, CVV, expiry)
- Card activation/deactivation
- Card spending limits

#### Rewards Tab (`lib/borrower/rewards/`)
- XP points tracking
- Rewards catalog
- Redemption history
- Referral bonuses

#### More Tab (`lib/borrower/more/`)
- User profile
- Settings
- KYC verification
- Invite friends
- Delete account
- Logout

#### Additional Borrower Features
- **Add & Repay** (`lib/borrower/add_and_repay/`):
  - Add funds to credit line
  - Repay outstanding balance
  - View repayment history
  
- **Wallet** (`lib/borrower/wallet/`):
  - Connect Web3 wallet via Reown AppKit
  - View wallet balance
  - Transaction signing

- **Transactions** (`lib/borrower/transactions/`):
  - Complete transaction history
  - Filter by date, type, status
  - Transaction details with blockchain explorer links

### Role 2: Lender (Investor)

**Navigation Shell**: Custom navigation for lending features

#### Lender Home (`lib/lender/home/`)
- Total deposits overview
- Interest earned
- Active lending positions
- Portfolio performance

#### Deposit (`lib/lender/deposit/`)
- Deposit USDC to lending pool
- Approve token spending
- Transaction confirmation
- Deposit history

#### Lender Wallet (`lib/lender/wallet/`)
- Connect wallet for deposits
- View available USDC balance
- Gas fee estimation

#### Lender Transactions (`lib/lender/lender_transactions/`)
- Deposit history
- Interest payments
- Withdrawal history

### Role 3: Merchant (Payment Receiver)

**Navigation Structure**: Dedicated merchant POS interface

#### Merchant Home (`lib/merchant/home/`)
- Daily sales summary
- Total payments received
- Active payment requests
- Quick payment button

#### Payment (`lib/merchant/payment/`)
- **QR Code Generation**: Generate payment QR codes
- **NFC Payment Widget**: Accept NFC payments (Android only)
- Amount input with numeric keypad
- Payment status tracking
- Receipt generation

#### Merchant Navbar (`lib/merchant/navbar/`)
- Custom navigation for merchant-specific actions
- Quick access to payment history
- Settings and profile

#### Merchant Transactions (`lib/merchant/merchant_transactions/`)
- All received payments
- Daily/weekly/monthly summaries
- Export transaction data
- Refund management

---

## Blockchain Integration

### Network Configuration

**Ethereum Sepolia Testnet**

- **Chain ID**: 11155111
- **RPC URL**: `https://ethereum-sepolia-rpc.publicnode.com`
- **Network Name**: Sepolia
- **Block Explorer**: `https://sepolia.etherscan.io`

### Smart Contracts

**Contract Addresses** (`lib/core/constants/contract_constants.dart`):

```dart
// Main Contracts
static const vaultAddress = '0x38e175Ec2Ea562556F9fD419a05A4c68d56CC62c';
static const usdcAddress = '0x015484B89112349a694E65801B102533ED556a50';
static const creditorAddress = '0x19fF92707952F374980C4a476a37F4290f160ac9';

// Supporting Contracts
static const accessControlAddress = '0x3a9eAd412f769C76F181a31805C4f7f37D23B08d';
static const creditAddress = '0x1229bBE32BC91875b323fA7DD32B01e05E76E1d2';
static const treasuryAddress = '0xF32a3083a95641C6DEC7CB57ba0B9D4437D2847b';
static const xpTokenAddress = '0x0EC91fC280dF5C88138824CBcFe1D269CFF19763';
static const lenderAddress = '0xa078fCE86e02E51df63A7A5c592543769D201f07';
static const aavePoolAddress = '0xcb10119f7c0093515e1e2B562c4A13F8D870F680';
static const aTokenAddress = '0xa5B2Df514562d52934fADb87f82904EEfFbCd303';
```

### Contract ABIs

**Location**: `assets/contracts/`

- **usdc.json**: ERC-20 token ABI for USDC
- **TMRWVault.json**: Vault contract for deposits
- **Creditor.json**: Credit issuance contract
- **Lender.json**: Lending pool contract

### Wallet Integration with Reown AppKit

**Reown AppKit** (formerly WalletConnect) is used for Web3 wallet connections.

**Provider Setup**:

```dart
@riverpod
ReownAppKitModal appkitModal(AppkitModalRef ref) {
  return ReownAppKitModal(
    context: ref.context,
    projectId: 'YOUR_WALLETCONNECT_PROJECT_ID',
    metadata: const PairingMetadata(
      name: 'Onchain Amex',
      description: 'Crypto-native POS terminal',
      url: 'https://onchainamex.com',
      icons: ['https://onchainamex.com/icon.png'],
      redirect: Redirect(
        native: 'onchainamex://',
        universal: 'https://onchainamex.com',
      ),
    ),
  );
}
```

**Connecting Wallet**:

```dart
// In widget/controller
final appKitModal = ref.watch(appkitModalProvider);

// Show wallet connection modal
await appKitModal.openModalView();

// Check connection status
if (appKitModal.isConnected) {
  final address = appKitModal.session?.address;
  print('Connected wallet: $address');
}

// Disconnect wallet
await appKitModal.disconnect();
```

**Signing Transactions**:

```dart
// Approve token spending
final approveResult = await appKitModal.requestWriteContract(
  topic: appKitModal.session!.topic,
  chainId: 'eip155:${ContractConstants.chainId}',
  deployedContract: DeployedContract(
    ContractAbi.fromJson(usdcAbiJson, 'USDC'),
    EthereumAddress.fromHex(ContractConstants.usdcAddress),
  ),
  functionName: 'approve',
  parameters: [
    EthereumAddress.fromHex(spenderAddress),
    BigInt.from(amount * pow(10, 6)), // USDC has 6 decimals
  ],
  transaction: Transaction(
    from: EthereumAddress.fromHex(appKitModal.session!.address!),
    to: EthereumAddress.fromHex(ContractConstants.usdcAddress),
    gasLimit: BigInt.from(ContractConstants.approveGasLimit),
  ),
);

// Monitor transaction status
final txHash = approveResult as String;
print('Transaction hash: $txHash');
```

### Gas Configuration

```dart
static const int defaultGasLimit = 300000;
static const int approveGasLimit = 100000;
static const int mintGasLimit = 100000;
```

### Payment Flow (Borrower Spending)

1. **Scan QR Code** or **Manual Entry**: Get recipient wallet address and amount
2. **Validate Available Credit**: Check borrower's credit limit
3. **Connect Wallet**: Use Reown AppKit to connect Web3 wallet
4. **Approve Token Spending**: Sign approval transaction for USDC
5. **Execute Payment**: Call `creditor.spend()` contract method
6. **Confirmation**: Display transaction hash and success message
7. **Update UI**: Refresh available credit and transaction history

### Deposit Flow (Lender Investment)

1. **Connect Wallet**: Lender connects wallet with USDC balance
2. **Enter Deposit Amount**: Input amount to deposit
3. **Approve USDC**: Sign approval for vault contract to spend USDC
4. **Deposit to Vault**: Call `vault.deposit()` method
5. **Receive aTokens**: Lender receives interest-bearing aTokens
6. **Track Position**: View deposit in lender dashboard

---

## State Management

### Riverpod Patterns

#### 1. Simple State Provider

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
}

// Usage
final count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).increment();
```

#### 2. Async Data Provider

```dart
@riverpod
Future<List<Transaction>> transactions(TransactionsRef ref) async {
  final repo = TransactionRepo();
  final result = await repo.getTransactions();
  
  return switch (result) {
    Ok(:final data) => data,
    Error(:final error) => throw error,
  };
}

// Usage
final transactionsAsync = ref.watch(transactionsProvider);

transactionsAsync.when(
  data: (transactions) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

#### 3. Controller with AsyncValue

```dart
@riverpod
class PaymentController extends _$PaymentController {
  @override
  FutureOr<void> build() {}
  
  Future<void> doPayment({
    required num availableCredit,
    required ScannedData scannedData,
    required String amountStr,
  }) async {
    state = const AsyncLoading();
    
    try {
      final amount = num.parse(amountStr);
      
      if (amount > availableCredit) {
        throw Exception('Insufficient credit');
      }
      
      final walletService = WalletService();
      final txHash = await walletService.spend(
        recipientAddress: scannedData.walletAddress!,
        amount: amount,
      );
      
      state = const AsyncData(null);
      
      AppNav.goRouter.push(RtNm.paymentSuccessScreen, extra: txHash);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// Usage
ref.listen(paymentControllerProvider, (prev, next) {
  next.when(
    data: (_) => print('Payment successful'),
    loading: () => showLoadingDialog(context: context),
    error: (error, _) => showErrorDialog(context: context, message: error.toString()),
  );
});

ref.read(paymentControllerProvider.notifier).doPayment(
  availableCredit: availableCredit,
  scannedData: scannedData,
  amountStr: amountController.text,
);
```

#### 4. Family Provider (Parameterized)

```dart
@riverpod
Future<Transaction> transaction(
  TransactionRef ref,
  String transactionId,
) async {
  final repo = TransactionRepo();
  final result = await repo.getTransactionById(transactionId);
  
  return switch (result) {
    Ok(:final data) => data,
    Error(:final error) => throw error,
  };
}

// Usage
final transaction = ref.watch(transactionProvider('tx_123'));
```

#### 5. Provider Dependencies

```dart
@riverpod
FutureOr<Profile?> profile(ProfileRef ref) async {
  // Watch another provider
  final user = await ref.watch(loggedInUserProvider.future);
  if (user == null) return null;
  
  final repo = ProfileRepo();
  final result = await repo.getProfile(user.id);
  
  return switch (result) {
    Ok(:final data) => data,
    Error() => null,
  };
}

// Available credit depends on profile
@riverpod
FutureOr<num?> availableCredit(AvailableCreditRef ref) async {
  final profile = await ref.watch(profileProvider.future);
  return profile?.availableCredit;
}
```

### Code Generation

**Run code generation**:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

**Generated files**: `*.g.dart` files alongside `@riverpod` annotated files

---

## Navigation System

### Three Navigation Shells

#### 1. Borrower Shell (Bottom Navigation)

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return BorrowerScaffold(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RtNm.homeScreen,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RtNm.spendsScreen,
          builder: (context, state) => const SpendsScreen(),
        ),
      ],
    ),
    // Cards, Rewards, More branches...
  ],
)
```

#### 2. Lender Shell

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return LenderScaffold(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RtNm.lenderHomeScreen,
          builder: (context, state) => const LenderHomeScreen(),
        ),
      ],
    ),
    // Other lender branches...
  ],
)
```

#### 3. Merchant Routes (No Shell)

```dart
GoRoute(
  path: RtNm.merchantHomeScreen,
  builder: (context, state) => const MerchantHomeScreen(),
  routes: [
    GoRoute(
      path: 'payment',
      builder: (context, state) => PaymentScreen(
        scannedData: state.extra as ScannedData,
      ),
    ),
  ],
)
```

### Route Registration Workflow

1. **Add route constant** to `lib/infrastructure/navigation/rt_nm.dart`:
   ```dart
   static const myScreen = '/my-screen';
   ```

2. **Register route** in `lib/infrastructure/navigation/app_nav.dart`:
   ```dart
   GoRoute(
     path: RtNm.myScreen,
     pageBuilder: (context, state) => fadeTransitionPageBuilder(
       MyScreen(data: state.extra as MyModel),
       state,
     ),
   )
   ```

3. **Navigate to route**:
   ```dart
   AppNav.goRouter.push(RtNm.myScreen, extra: myData);
   ```

### Page Transitions

```dart
Page fadeTransitionPageBuilder(Widget screen, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
```

### Deep Linking

Configure platform-specific deep links:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="onchainamex" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>onchainamex</string>
    </array>
  </dict>
</array>
```

---

## API Architecture

### Repository Pattern

#### Repository Interface (Business Layer)

```dart
// lib/borrower/signin/business/repository/sign_in_repo_interface.dart
abstract class SignInRepoInterface {
  Future<Result<void>> signIn(SignInDto dto);
  Future<Result<RegisterModel>> verifyOtp(VerifyOtpDto dto);
}
```

#### Repository Implementation (Data Layer)

```dart
// lib/borrower/signin/data/repositories/sign_in_repo.dart
class SignInRepo implements SignInRepoInterface {
  @override
  Future<Result<void>> signIn(SignInDto dto) async {
    final response = await getIt<DioService>().post(
      ApiUrls.signIn,
      data: dto.toJson(),
    );
    
    return response.toResult<void>(
      dataHandler: (_) => null,
    );
  }
  
  @override
  Future<Result<RegisterModel>> verifyOtp(VerifyOtpDto dto) async {
    final response = await getIt<DioService>().post(
      ApiUrls.verifyOtp,
      data: dto.toJson(),
    );
    
    return response.toResult<RegisterModel>(
      dataHandler: (json) => RegisterModel.fromJson(json),
    );
  }
}
```

### Data Models

#### Domain Model

```dart
// lib/borrower/signin/data/models/register_model.dart
class RegisterModel {
  final String id;
  final String email;
  final String? name;
  final String accessToken;
  final String refreshToken;
  
  RegisterModel({
    required this.id,
    required this.email,
    this.name,
    required this.accessToken,
    required this.refreshToken,
  });
  
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
```

#### Data Transfer Object (DTO)

```dart
// lib/borrower/signin/data/dto/sign_in_dto.dart
class SignInDto {
  final String email;
  
  SignInDto({required this.email});
  
  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
```

### Error Handling Strategy

1. **Never throw exceptions in repositories** - wrap in `Result.error()`
2. **Controllers switch on Result** - show dialogs for errors
3. **Network errors** - `DioService` converts to user-friendly messages
4. **Validation errors** - handled at presentation layer before API calls

---

## Security & Storage

### Encrypted Storage

**Platform-Specific Security**:

- **iOS**: Keychain (hardware-backed encryption)
- **Android**: EncryptedSharedPreferences

**Stored Data**:

- User authentication tokens (access & refresh)
- User profile data (serialized JSON)
- App preferences
- Wallet connection data

**Never Store**:

- Private keys (use Reown AppKit for signing)
- Plain text passwords
- Sensitive financial data

### Authentication Flow

1. **Login**: User enters email
2. **OTP Sent**: Backend sends verification code
3. **Verify OTP**: User enters code
4. **Tokens Issued**: Backend returns access & refresh tokens
5. **Store Tokens**: `SecuredStorageService` saves encrypted tokens
6. **Auto-Login**: App checks for valid tokens on launch
7. **Token Refresh**: Refresh token used when access token expires
8. **Logout**: Clear all stored tokens and user data

### Authorization Headers

```dart
// lib/infrastructure/network/headers_service.dart
class HeadersService {
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
  Future<Map<String, String>> getTokenizedHeaders() async {
    final storage = getIt<SecuredStorageService>();
    final token = await storage.getAccessToken();
    
    return {
      ...getHeaders(),
      'Authorization': 'Bearer $token',
    };
  }
}
```

---

## Development Guidelines

### File Naming Conventions

- **Screens**: `[feature]_screen.dart` (e.g., `login_with_email_screen.dart`)
- **Controllers**: `[feature]_controller.dart` (e.g., `sign_in_controller.dart`)
- **Repositories**: `[feature]_repo.dart` and `[feature]_repo_interface.dart`
- **Models**: `[entity]_model.dart` (e.g., `register_model.dart`)
- **DTOs**: `[action]_dto.dart` (e.g., `register_dto.dart`)
- **Widgets**: `[component]_widget.dart` (e.g., `payment_card_widget.dart`)

### Code Style

- **Formatting**: 2-space indentation
- **Linting**: Enabled via `flutter_lints: ^3.0.0` and `riverpod_lint: ^2.3.10`
- **Imports**: Use relative paths for local files
- **Constants**: Centralized in `lib/core/resources/`
- **Comments**: Use `///` for public API documentation

**Format code**:

```bash
dart format .
```

**Analyze code**:

```bash
flutter analyze
```

### Adding New Features

1. **Create feature directory**: `lib/[role]/[feature]/`
2. **Define repository interface**: `business/repository/[feature]_repo_interface.dart`
3. **Implement repository**: `data/repositories/[feature]_repo.dart` using `DioService`
4. **Create controller**: `presentation/controllers/[feature]_controller.dart` with Riverpod
5. **Build screens**: `presentation/screens/` consuming controller providers
6. **Register routes**: Add constants to `rt_nm.dart` and routes to `app_nav.dart`
7. **Generate code**: Run `build_runner` for Riverpod code generation
8. **Test**: Write unit tests for business logic

### Git Workflow

**Branch Naming**:
- `feat/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `refactor/component-name` - Code refactoring
- `docs/update-description` - Documentation updates

**Commit Messages**:
```
feat: add manual payment screen
fix: resolve wallet connection issue
refactor: simplify payment controller logic
docs: update API documentation
```

---

## Testing & Debugging

### Running the App

```bash
# Debug mode (hot reload enabled)
flutter run

# Release mode (optimized)
flutter run --release

# Specific device
flutter run -d <device_id>

# iOS simulator
flutter run -d ios

# Android emulator
flutter run -d android

# Chrome browser (limited blockchain features)
flutter run -d chrome
```

### Device-Specific Features

- **NFC Payments**: Android only via `flutter_nfc_hce: ^0.1.8`
- **QR Scanning**: Cross-platform with `mobile_scanner: ^7.0.1`
- **Wallet Connection**: Works on iOS/Android; Web3 modal adapts to platform

### Debugging Tools

**Flutter DevTools**:

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

**Riverpod Inspector**: View provider state in DevTools

**Network Inspector**: Monitor Dio requests/responses

**Blockchain Explorer**: [Sepolia Etherscan](https://sepolia.etherscan.io)

### Common Issues

#### "No internet" Error
- Check `ConnectivityService.checkInternet()`
- Verify device network settings
- Test with public WiFi or mobile data

#### 401 Unauthorized
- Verify token in `HeadersService.getTokenizedHeaders()`
- Check `SecuredStorageService` for valid tokens
- Re-authenticate if tokens expired

#### Navigation Not Working
- Ensure route registered in correct shell
- Verify route constant in `rt_nm.dart`
- Check for typos in route paths

#### AppKit Modal Not Showing
- Confirm `appkitModalProvider` initialized
- Check WalletConnect project ID
- Verify network connectivity

#### Transaction Failing
- Check wallet USDC balance
- Verify gas limit configuration
- Ensure contract addresses correct
- Check Sepolia testnet status

### Logging

**Enable verbose logging**:

```dart
import 'dart:developer' as developer;

developer.log('Message', name: 'MyFeature');
```

**Dio logging** (enabled by default in `DioService`):
- Request: Method, URL, headers, body
- Response: Status code, data
- Error: Status code, error message

---

## Deployment

### Android Deployment

1. **Configure app**:
   ```bash
   cd android
   ./gradlew build
   ```

2. **Generate signing key**:
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

3. **Build APK**:
   ```bash
   flutter build apk --release
   ```

4. **Build App Bundle** (for Play Store):
   ```bash
   flutter build appbundle --release
   ```

### iOS Deployment

1. **Configure Xcode project**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Set bundle identifier
   - Configure signing certificates

2. **Build IPA**:
   ```bash
   flutter build ios --release
   ```

3. **Archive in Xcode**:
   - Product → Archive
   - Distribute to App Store or TestFlight

### Environment Configuration

**Development**:
```dart
const apiBaseUrl = 'http://44.221.101.170:3000/api/v1';
const networkName = 'Sepolia';
```

**Production** (when ready):
```dart
const apiBaseUrl = 'https://api.onchainamex.com/v1';
const networkName = 'Ethereum Mainnet';
const chainId = 1;
```

### App Versioning

**pubspec.yaml**:
```yaml
version: 1.1.29+30
# Format: major.minor.patch+buildNumber
```

**Increment version**:
```bash
# Update version in pubspec.yaml
# Then rebuild
flutter clean
flutter pub get
flutter build apk --release
```

---

## Troubleshooting

### Build Issues

**Problem**: `flutter pub get` fails

**Solution**:
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**Problem**: Code generation not working

**Solution**:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Problem**: Android build fails

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Runtime Issues

**Problem**: Blank screen on launch

**Solution**:
- Check `main.dart` initialization
- Verify GetIt services registered
- Check for errors in debug console

**Problem**: Wallet not connecting

**Solution**:
- Verify WalletConnect project ID
- Check network connectivity
- Ensure wallet app installed on device
- Review Reown AppKit configuration

**Problem**: Transactions failing

**Solution**:
- Check Sepolia testnet RPC status
- Verify gas limit configuration
- Ensure sufficient testnet ETH for gas
- Check contract addresses

### Performance Issues

**Problem**: Slow app startup

**Solution**:
- Profile with Flutter DevTools
- Lazy-load Riverpod providers
- Optimize image assets
- Use cached network images

**Problem**: High memory usage

**Solution**:
- Dispose controllers properly
- Use `AutoDisposeAsyncNotifier` for Riverpod
- Clear image cache periodically
- Profile with Memory view in DevTools

---

## Appendix

### Useful Commands

```bash
# Run app
flutter run

# Build release APK
flutter build apk --release

# Format code
dart format .

# Analyze code
flutter analyze

# Generate Riverpod code
flutter pub run build_runner watch

# Clean project
flutter clean && flutter pub get

# Check Flutter setup
flutter doctor

# List connected devices
flutter devices

# Update dependencies
flutter pub upgrade

# Create launcher icons
flutter pub run flutter_launcher_icons:main
```

### Resources

- **Flutter Documentation**: https://docs.flutter.dev
- **Riverpod Documentation**: https://riverpod.dev
- **Go Router Documentation**: https://pub.dev/packages/go_router
- **Reown AppKit**: https://docs.reown.com/appkit/flutter/core/installation
- **Ethereum Sepolia**: https://sepolia.etherscan.io
- **Dio Package**: https://pub.dev/packages/dio

### Contact & Support

- **Repository**: https://github.com/amitbiswas1992/onchain-amex
- **Issues**: Report bugs and feature requests via GitHub Issues
- **Documentation**: `.github/copilot-instructions.md` for AI-assisted development

---

**Last Updated**: November 13, 2025  
**Version**: 1.1.29+30  
**Flutter SDK**: >=3.4.1 <4.0.0
