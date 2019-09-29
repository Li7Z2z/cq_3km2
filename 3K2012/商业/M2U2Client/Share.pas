unit Share;

interface
uses Common, Classes, DBTables, Windows, SysUtils;
type
  TStdItem = packed record
    Name: string[14];//��Ʒ����
    StdMode: Byte; //0/1/2/3��ҩ�� 5/6:������10/11�����ף�15��ͷ����22/23����ָ��24/26������19/20/21������
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte; //0x14
    NeedIdentify: Byte; //0x15 ��Ҫ
    Looks: Word; //0x16 ��ۣ���Items.WIL�е�ͼƬ����
    DuraMax: Word; //0x18  ���־�
    Reserved1: Word;
    AC: Integer; //0x1A
    MAC: Integer; //0x1C
    DC: Integer; //0x1E
    MC: Integer; //0x20
    SC: Integer; //0x22
    Need: Integer; //0x24
    NeedLevel: Integer; //0x25
    Price: Integer; //0x28
  end;
  pTStdItem = ^TStdItem;
const
  Version = 0;//1Ϊ1.76�汾

  GameMonName = 'QKGameMonList.txt';
  FilterFileName = 'GameFilterItemNameList.txt';
  {$IF Version = 1}
  g_sProductName = 'FC3CFB19E1FDDD4B8327EFFEE704954717D6D6987B92E63C569D34FD66A227292F76CB751D17C111'; //3KM2 1.76�������ɿͻ���(Client)
  {$ELSE}
  g_sProductName = 'FC3CFB19E1FDDD4B8327EFFEE704954717D6D6987B92E63C02CBB391478E55132F76CB751D17C111'; //3KM2 �����������ɿͻ���(Client)
  {$IFEND}
  g_sVersion = '03D66443562E29112F344FC7EADF5DF9C5C3C9374D92394E';  //2.00 Build 20110718
  g_sUpDateTime = 'A42FBF7986B704A9CF3ABB7DBC68FB4D'; //2011/07/18
  g_sProgram = 'BF329B13CBE9010C601B4C1E88011620'; //3K�Ƽ�
  g_sWebSite = '92A51ADA62A0738AC5DB86D6E7E9CDE140574B5A981AB1753188062D144466D7'; // http://www.3KM2.com(����վ)
  g_sBbsSite = '6136601E4431B32C60BFBF8207DB95FA40574B5A981AB1753188062D144466D7'; //http://www.3KM2.net(����վ)
  g_sServerAdd = '9BECFDD8143865D343B34FE6E6685A942BF1CB066D8203D3'; //vip.3km2.com
  g_sFtpServerAdd = '9BECFDD8143865D343B34FE6E6685A948DA9ED19FDBAEDB1'; //ftp.3km2.com
  g_sFtpUser = 'AA6591AB9081007292D5A33CDA5DC193';//56m2vip
  g_sFtpPass = '8F618E113AFF24F7AEB6A37AADB53431ECB7CB18A523A87F'; //werks%*&@&@#

  _sProductAddress ='224B21DC4825956E209CC996D0C2121800B4F4692E0C07EF7CF957402C49244906B327DBB14599B7';//http://notice.3km2.com/version.xml ������ָ����ı�
  _sProductAddressBak ='224B21DC4825956E209CC996D0C21218C315B9FB5F3048F57CF957402C49244906B327DBB14599B7';//������վ http://notice.66h6.com/version.xml ������ָ����ı�
  _sProductAddress1 ='{{{"5>a>"oca"ob';//www.92m2.com.cn //�İ�Ȩָ��(�ı��������),����վ�ı���һ������
  {$IF Version = 1}
  g_sVersionNum = 'D8A4BF98D27175C3A2EF55A91686646F';//20110718 //1.76���������İ汾��
  {$ELSE}
  g_sVersionNum = 'D8A4BF98D27175C3A2EF55A91686646F';//20110718 //���������İ汾��
  {$IFEND}

  (*�ı�����
{{{"5>a>"oca"ob
��վ��վ�Ѿ��޸ĳ�XXXXXX|��½����ȥ���û��������վ����������ҵ������
*)
var
  g_MySelf: TM2UserInfo;
  g_boConnect: Boolean = False;
  g_boLogined: Boolean = False;
  g_sRecvMsg: string;
  g_sRecvGameMsg: string;
  g_boBusy: Boolean;
  g_sAccount: string;
  g_sPassword: string;
  g_boFirstOpen: Boolean = False;
  StdItemList: TList; //List_54
  Query: TQuery;
  MakeType: Byte = 0;
function LoadItemsDB: Integer;
function getXmlNodeValue(strEntityEngineFile: string; xmlNodePath: string;
  const xmlattrname: string = ''; const dep: Char = '.'): string;
implementation
uses XMLIntf, XMLDoc;
function LoadItemsDB: Integer;
var
  I, Idx: Integer;
  StdItem: pTStdItem;
resourcestring
  sSQLString = 'select * from StdItems';
begin
    try
      for I := 0 to StdItemList.Count - 1 do begin
        Dispose(pTStdItem(StdItemList.Items[I]));
      end;
      StdItemList.Clear;
      Result := -1;
      Query.SQL.Clear;
      Query.SQL.Add(sSQLString);
        try
          Query.Open;
        finally
          Result := -2;
        end;
      for I := 0 to Query.RecordCount - 1 do begin
        New(StdItem);
        Idx := Query.FieldByName('Idx').AsInteger;
        StdItem.Name := Query.FieldByName('Name').AsString;
        StdItem.StdMode := Query.FieldByName('StdMode').AsInteger;
        StdItem.Shape := Query.FieldByName('Shape').AsInteger;
        StdItem.Weight := Query.FieldByName('Weight').AsInteger;
        StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
        StdItem.Source := Query.FieldByName('Source').AsInteger;
        StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;
        StdItem.Looks := Query.FieldByName('Looks').AsInteger;
        StdItem.DuraMax := Word(Query.FieldByName('DuraMax').AsInteger);
        StdItem.AC := MakeLong(Round(Query.FieldByName('Ac').AsInteger * (10 / 10)), Round(Query.FieldByName('Ac2').AsInteger * (10 / 10)));
        StdItem.MAC := MakeLong(Round(Query.FieldByName('Mac').AsInteger * (10 / 10)), Round(Query.FieldByName('MAc2').AsInteger * (10 / 10)));
        StdItem.DC := MakeLong(Round(Query.FieldByName('Dc').AsInteger * (10 / 10)), Round(Query.FieldByName('Dc2').AsInteger * (10 / 10)));
        StdItem.MC := MakeLong(Round(Query.FieldByName('Mc').AsInteger * (10 / 10)), Round(Query.FieldByName('Mc2').AsInteger * (10 / 10)));
        StdItem.SC := MakeLong(Round(Query.FieldByName('Sc').AsInteger * (10 / 10)), Round(Query.FieldByName('Sc2').AsInteger * (10 / 10)));
        StdItem.Need := Query.FieldByName('Need').AsInteger;
        StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
        StdItem.Price := Query.FieldByName('Price').AsInteger;
        //StdItem.NeedIdentify := GetGameLogItemNameList(StdItem.Name);
        if StdItemList.Count = Idx then begin
          StdItemList.Add(StdItem);
          Result := 1;
        end else begin
          //Memo.Lines.Add(Format('������Ʒ(Idx:%d Name:%s)����ʧ�ܣ�����', [Idx, StdItem.Name]));
          Result := -100;
          Exit;
        end;
        Query.Next;
      end;
    finally
      Query.Close;
    end;
end;

{-------------------------------------------------------------------------------
  xml����
}
function getnodefromIXMLNodeList(childnodes: IXMLNodeList; nodename: string): IXMLNode;
var
  i: Integer;
begin
  for i := 1 to childnodes.Count do begin
    if (childnodes.Get(i - 1).NodeName = nodename) then begin
      result := childnodes[i - 1];
      exit;
    end;
  end;
end;

{----------------------------------------------------------------------------------------------------------------------------
  �������ܣ�ֱ�Ӷ�ȡxml�ļ��е�ĳ���ڵ��һ�γ��ֵ�ֵ
  ��ڲ�����xmlFile xml�ļ�
            xmlnodepath �ڵ�
            xmlattrname �ڵ��е��������ƣ����ֱ��ȡ�ڵ�ֵ����Ժ��Դ˲�����
            dep  �ڵ�Ĳ����ķָ�����Ĭ��Ϊ.
  �� �� ֵ��ĩ�����ֵ
}

function getXmlNodeValue(strEntityEngineFile: string; xmlNodePath: string;
  const xmlattrname: string = ''; const dep: Char = '.'): string;
var
  xmlDocument: IXMLDocument;
  node: IXMLNode;
  xmlnodeList: TStrings;
  i: Integer;
  urlcount: Integer;
begin
    //xml�ڵ�·��
  xmlnodeList := TStringList.Create;
  xmlnodeList.Delimiter := dep;
  xmlnodeList.DelimitedText := xmlnodepath;
  urlcount := xmlnodeList.Count;
    //xml����
  xmlDocument := TXMLDocument.Create(nil);
  //xmlDocument.LoadFromFile(strEntityEngineFile);
  xmlDocument.XML.Text := strEntityEngineFile;
  xmlDocument.Active := true;
  try
    node := xmlDocument.DocumentElement;
    if (node.NodeName = xmlnodeList[0]) then begin
            //ɨ��ڵ�
      for i := 1 to urlcount - 1 do begin
        if (node <> nil) then
          node := getnodefromIXMLNodeList(node.ChildNodes, xmlnodeList[i])
        else Break;
      end;
      if (node = nil) then begin
        result := '';
      end else begin
                //�ж���ȡ���Ի���ȡ�ڵ�����
        if (Trim(xmlattrname) = '') then
          result := node.Text
        else
          result := node.AttributeNodes.Nodes[xmlattrname].NodeValue;
      end;
    end else begin
      result := '';
    end;

  except
    result := 'error';
  end;
  xmlDocument.Active := false;
end;


initialization
begin
  StdItemList := TList.Create;
  Query := TQuery.Create(nil);
end;
finalization
begin
  //StdItemList.Free;  ��֪��Ϊʲô һ�ͷžͳ���
  Query.Free;
end;
end.
