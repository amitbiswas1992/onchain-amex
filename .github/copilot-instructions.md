# Onchain Amex - AI Agent Instructions

## Project Overview
Flutter-based crypto-native POS terminal for accepting stablecoin payments (USDC, USDT, DAI) on Ethereum Sepolia testnet. Supports three user roles: **Borrower** (customer), **Lender** (investor), and **Merchant** (payment receiver) with separate navigation flows for each.

## Architecture

### Clean Architecture Pattern
```
lib/[role]/[feature]/
  ├── presentation/     # Screens, controllers (Riverpod)
  │   ├── screens/
  │   └── controllers/
  ├── business/        # Repository interfaces
  │   └── repository/
  └── data/            # Repository implementations, DTOs, models
      ├── repositories/
      ├── dto/
      └── models/
```

**Example**: `lib/borrower/signin/` contains auth logic with `SignInRepoInterface` (business layer) implemented by `SignInRepo` (data layer), consumed by `SignInController` (presentation).

### Multi-Role Navigation
- **Three separate navigation shells** defined in `lib/infrastructure/navigation/app_nav.dart`:
  - `_borrowerShellRoutes`: Customer-facing shell with tab navigation (Home, Spends, Cards, Rewards, More)
  - `_lenderShellRoutes`: Investor shell with deposit/withdrawal featuresP
  - `_merchantRoutes`: Uses `StatefulShellRoute.indexedStack` for POS terminal UI
- **Route constants** centralized in `lib/infrastructure/navigation/rt_nm.dart` (e.g., `RtNm.homeScreen`)
- **Context-free navigation**: Use `AppNav.goRouter.push()` / `.go()` anywhere via static `navKey`

### Blockchain Integration
- **Network**: Ethereum Sepolia testnet (chainId: 11155111)
- **Smart contracts** in `lib/core/constants/contract_constants.dart`:
  - `vaultAddress`: TMRWVault for deposit management
  - `usdcAddress`: USDC token contract
  - `creditorAddress`: Credit issuance contract
- **Wallet**: Reown AppKit (WalletConnect v2 successor) via `reown_appkit: ^1.7.0`
  - Provider: `appkitModalProvider` in Riverpod (see `lib/borrower/add_and_repay/presentation/screens/repay_found_screen.dart`)
  - Connect wallets with `ReownAppKitModal`
- **RPC**: Public endpoint `https://ethereum-sepolia-rpc.publicnode.com` (read-only; transactions via WalletConnect)

### State Management
- **Riverpod 2.5.1** with code generation (`@riverpod` annotations)
- **GetIt** for singleton services (DI setup in `lib/infrastructure/di/get_it_service.dart`):
  ```dart
  getIt.registerSingleton(SecuredStorageService());
  getIt.registerSingleton(ConnectivityService());
  getIt.registerSingleton(DioService(headersService: HeadersService()));
  ```
- Access GetIt services: `getIt<DioService>()` or via Riverpod providers in `lib/infrastructure/di/global_providers.dart`

### API Communication
- **Base URL**: `http://44.221.101.170:3000/api/v1` (in `lib/infrastructure/network/api_urls.dart`)
- **HTTP client**: Dio with interceptors for logging and error handling (see `lib/infrastructure/network/dio_service.dart`)
- **Response wrapper**: `ResponseModel` with `success`, `message`, `body` fields
  - Convert to `Result<T>`: `responseModel.toResult<UserModel>(dataHandler: (data) => UserModel.fromJson(data))`
- **Result pattern**: Sealed class `Result<T>` with `Ok` and `Error` cases for type-safe error handling
  ```dart
  switch (result) {
    case Ok(): print(result.data);
    case Error(): showErrorDialog(context: context, message: result.error.message);
  }
  ```

## Development Workflows

### Adding New Features
1. **Create feature directory**: `lib/[role]/[feature]/`
2. **Define repository interface**: `business/repository/[feature]_repo_interface.dart`
3. **Implement repository**: `data/repositories/[feature]_repo.dart` using `DioService` from GetIt
4. **Create controller**: `presentation/controllers/[feature]_controller.dart` with Riverpod
5. **Build screens**: `presentation/screens/` consuming controller providers
6. **Register routes**: Add constants to `rt_nm.dart` and routes to `app_nav.dart` in appropriate shell

### Working with Navigation
- **New screen registration**:
  1. Add constant: `static const myScreen = '/my-screen';` in `rt_nm.dart`
  2. Add route in `app_nav.dart`:
     ```dart
     GoRoute(
       path: RtNm.myScreen,
       pageBuilder: (context, state) => fadeTransitionPageBuilder(
         MyScreen(data: state.extra as MyModel),
         state,
       ),
     )
     ```
  3. Navigate: `AppNav.goRouter.push(RtNm.myScreen, extra: myData)`
- **Passing data**: Use `extra` parameter (type-cast in destination screen constructor)
- **Awaiting result**: `final result = await AppNav.goRouter.push(RtNm.otpScreen)` then check for null

