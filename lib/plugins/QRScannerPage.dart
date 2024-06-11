// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _flashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '扫一扫',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: PublicData.textSize_16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0, // 移除阴影
        leading: getBackLastInterfaceButton(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              Logger().i("加载本地图片");
              Get.toNamed(RouteJumpConfig.selectLocalImagePage);
            },
            child: Text(
              '相册',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: PublicData.textSize_16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 200,
            ),
          ),
          Positioned(
            bottom: 20,
            child: IconButton(
              icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
              color: Colors.white,
              onPressed: _toggleFlash,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller?.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        Logger().i('Scanned: ${scanData.code}');
        // 处理扫描结果
        _controller?.pauseCamera(); // 暂停摄像头
        // 这里可以跳转到另一个页面或显示扫描结果
      }
    });
  }

  void _toggleFlash() {
    _flashOn = !_flashOn;
    _controller?.toggleFlash();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
