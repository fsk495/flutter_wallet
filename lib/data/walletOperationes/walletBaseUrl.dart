// ignore_for_file: file_names, constant_identifier_names

class ApiUrl {
  //获取BNB链
  static const String getBNBApiUrl = "https://api.bscscan.com/api";

  static const String BNBApiKey = 'F4FS9PTNTUKRDGZI8TEGA2QF6WRIAAKUVE';
  //获取eth 主链交易记录
  // static const String getETHTransRecord ="https://api.yitaifang.com/index/tokenTransaction";

  static const String getETHApiUrl = "https://api.etherscan.io/api";

  static const String ETHApiKey = '22XUYU8CYNRU32VGYCPEB24XBXJS5K5DRI';

  static const Map<String, String> contractAddress = {
    'USDT': '0xdac17f958d2ee523a2206206994597c13d831ec7',
    'STETH': '0xae7ab96520de3a18e5e111b5eaab095312d7fe84',
    'USDC': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
    'SHIB': '0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE',
    'WBTC': '0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599',
    'LINK': '0x514910771AF9Ca656af840dff83E8264EcF986CA',
    'UNI': '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
    'MATIC': '0x7D1AFA7B718fb893dB30A3aBc0Cfc608AaCfebb0',
    'FET': '0xaea46A60368A7bD060eec7DF8CBa43b7EF41Ad85',
    'LEO': '0x2AF5D2aD76741191D15Dfe7bF6aC92d4Bd912Ca3',
    'DAI': '0x6B175474E89094C44Da98b954EedeAC495271d0F',
    'PEPE': '0x6982508145454Ce325dDbE47a25d4ec3d2311933',
    'WEETH': '0xCd5fE23C85820F7B72D0926FC9b05b43E359b7ee',
    'RNDR': '0x6De037ef9aD2725EB40118Bb1702EBb27e4Aeb24',
    'IMX': '0xF57e7e7C23978C3cAEC3C3548E3D615c346e79fF',
    'EZETH': '0xbf5495Efe5DB9ce00f80364C8B423567e58d2110', // 示例地址
    'FDUSD': '0xc5f0f7b66764F6ec8C8Dff7BA683102295E16409',
    'MNT': '0x3c3a81e81dc49a522a592e7622a7e711c06bf354',
    'GRT': '0xc944E90C64B2c07662A292be6244BDf05Cda44a7',
    // 非ERC-20的代币
    // 'ATOM': '0x8D983cb9388EaC77af045D8c8D8f4EB9C7CdC3f3',
    // 'FIL': '0x6e1A19F235bE7ED8E3369eF73b196C07257494DE',
    // 'CRO': '0xA0b86991c6218B36c1D19d4a2E9Eb0Ce3606EB48', // 示例地址
  };
}