### API Integration Pattern
```dart
// In repository implementation
Future<Result<MyModel?>> fetchData() async {
  final response = await getIt<DioService>().get(
    '${ApiUrls.urlBase}/endpoint',
    useTokenizeHeader: true, // Adds Authorization header from SecuredStorageService
  );
  return response.toResult<MyModel?>(
    dataHandler: (json) => json != null ? MyModel.fromJson(json) : null,
  );
}
```

### Dialog System
- **Custom dialogs** in `lib/core/widgets/dialogs.dart`:
  - `showSuccessDialog(context: context, message: 'Operation successful')`
  - `showErrorDialog(context: context, message: error.message)`
  - `showLoadingDialog(context: context, message: 'Processing...')`
  - `hideDialog()` to dismiss programmatically
- **Always await** dialog operations to ensure UI state consistency

### Blockchain Transactions
1. **Initialize wallet**: Access `appkitModalProvider` from Riverpod
2. **Connect wallet**: Show modal via `appKitModal.openModalView()`
3. **Sign transaction**: Use `appKitModal.requestWriteContract()` with contract ABI (in `assets/contracts/`)
4. **Monitor status**: Check `appKitModal.status` for connection state
5. **Gas configuration**: Use `ContractConstants.defaultGasLimit` (300,000) or specific limits

## Project Conventions

### File Naming
- **Screens**: `[feature]_screen.dart` (e.g., `login_with_email_screen.dart`)
- **Controllers**: `[feature]_controller.dart` (e.g., `sign_in_controller.dart`)
- **Repositories**: `[feature]_repo.dart` and `[feature]_repo_interface.dart`
- **Models**: `[entity]_model.dart` (e.g., `register_model.dart`)
- **DTOs**: `[action]_dto.dart` (e.g., `register_dto.dart`)

### Code Style
- **Formatting**: Run `dart format .` before committing (project uses 2-space indentation)
- **Linting**: Enabled via `flutter_lints: ^3.0.0` and `riverpod_lint: ^2.3.10`
- **Imports**: Organize with relative paths; avoid package imports for local files
- **Constants**: Centralize in `lib/core/resources/` (colors, strings, values)

### Error Handling
- **Repositories return `Result<T>`**: Never throw exceptions; wrap in `Result.error()`
- **Controllers switch on Result**: Show dialogs for errors, navigate on success
- **Network errors**: `DioService` converts `DioException` to user-friendly messages in `ResponseModel`

### Secure Storage
- **Token persistence**: Use `SecuredStorageService` (via GetIt) with platform-specific encryption:
  - Android: `encryptedSharedPreferences: true`
  - iOS: Keychain by default
- **Save tokens**: `await getIt<SecuredStorageService>().saveUserTokens(registerModel)`
- **User data**: Store/retrieve serialized JSON for `RegisterModel` with access/refresh tokens

## Testing & Debugging

### Running the App
```bash
flutter run                    # Start in debug mode
flutter run --release          # Production build
flutter run -d chrome          # Web browser (for testing, blockchain features limited)
```

### Device-Specific Features
- **NFC payments**: Android only via `flutter_nfc_hce: ^0.1.8` (see `lib/merchant/payment/presentation/widgets/nfc_payment_widget.dart`)
- **QR scanning**: Cross-platform with `mobile_scanner: ^7.0.1`
- **Wallet connection**: Works on iOS/Android; Web3 modal UI adapts to platform

### Common Issues
- **"No internet"**: Check `ConnectivityService.checkInternet()` - uses `connectivity_plus` package
- **401 Unauthorized**: Verify token in `HeadersService.getTokenizedHeaders()` (check `SecuredStorageService`)
- **Navigation not working**: Ensure route is registered in correct shell (`_borrowerShellRoutes`, `_lenderShellRoutes`, or `_merchantRoutes`)
- **AppKit modal not showing**: Confirm `appkitModalProvider` is initialized before calling `openModalView()`

## Key Files Reference
- **Entry point**: `lib/main.dart` (initializes GetIt, error handlers, Riverpod)
- **Navigation hub**: `lib/infrastructure/navigation/app_nav.dart` (75+ routes across 3 shells)
- **API client**: `lib/infrastructure/network/dio_service.dart` (comprehensive logging, error handling)
- **Result utilities**: `lib/infrastructure/network/result.dart` and `response_model.dart`
- **Smart contract ABIs**: `assets/contracts/*.json` (USDC, Creditor, Lender, Vault)
- **Blockchain config**: `lib/core/constants/contract_constants.dart`

## External Dependencies
- **Web3**: `reown_appkit: ^1.7.0` (wallet connection, transaction signing)
- **Network**: `dio: ^5.8.0+1` (HTTP), `connectivity_plus: ^6.1.4` (connectivity checks)
- **Storage**: `flutter_secure_storage: ^9.2.4` (encrypted key-value storage)
- **Navigation**: `go_router: ^15.1.2` (declarative routing with shell support)
- **State**: `flutter_riverpod: ^2.5.1` (reactive state management)
- **UI**: `flutter_svg: ^2.1.0`, `cached_network_image: ^3.4.1`, `pinput: ^5.0.1` (OTP input)
- **Utils**: `intl: ^0.20.2` (date/number formatting), `qr_flutter: ^4.1.0` (QR generation)
