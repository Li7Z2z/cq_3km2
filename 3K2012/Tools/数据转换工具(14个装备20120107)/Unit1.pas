unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, StrUtils, Mask, RzEdit, RzBtnEdt,
  RzLabel, RzShellDialogs, Mudutil, ImageHlp, DB, DBTables;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    SpeedButton4: TSpeedButton;
    Mir_db1: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Label15: TLabel;
    Button1: TButton;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    Label2: TLabel;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    Button3: TButton;
    Label4: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure MirAllone;//ת����������
    procedure HeroMirAllone;//ת����������
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses FileCtrl, MirDB, UniTypes;
{$R *.dfm}

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  s: string;
begin
  if SelectDirectory('ѡ��·��...', '', S) then
    Edit1.Text  := S;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  opendialog1.filter:='�����ļ�(*.DB)|*.DB';
  if opendialog1.Execute then begin
   Edit2.Text:=opendialog1.filename;
  end;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  opendialog1.filter:='�����ļ�(*.DB)|*.DB';
  if opendialog1.Execute then begin
   Mir_db1.Text:=opendialog1.filename;
  end;
end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

//����ָ���ļ� 20080912
function FindFile2(AList: TStrings; const APath: TFileName;
  const Ext: String; const Recurisive: Boolean): Integer;
var
  FSearchRec: TSearchRec;
  FPath: TFileName;
begin
  Result := -1;
  application.ProcessMessages;
  if Assigned(AList) then
  try
    FPath := IncludeTrailingPathDelimiter(APath);
    if FindFirst(FPath + '*.*', faAnyFile, FSearchRec) = 0 then
      repeat
        if (FSearchRec.Attr and faDirectory) = faDirectory then begin
          if Recurisive and (FSearchRec.Name <> '.') and (FSearchRec.Name <> '..') then
            FindFile2(AList, FPath + FSearchRec.Name, Ext, Recurisive);
          if SameText(Ext, FSearchRec.Name) then begin
            AList.Add(FPath + FSearchRec.Name);
          end;
        end else
        if SameText(LowerCase(Ext), LowerCase(ExtractFileName(FSearchRec.Name))) then begin
          AList.Add(FPath + FSearchRec.Name);
        end;
      until FindNext(FSearchRec) <> 0;
  finally
    SysUtils.FindClose(FSearchRec);
    Result := AList.Count;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (trim(edit1.text)='') or (trim(Mir_db1.text)='')  then begin
    Application.MessageBox('�����ص��ļ�·��ѡ��ã�','��ʾ��Ϣ',MB_ICONASTERISk+MB_OK);
    Exit;
  end;
  if trim(Mir_db1.text) <> '' then begin
    if not AnsiContainsText(Mir_db1.text,'Mir.db') then begin
      Application.MessageBox('Mir.db�ļ�ѡ�����','��ʾ��Ϣ',MB_ICONASTERISk+MB_OK);
      Exit;
    end;
  end;
  if Application.MessageBox('�Ƿ�ȷ���Ѿ���ԭ���ݱ��ݲ�׼������ת����', '��ʾ', mb_YESNO + mb_IconQuestion) = ID_NO then Exit;
  Edit1.Enabled := False;
  SpeedButton1.Enabled := False;
  Mir_db1.Enabled := False;
  SpeedButton4.Enabled := False;
  Edit2.Enabled := False;
  SpeedButton2.Enabled := False;

  Button1.Enabled := False;
  //����ָ��Ŀ¼
  if not DirectoryExists(Edit1.Text+'\DBServer\FDB') then ForceDirectories(Edit1.Text+'\DBServer\FDB');

  MirAllone;//ת����������
  HeroMirAllone;//ת����������
  Edit1.Enabled := True;
  Edit2.Enabled := True;
  SpeedButton2.Enabled := True;
  SpeedButton1.Enabled := True;
  Mir_db1.Enabled := True;
  SpeedButton4.Enabled := True;
  Button1.Enabled := True;
  Memo1.Lines.add('����ת���Ѿ����!');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage(IntToStr(SizeOf(TUserItem)));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Caption +
  {$if Version = 0}
  '[MMX->D3D]'
  {$else}
  '[D3D 0404->0424]'
  {$ifend}
  ;
end;

