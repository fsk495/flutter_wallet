// ignore_for_file: constant_identifier_names

import 'package:flutter_wallet/home/browse/browseInputUrl.dart';
// import 'package:flutter_wallet/home/browse/browseWeb.dart';
import 'package:flutter_wallet/home/browse/dappBrowser.dart';
import 'package:flutter_wallet/home/homeIndex.dart';
import 'package:flutter_wallet/home/login/create/addCurrencyPage.dart';
import 'package:flutter_wallet/home/login/create/confirmMnemonicPage.dart';
import 'package:flutter_wallet/home/login/create/createIdentityPage.dart';
import 'package:flutter_wallet/home/login/create/mnemonicTipPage.dart';
import 'package:flutter_wallet/home/login/create/remarksMnemonicPage.dart';
import 'package:flutter_wallet/home/login/loginPage.dart';
import 'package:flutter_wallet/home/login/recovery/recoveryIdentityPage.dart';
import 'package:flutter_wallet/home/mine/addAddressBookPage.dart';
import 'package:flutter_wallet/home/mine/addressBookPage.dart';
import 'package:flutter_wallet/home/mine/addressBook_modifyAddressInfo.dart';
import 'package:flutter_wallet/home/mine/manageWalletsPage.dart';
import 'package:flutter_wallet/home/wallet/wallet_payment_qr.dart';
import 'package:flutter_wallet/home/wallet/wallet_transfer.dart';
import 'package:flutter_wallet/plugins/QRScannerPage.dart';
import 'package:flutter_wallet/plugins/selectLocalImagePage.dart';

import 'package:get/get.dart';

/// 定义页面的路由跳转
class RouteJumpConfig {
  /// 主页
  static const home = "/home";

  /// 跳转第三方网站
  // static const browseWeb = "/browseWeb";

  static const browseWebInput = "/browseWebInput";

  /// 转账
  static const walletTransfer = "/walletTransfer";

  /// 创建或者恢复身份
  static const loginOrRegister = "/loginOrRegister";

  /// 创建身份
  static const createIdentity = "/createIdentity";

  /// 添加币种
  static const addCurrency = "/addCurrency";

  /// 助记词提示
  static const mnemonicTip = "/mnemonicTip";

  /// 备份助记词
  static const remarksMnemonic = "/remarksMnemonic";

  /// 确认助记词
  static const confirmMnemonic = "/confirmMnemonic";

  /// 扫描二维码
  static const QR_ScannerPage = "/QRScannerPage";

  /// 二维码收款
  static const walletPaymentQR = "/walletPaymentQR";

  static const market = "/marketIndexPage";

  static const recoveryIdentity = "/recoveryIdentity";

  static const addressBook = '/addressBook';

  static const addAddressBook = '/addAddressBook';

  static const addressBookModifyInfo = '/addressBookModifyInfo';

  static const selectLocalImagePage = '/selectLocalImagePage';

  static const manageWalletsPage = '/manageWalletsPage';

  static const temp  = '/temp';

  static final List<GetPage> getPages = [
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    // GetPage(
    //   name: browseWeb,
    //   page: () => const BrowseWeb(),
    // ),
    GetPage(
      name: walletTransfer,
      page: () => const WalletTransferPage(),
    ),
    GetPage(
      name: loginOrRegister,
      page: () => const LoginOrRegisterPage(),
    ),
    GetPage(
      name: createIdentity,
      page: () => const CreateIdentityPage(),
    ),
    GetPage(
      name: addCurrency,
      page: () => const AddCurrencyPage(),
    ),
    GetPage(
      name: mnemonicTip,
      page: () => const MnemonicTipPage(),
    ),
    GetPage(
      name: remarksMnemonic,
      page: () => const RemarksMnemonicPage(),
    ),
    GetPage(
      name: confirmMnemonic,
      page: () => const ConfirmMnemonicPage(),
    ),
    GetPage(
      name: QR_ScannerPage,
      page: () => const QRScannerPage(),
    ),
    GetPage(
      name: walletPaymentQR,
      page: () => const WalletPaymentQR(),
    ),
    GetPage(
      name: recoveryIdentity,
      page: () => const RecoveryIdentityPage(),
    ),
    GetPage(
      name: addressBook,
      page: () => const AddressBookPage(),
    ),
    GetPage(
      name: addAddressBook,
      page: () => const AddAddressBookPage(),
    ),
    GetPage(
      name: addressBookModifyInfo,
      page: () => const AddressBookModifyInfo(),
    ),
    GetPage(
      name: selectLocalImagePage,
      page: () => const SelectLocalImagePage(),
    ),
    GetPage(
      name: manageWalletsPage,
      page: () => const ManageWalletsPage(),
    ),
    GetPage(
      name: browseWebInput,
      page: () => const BrowseInputUrlPage(),
    ),

    GetPage(name: temp, page: () => Web3WalletPage())
  ];
}
