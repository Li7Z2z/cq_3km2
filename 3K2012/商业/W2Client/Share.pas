unit Share;

interface
uses Common;

const
  g_sProductName = 'CC290B30788530C7B2B18A36C513B6DF2454D6AE3BC5DF4A866FEB7F45D7CBDE'; //3K�Ƽ�����ͻ���(Client)
  g_sVersion = '03D66443562E29112F344FC7EADF5DF9C5C3C9374D92394E';  //2.00 Build 20110718
  g_sUpDateTime = 'A42FBF7986B704A9CF3ABB7DBC68FB4D'; //2011/07/18
  g_sProgram = 'BF329B13CBE9010C601B4C1E88011620'; //3K�Ƽ�

  g_sWebSite = '92A51ADA62A0738AC5DB86D6E7E9CDE140574B5A981AB1753188062D144466D7'; // http://www.3KM2.com(����վ)
  g_sBbsSite = '6136601E4431B32C60BFBF8207DB95FA40574B5A981AB1753188062D144466D7'; //http://www.3KM2.net(����վ)
  g_sServerAdd = '9BECFDD8143865D343B34FE6E6685A942BF1CB066D8203D3'; //vip.3km2.com

//  _sProductAddress ='B1A6AE5FFAB8A3F85097BCBFAA67893D17672C9BED267D3E40574B5A981AB17576B4B91637D6C0B2';//http://www.66h6.net/ver2.txt ������ָ����ı�
//  _sProductAddress1 ='{{{"5>a>"oca"ob';//www.92m2.com.cn //�İ�Ȩָ��(�ı��������),����վ�ı���һ������
  g_sVersionNum = 'D8A4BF98D27175C3A2EF55A91686646F';//20110718 //���������İ汾��
  (*�ı�����
{{{"5>a>"oca"ob
��վ��վ�Ѿ��޸ĳ�XXXXXX|��½����ȥ���û��������վ����������ҵ������
*)
var
  g_MySelf: TDLUserInfo;
  g_boConnect: Boolean = False;
  g_boLogined: Boolean = False;
  g_sRecvMsg: string;
  g_sRecvGameMsg: string;
  g_boBusy: Boolean;
  g_sAccount: string;
  g_sPassword: string;
implementation

end.