//ת����������
procedure TForm1.MirAllone;
var
  OldMirInfo: THumDataInfo;
  NewMirInfo: TNewHumDataInfo;//�µĽṹ
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount, H: Integer;
  DBHeader: TDBHeader1;
  sFileName : string;
begin
  if FileExists(Mir_db1.Text) then
    FDBRecord := TMirRecord.Create(Mir_db1.Text, fmShareDenyNone)
  else begin
    Memo1.Lines.add('Mir���ݿⲻ����!');
    Exit;
  end;
  sFileName := Edit1.Text+'\DBServer\FDB\Mir.DB';
  ForceDirectories(ExtractFilePath(sFileName));//����Ŀ¼ By TasNat at: 2012-04-24 20:15:11

  
  if FileExists(sFileName) then DeleteFile(sFileName); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(sFileName, fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(NewMirInfo);
    FNewDBRecord.HeaderSize := SizeOf(DBHeader);
    try
      FDBRecord.RecSize := SizeOf(OldMirInfo);
      FDBRecord.HeaderSize := SizeOf(DBHeader);
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      DBHeader.sDesc := DBFileDesc;//��ʶ
      DBHeader.n70 := nDBVersion;//DB�汾��
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰ�Mirд���¿�');
      Label6.caption := '';
      Application.ProcessMessages;
      for i := 1 to nRecordCount do begin
        FDBRecord.ReadRec(OldMirInfo);
        FillChar(NewMirInfo, SizeOf(NewMirInfo), #0);//��սṹ
        NewMirInfo.Header:= OldMirInfo.Header;

        NewMirInfo.Data.sChrName:= OldMirInfo.Data.sChrName;//����
        NewMirInfo.Data.sCurMap:= OldMirInfo.Data.sCurMap;//��ͼ
        NewMirInfo.Data.wCurX:= OldMirInfo.Data.wCurX; //����X
        NewMirInfo.Data.wCurY:= OldMirInfo.Data.wCurY; //����Y
        NewMirInfo.Data.btDir:= OldMirInfo.Data.btDir; //����
        NewMirInfo.Data.btHair:= OldMirInfo.Data.btHair;//ͷ��
        NewMirInfo.Data.btSex:= OldMirInfo.Data.btSex; //�Ա�(0-�� 1-Ů)
        NewMirInfo.Data.btJob:= OldMirInfo.Data.btJob;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
        NewMirInfo.Data.nGold:= OldMirInfo.Data.nGold;//�����(����) Ӣ��ŭ��ֵ(Ӣ��)

        //NewMirInfo.Data.Abil:= OldMirInfo.Data.Abil;//+40 ������������
        //By TasNat at: 2012-04-24 19:56:50
        NewMirInfo.Data.Abil.Level:=OldMirInfo.Data.Abil.Level;//�ȼ�
        NewMirInfo.Data.Abil.AC:=OldMirInfo.Data.Abil.AC;//HP ���� 20091026
        NewMirInfo.Data.Abil.MAC:=OldMirInfo.Data.Abil.MAC;//MP ���� 20091026
        NewMirInfo.Data.Abil.DC:=OldMirInfo.Data.Abil.DC;//MaxHP ���� 20091026
        NewMirInfo.Data.Abil.MC:=OldMirInfo.Data.Abil.MC;//MaxMP ���� 20091026
        NewMirInfo.Data.Abil.SC:=OldMirInfo.Data.Abil.SC;//LoByte()-�Զ������������� HiByte()-�Զ���������ǿ��(����)
        NewMirInfo.Data.Abil.HP:=OldMirInfo.Data.Abil.HP;//-AC,HP����
        NewMirInfo.Data.Abil.MP:=OldMirInfo.Data.Abil.MP;//-MAC,Mp����
        NewMirInfo.Data.Abil.MaxHP:=OldMirInfo.Data.Abil.MaxHP;//-DC,MaxHP����
        NewMirInfo.Data.Abil.MaxMP:=OldMirInfo.Data.Abil.MaxMP;//-MC,MaxMP����
        NewMirInfo.Data.Abil.NG:=OldMirInfo.Data.Abil.NG;//��ǰ����ֵ
        NewMirInfo.Data.Abil.MaxNG:=OldMirInfo.Data.Abil.MaxNG;//����ֵ����
        NewMirInfo.Data.Abil.Exp:=OldMirInfo.Data.Abil.Exp;//��ǰ����
        NewMirInfo.Data.Abil.MaxExp:=OldMirInfo.Data.Abil.MaxExp;//��������
        NewMirInfo.Data.Abil.Weight:=OldMirInfo.Data.Abil.Weight;
        NewMirInfo.Data.Abil.MaxWeight:=OldMirInfo.Data.Abil.MaxWeight;//�������
        NewMirInfo.Data.Abil.WearWeight:=OldMirInfo.Data.Abil.WearWeight;
        NewMirInfo.Data.Abil.MaxWearWeight:=OldMirInfo.Data.Abil.MaxWearWeight;//�����
        NewMirInfo.Data.Abil.HandWeight:=OldMirInfo.Data.Abil.HandWeight;
        NewMirInfo.Data.Abil.MaxHandWeight:=OldMirInfo.Data.Abil.MaxHandWeight;//����

        NewMirInfo.Data.wStatusTimeArr:= OldMirInfo.Data.wStatusTimeArr; //+24 ����״̬����ֵ��һ���ǳ���������
        NewMirInfo.Data.sHomeMap:= OldMirInfo.Data.sHomeMap;//Home ��(����),�����Ƿ��һ���ٻ�(Ӣ��)
        NewMirInfo.Data.wHomeX:= OldMirInfo.Data.wHomeX;//Home X
        NewMirInfo.Data.wHomeY:= OldMirInfo.Data.wHomeY;//Home Y
        NewMirInfo.Data.sDearName:= OldMirInfo.Data.sDearName; //����(��ż)
        NewMirInfo.Data.sMasterName:= OldMirInfo.Data.sMasterName;//����-ʦ������ Ӣ��-��������
        NewMirInfo.Data.boMaster:= OldMirInfo.Data.boMaster;//�Ƿ���ͽ��
        NewMirInfo.Data.btCreditPoint:= OldMirInfo.Data.btCreditPoint;//������
        NewMirInfo.Data.btDivorce:= OldMirInfo.Data.btDivorce; //(����)�Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(btDivorce��UnKnow[25]��ϳ�word)
        NewMirInfo.Data.btMarryCount:= OldMirInfo.Data.btMarryCount; //������
        NewMirInfo.Data.sStoragePwd:= OldMirInfo.Data.sStoragePwd;//�ֿ�����
        NewMirInfo.Data.btReLevel:= OldMirInfo.Data.btReLevel;//ת���ȼ�

        NewMirInfo.Data.btUnKnow2[0]:= OldMirInfo.Data.btUnKnow2[0];
        NewMirInfo.Data.btUnKnow2[1]:= OldMirInfo.Data.btUnKnow2[1];
        NewMirInfo.Data.btUnKnow2[2]:= OldMirInfo.Data.btUnKnow2[2];//0-�Ƿ�ͨԪ������(1-��ͨ) 1-�Ƿ�Ĵ�Ӣ��(1-����Ӣ��) 2-����ʱ�Ƶ�Ʒ��

        NewMirInfo.Data.BonusAbil:= OldMirInfo.Data.BonusAbil; //+20 ���������ֵ
        NewMirInfo.Data.nBonusPoint:= OldMirInfo.Data.nBonusPoint;//������
        NewMirInfo.Data.nGameGold:= OldMirInfo.Data.nGameGold;//��Ϸ��(Ԫ��)
        NewMirInfo.Data.nGameDiaMond:= OldMirInfo.Data.nGameDiaMond;//���ʯ
        NewMirInfo.Data.nGameGird:= OldMirInfo.Data.nGameGird;//���
        NewMirInfo.Data.nGamePoint:= OldMirInfo.Data.nGamePoint;//��Ϸ��
        NewMirInfo.Data.btGameGlory:= OldMirInfo.Data.btGameGlory; //����
        NewMirInfo.Data.nPayMentPoint:= OldMirInfo.Data.nPayMentPoint; //��ֵ��
        NewMirInfo.Data.nLoyal:= OldMirInfo.Data.nLoyal;//�ҳ϶�(Ӣ��) �����ۼƾ���(����)
        NewMirInfo.Data.nPKPOINT:= OldMirInfo.Data.nPKPOINT;//PK����
        NewMirInfo.Data.btAllowGroup:= OldMirInfo.Data.btAllowGroup;//�������
        NewMirInfo.Data.btF9:= OldMirInfo.Data.btF9;
        NewMirInfo.Data.btAttatckMode:= OldMirInfo.Data.btAttatckMode;//����ģʽ
        NewMirInfo.Data.btIncHealth:= OldMirInfo.Data.btIncHealth;//���ӽ�����
        NewMirInfo.Data.btIncSpell:= OldMirInfo.Data.btIncSpell;//���ӹ�����
        NewMirInfo.Data.btIncHealing:= OldMirInfo.Data.btIncHealing;//����������
        NewMirInfo.Data.btFightZoneDieCount:= OldMirInfo.Data.btFightZoneDieCount;//���л�ռ����ͼ����������
        NewMirInfo.Data.sAccount:= OldMirInfo.Data.sAccount;//��¼�ʺ�
        NewMirInfo.Data.btEF:= OldMirInfo.Data.btEF;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
        NewMirInfo.Data.boLockLogon:= OldMirInfo.Data.boLockLogon;//�Ƿ�������½
        NewMirInfo.Data.wContribution:= OldMirInfo.Data.wContribution;//����ֵ(����) �Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(Ӣ��)
        NewMirInfo.Data.nHungerStatus:= OldMirInfo.Data.nHungerStatus;//����״̬(����)
        NewMirInfo.Data.boAllowGuildReCall:= OldMirInfo.Data.boAllowGuildReCall;//�Ƿ������л��һ
        NewMirInfo.Data.wGroupRcallTime:= OldMirInfo.Data.wGroupRcallTime; //�Ӵ���ʱ��
        NewMirInfo.Data.dBodyLuck:= OldMirInfo.Data.dBodyLuck; //���˶�  8
        NewMirInfo.Data.boAllowGroupReCall:= OldMirInfo.Data.boAllowGroupReCall; //�Ƿ�������غ�һ
        NewMirInfo.Data.nEXPRATE:= OldMirInfo.Data.nEXPRATE; //���鱶��
        NewMirInfo.Data.nExpTime:= OldMirInfo.Data.nExpTime; //���鱶��ʱ��
        NewMirInfo.Data.btLastOutStatus:= OldMirInfo.Data.btLastOutStatus; //�˳�״̬ 1Ϊ�����˳�
        NewMirInfo.Data.wMasterCount:= OldMirInfo.Data.wMasterCount; //��ʦͽ����
        NewMirInfo.Data.boHasHero:= OldMirInfo.Data.boHasHero; //�Ƿ��а�����Ӣ��(����ʹ��)
        NewMirInfo.Data.boIsHero:= OldMirInfo.Data.boIsHero; //�Ƿ���Ӣ��
        NewMirInfo.Data.btStatus:= OldMirInfo.Data.btStatus; //Ӣ��״̬(Ӣ��) ��ѡ����ְҵ(����)
        NewMirInfo.Data.sHeroChrName:= OldMirInfo.Data.sHeroChrName;//Ӣ������, size=15
        NewMirInfo.Data.sHeroChrName1:= OldMirInfo.Data.sHeroChrName1;//����Ӣ����(size=15) 20110130
        NewMirInfo.Data.UnKnow:= OldMirInfo.Data.UnKnow;//44
        NewMirInfo.Data.QuestFlag:= OldMirInfo.Data.QuestFlag; //�ű�����
        NewMirInfo.Data.HumItems:= OldMirInfo.Data.HumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
        NewMirInfo.Data.BagItems:= OldMirInfo.Data.BagItems; //����װ��

        for H:= 0 to 34 do begin//��ͨħ��
          if OldMirInfo.Data.HumMagics[H].wMagIdx > 0 then begin
            NewMirInfo.Data.HumMagics[H].wMagIdx:=OldMirInfo.Data.HumMagics[H].wMagIdx;
            NewMirInfo.Data.HumMagics[H].btLevel:=OldMirInfo.Data.HumMagics[H].btLevel;
            NewMirInfo.Data.HumMagics[H].btKey:=OldMirInfo.Data.HumMagics[H].btKey;
            NewMirInfo.Data.HumMagics[H].nTranPoint:=OldMirInfo.Data.HumMagics[H].nTranPoint;
            NewMirInfo.Data.HumMagics[H].btLevelEx:= 0;
          end;
        end;

        NewMirInfo.Data.StorageItems:= OldMirInfo.Data.StorageItems;//�ֿ���Ʒ
        NewMirInfo.Data.HumAddItems:= OldMirInfo.Data.HumAddItems;//����4�� ����� ���� Ь�� ��ʯ
        NewMirInfo.Data.n_WinExp:= OldMirInfo.Data.n_WinExp;//�ۼƾ���
        NewMirInfo.Data.n_UsesItemTick:= OldMirInfo.Data.n_UsesItemTick;//������ۼ�ʱ��
        NewMirInfo.Data.nReserved:= OldMirInfo.Data.nReserved; //(����)��Ƶ�ʱ��,�����ж೤ʱ�����ȡ�ؾ� (Ӣ��)������������
        NewMirInfo.Data.nReserved1:= OldMirInfo.Data.nReserved1; //��ǰҩ��ֵ
        NewMirInfo.Data.nReserved2:= OldMirInfo.Data.nReserved2; //ҩ��ֵ����
        NewMirInfo.Data.nReserved3:= OldMirInfo.Data.nReserved3; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ��
        NewMirInfo.Data.n_Reserved:= OldMirInfo.Data.n_Reserved;   //��ǰ����ֵ
        NewMirInfo.Data.n_Reserved1:= OldMirInfo.Data.n_Reserved1;  //��������
        NewMirInfo.Data.n_Reserved2:= OldMirInfo.Data.n_Reserved2;  //��ǰ��ƶ�
        NewMirInfo.Data.n_Reserved3:= OldMirInfo.Data.n_Reserved3;  //ҩ��ֵ�ȼ�
        NewMirInfo.Data.boReserved:= OldMirInfo.Data.boReserved; //�Ƿ������ T-�����(����)
        NewMirInfo.Data.boReserved1:= OldMirInfo.Data.boReserved1;//�Ƿ�������Ӣ��(����)
        NewMirInfo.Data.boReserved2:= OldMirInfo.Data.boReserved2;//�Ƿ���� T-������� (����)
        NewMirInfo.Data.boReserved3:= OldMirInfo.Data.boReserved3;//���Ƿ�Ⱦ�����(����)
        NewMirInfo.Data.m_GiveDate:= OldMirInfo.Data.m_GiveDate;//������ȡ�л��Ȫ����(����)
        NewMirInfo.Data.MaxExp68:= OldMirInfo.Data.MaxExp68;//�Զ������ۼ�ʱ��(����)
        NewMirInfo.Data.nExpSkill69:= OldMirInfo.Data.nExpSkill69;//�ڹ���ǰ����
        NewMirInfo.Data.HumNGMagics:= OldMirInfo.Data.HumNGMagics;//�ڹ�����
        NewMirInfo.Data.HumTitles:= OldMirInfo.Data.HumTitles;//�ƺ�����  20110130
        NewMirInfo.Data.m_nReserved1:= OldMirInfo.Data.m_nReserved1;//��������
        NewMirInfo.Data.m_nReserved2:= OldMirInfo.Data.m_nReserved2;//����Ӣ�۵ȼ�(����)
        NewMirInfo.Data.m_nReserved3:= OldMirInfo.Data.m_nReserved3;//����Ӣ�۵ȼ�(����)
        NewMirInfo.Data.m_nReserved4:= OldMirInfo.Data.m_nReserved4;//�����ؼ�ʹ��ʱ��
        NewMirInfo.Data.m_nReserved5:= OldMirInfo.Data.m_nReserved5;//ʹ����Ʒ(����,����,����)�ı�˵����ɫ��ʹ��ʱ��(����)
        NewMirInfo.Data.m_nReserved6:= OldMirInfo.Data.m_nReserved6;//�����ۼ��ڹ�����(����)
        NewMirInfo.Data.m_nReserved7:= OldMirInfo.Data.m_nReserved7;//����Ӣ���ڹ��ȼ�(����)
        NewMirInfo.Data.m_nReserved8:= OldMirInfo.Data.m_nReserved8;//����Ӣ���ڹ��ȼ�(����)
        NewMirInfo.Data.Proficiency:= OldMirInfo.Data.Proficiency;//������(�������ؾ���)
        NewMirInfo.Data.Reserved2:= OldMirInfo.Data.Reserved2;//��������(����)
        NewMirInfo.Data.Reserved3:= OldMirInfo.Data.Reserved3;//��ǰ��Ԫֵ(����)
        NewMirInfo.Data.Reserved4:= OldMirInfo.Data.Reserved4;//��ǰ��תֵ
        NewMirInfo.Data.Exp68:= OldMirInfo.Data.Exp68;//�����ʼ��Ԫֵ������
        NewMirInfo.Data.sHeartName:= OldMirInfo.Data.sHeartName;//�����Զ����ķ����� 20110808
        NewMirInfo.Data.SpiritMedia:= OldMirInfo.Data.SpiritMedia;//��ýװ��λ
        NewMirInfo.Data.UnKnow1:= OldMirInfo.Data.UnKnow1;//Ԥ��6��Word����

        FNewDBRecord.AppendRec(NewMirInfo);
        Label6.caption := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
    finally
      FDBRecord.Free;
    end;
  finally
    FNewDBRecord.Free;
  end;
end;


//ת����������
procedure TForm1.HeroMirAllone;
var
  FMirInfo: THeroDataInfo;
  NewMirInfo: TNewHeroDataInfo;//�µĽṹ
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount, H: Integer;
  DBHeader: TDBHeader1;
  sFileName : string;
begin
  if FileExists(Edit2.Text) then
    FDBRecord := TMirRecord.Create(Edit2.Text, fmShareDenyNone)
  else begin
    Memo1.Lines.add('Mir���ݿⲻ����!');
    Exit;
  end;
  sFileName := Edit1.Text+'\DBServer\FDB\HeroMir.DB';
  ForceDirectories(ExtractFilePath(sFileName));//����Ŀ¼ By TasNat at: 2012-04-24 20:15:11

  if FileExists(sFileName) then DeleteFile(sFileName); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(sFileName, fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(NewMirInfo);
    FNewDBRecord.HeaderSize := SizeOf(DBHeader);
    try
      FDBRecord.RecSize := SizeOf(FMirInfo);
      FDBRecord.HeaderSize := SizeOf(DBHeader);
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      DBHeader.sDesc := DBFileDesc;//��ʶ
      DBHeader.n70 := nDBVersion;//DB�汾��
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰ�HeroMirд���¿�');
      Label6.Caption := '';
      Application.ProcessMessages;
      for i := 1 to nRecordCount do begin
        FDBRecord.ReadRec(FMirInfo);

        FillChar(NewMirInfo, SizeOf(NewMirInfo), #0);
        NewMirInfo.Header.boDeleted:= FMirInfo.Header.boDeleted;
        NewMirInfo.Header.dCreateDate:= FMirInfo.Header.dCreateDate;

        NewMirInfo.Data.sHeroChrName:= FMirInfo.Data.sHeroChrName;//Ӣ������
        NewMirInfo.Data.btJob:= FMirInfo.Data.btJob;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
        NewMirInfo.Data.nHP:= FMirInfo.Data.nHP;//��ǰHPֵ
        NewMirInfo.Data.nMP:= FMirInfo.Data.nMP;//��ǰMPֵ

        for H:= 0 to 29 do begin//��ͨħ��
          if FMirInfo.Data.HumMagics[H].wMagIdx > 0 then begin
            NewMirInfo.Data.HumMagics[H].wMagIdx:=FMirInfo.Data.HumMagics[H].wMagIdx;
            NewMirInfo.Data.HumMagics[H].btLevel:=FMirInfo.Data.HumMagics[H].btLevel;
            NewMirInfo.Data.HumMagics[H].btKey:=FMirInfo.Data.HumMagics[H].btKey;
            NewMirInfo.Data.HumMagics[H].nTranPoint:=FMirInfo.Data.HumMagics[H].nTranPoint;
            NewMirInfo.Data.HumMagics[H].btLevelEx:= 0;
          end;
        end;

        NewMirInfo.Data.HumNGMagics:= FMirInfo.Data.HumNGMagics;//�ڹ�����

        NewMirInfo.Data.HumItems:= FMirInfo.Data.HumItems;
        NewMirInfo.Data.BagItems:=FMirInfo.Data.BagItems;
        NewMirInfo.Data.HumAddItems:=FMirInfo.Data.HumAddItems;

        FNewDBRecord.AppendRec(NewMirInfo);
        Label6.Caption := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
    finally
      FDBRecord.Free;
    end;
  finally
    FNewDBRecord.Free;
  end;
end;
end.
