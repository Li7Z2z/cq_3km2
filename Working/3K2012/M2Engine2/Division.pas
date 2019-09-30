unit Division;
{ʦ�ŵ�Ԫ}
interface
uses
  Windows, SysUtils, Classes, IniFiles, ObjBase;

type
  TDivisionRank = record
    nRankNo: Integer;//����
    sRankName: string;//ְ��(���š�ʦ�ŵ���)
    MemberList: TStringList;//��Ա�б�
  end;
  pTDivisionRank = ^TDivisionRank;

  TDivision = class//ʦ����
    nDivisonType: Byte;//ʦ������(0-��ͨʦ�� 1-����ʦ��)
    sDivisionName: string;//ʦ������
    NoticeList: TStringList;//ʦ�Ź���
    ApplyList: TStringList;//�����б�
    m_RankList: TList; //ְλ�б�
    dwSaveTick: LongWord;//���ݱ�����
    boChanged: Boolean;//�Ƿ�ı�
    m_nDivisionMemberCount: Word;//��Ա����
    sHeartName: String;//�ķ�����
    nHeartTpye: Byte;//�ķ����� 0-�Ͻ� 1-��ľ 2-��� 3-��ˮ 4-����
  private
    m_Config: TIniFile;
    nDivisionPopularity: Integer;//����ֵ
    nPassHeartLevel: Byte;//�����ķ��ȼ�
    procedure ClearRank();
    function SetDivisionInfo(PlayObject: TPlayObject; nType: byte): Boolean;//����ʦ����Ϣ
    function GetMemberCount(): Integer;//ȡʦ������
    function GetMemgerIsFull(): Boolean;//ʦ���Ƿ���Ա
    procedure SetChiefPopularity(nPoint: Integer);//��������ֵ
    procedure SetChiefPassHeartLevel(nPoint: Byte);//�����ķ��ȼ�
    procedure SaveDivisionFile(sFileName: string);//����ʦ��txt�ļ�
  public
    constructor Create(sName: string; nType: Byte);
    destructor Destroy; override;
    function IsMember(sName: string): Boolean;//�Ƿ���ʦ�ų�Ա
    function LoadDivision(): Boolean;//��ȡʦ������
    function LoadDivisionConfig(sDivisionFileName: string): Boolean;
    function LoadDivisionFile(sDivisionFileName: string): Boolean;//��ȡ�л��ļ�
    procedure RefMemberName(ssName: String);//ˢ�³�Ա�б�����
    procedure SaveDivisionInfoFile;//����ʦ���������
    procedure SaveDivisionConfig(sFileName: string);//����ʦ��Ini�ļ�
    procedure SendDivisionMsg(sMsg: string);//ʦ������
    function GetChiefName: string;//ȡʦ���ϴ�����
    procedure CheckSaveDivisionFile();//��ʱ����ʦ������
    procedure UpdateDivisionFile();//����ʦ������
    procedure BackupDivisionFile;
    function IsApplyUser(sCharName: String): Boolean;//�Ƿ�Ϊ����������Ľ�ɫ
    function ApplyMember(PlayObject: TPlayObject): Byte;//������ʦ��
    function DelApplyMember(sCharName: String): Boolean;//ȡ����������
    function AddMember(PlayObject: TPlayObject;sUserName: String): Boolean;//ʦ�����ӳ�Ա
    function DelMember(sHumName: string): Boolean;//ʦ��ɾ����Ա(��Ա�ķ���ʧ)
    function GetMemberContribution(sHumName: string): LongWord;//ȡ�����������ֵ
    function CancelDivision(sHumName: string): Boolean;//ȡ������
    procedure ActivMemberHeart(sUserName: String);//�����ķ�����
    procedure CloseMemberHeart(sUserName: String);//�رյ����ķ�
    property Count: Integer read GetMemberCount;
    property IsFull: Boolean read GetMemgerIsFull;
    property nPopularity: Integer read nDivisionPopularity write SetChiefPopularity;
    property nHeartLevel: Byte read nPassHeartLevel write SetChiefPassHeartLevel;
  end;
  TDivisionManager = class//ʦ�Ź�����
    DivisionList: TList;//�л��б�
  private
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadDivisionInfo();
    procedure SaveDivisionList();
    function LoadUserApplyInfo(sUserName: String):String;//��ȡ��������������ŵ�ʦ����
    procedure SaveUserApplyList(sUserName, sDivisionName: String);//�����������ŵ�����
    function MemberOfDivision(sName: string): TDivision;//��������������
    function AddDivision(sDivisionName: string;PlayObject: TPlayObject): Boolean;
    function FindDivision(sDivisionName: string): TDivision;//��������������
    function FindDivisionEx(sChiefName: string): TDivision;//������ʦ���Ҳ�����
    function UpDivisionInfo(sDivisionName: String; HeartTpye, PassHeartLevel: Byte; Popularity: Integer): Boolean;//���������������
    function DelDivision(sDivisionName: string): Boolean;
    procedure ClearDivisionInf();
    procedure Run();
  end;
implementation

uses M2Share, HUtil32, StrUtils, Grobal2;

constructor TDivision.Create(sName: string; nType: Byte);
var
  sFileName: string;
begin
  try
    nDivisonType:= nType;
    sDivisionName := sName;
    NoticeList := TStringList.Create;
    ApplyList := TStringList.Create;//�����б�
    m_RankList := TList.Create;
    dwSaveTick := 0;
    boChanged := False;
    nDivisionPopularity:= 0;//����ֵ
    {$IF M2Version <> 2}
    if nDivisonType = 0 then begin
      m_nDivisionMemberCount:= g_Config.nDivisionMemberCount;//��Ա����
      sHeartName:= '';//�ķ�����
      nHeartTpye:= 0;//�ķ�����
      nPassHeartLevel:= 1;//�����ķ��ȼ�
    end else Begin
      m_nDivisionMemberCount:= 65535;//����ʦ�ų�Ա����
      sHeartName:= '�����ķ�';//�ķ�����
      nHeartTpye:= 0;//�ķ�����
      nPassHeartLevel:= g_Config.nPublicHeartLevel;//�����ķ��ȼ�
    end;
    {$IFEND}
    sFileName := g_Config.sDivisionDir + sName + '.ini';
    if not DirectoryExists(g_Config.sDivisionDir) then ForceDirectories(g_Config.sDivisionDir); //Ŀ¼������,�򴴽�
    m_Config := TIniFile.Create(sFileName);
    if not FileExists(sFileName) then begin
      m_Config.WriteString('Division', 'DivisionName', sName);
    end;
  except
    MainOutMessage(format('{%s} TDivision.Create',[g_sExceptionVer]));
  end;
end;

destructor TDivision.Destroy;
var
  I:Integer;
begin
  NoticeList.Free;
  for I := 0 to ApplyList.Count - 1 do begin
    if pTApplyDivision(ApplyList.Objects[I]) <> nil then Dispose(pTApplyDivision(ApplyList.Objects[I]));
  end;
  ApplyList.Free;//�����б�
  ClearRank();
  m_RankList.Free;
  m_Config.Free;
  inherited;
end;

//����л�
procedure TDivision.ClearRank;
var
  I, K: Integer;
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
begin
  try
    if m_RankList.Count > 0 then begin
      for I := 0 to m_RankList.Count - 1 do begin
        DivisionRank := m_RankList.Items[I];
        for K := 0 to DivisionRank.MemberList.Count - 1 do begin
          DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[K]);
          if DivisionMember <> nil then Dispose(DivisionMember);
        end;
        DivisionRank.MemberList.Free;
        Dispose(DivisionRank);
      end; // for
    end;
    m_RankList.Clear;
  except
    MainOutMessage(format('{%s} TDivision.ClearRank',[g_sExceptionVer]));
  end;
end;

//�Ƿ���ʦ�ų�Ա
function TDivision.IsMember(sName: string): Boolean;
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
begin
  try
    Result := False;
    for I := 0 to m_RankList.Count - 1 do begin
      DivisionRank := m_RankList.Items[I];
      II:= DivisionRank.MemberList.IndexOf(sName);
      if II > -1 then begin
        Result := True;
        Exit;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivision.IsMember',[g_sExceptionVer]));
  end;
end;
//��ȡʦ������
function TDivision.LoadDivision(): Boolean;
var
  sFileName: string;
begin
  try
    sFileName := sDivisionName + '.txt';
    Result := LoadDivisionFile(sFileName);
    LoadDivisionConfig(sDivisionName + '.ini');
  except
    MainOutMessage(format('{%s} TDivision.LoadDivision',[g_sExceptionVer]));
  end;
end;

function TDivision.LoadDivisionConfig(sDivisionFileName: string): Boolean;
begin
  try
    m_nDivisionMemberCount:= m_Config.ReadInteger('Division', 'DivisionMemberCount', m_nDivisionMemberCount);//��Ա����
    sHeartName:= m_Config.ReadString('Division', 'HeartName', sHeartName);//�ķ�����
    nHeartTpye:= m_Config.ReadInteger('Division', 'HeartTpye', nHeartTpye);//�ķ�����
    nDivisionPopularity:= m_Config.ReadInteger('Division', 'Popularity', nDivisionPopularity);//����ֵ
    nPassHeartLevel:= m_Config.ReadInteger('Division', 'PassHeartLevel', nPassHeartLevel);//�����ķ��ȼ�
    Result := True;
  except
    MainOutMessage(format('{%s} TDivision.LoadDivisionConfig',[g_sExceptionVer]));
  end;
end;

//��ȡʦ���ļ�
function TDivision.LoadDivisionFile(sDivisionFileName: string): Boolean;
var
  I, n28, n2C: Integer;
  LoadList: TStringList;
  s18, s1C, s24, sFileName: string;
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
  ApplyDivision: pTApplyDivision;
  sGender, sJob, sLevel, sContribution, sLogonTime: string;
begin
  Result := False;
  try
    {$IF M2Version <> 2}
    DivisionRank := nil;
    sFileName := g_Config.sDivisionDir + sDivisionFileName;
    if not FileExists(sFileName) then Exit;
    ClearRank();
    NoticeList.Clear;
    ApplyList.Clear;
    n28 := 0;
    n2C := 0;
    s24 := '';
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        s18 := LoadList.Strings[I];
        if (s18 = '') or (s18[1] = ';') then Continue;
        if s18[1] <> '+' then begin
          if s18 = g_Config.sDivisionNotice then n28 := 1;//ʦ�Ź���
          if s18 = g_Config.sDivisionMember then n28 := 2;//ʦ�ų�Ա��Ϣ
          if s18 = g_Config.sApplyDivision then n28 := 3;//��������
          if s18[1] = '#' then begin
            s18 := Copy(s18, 2, Length(s18) - 1);
            s18 := GetValidStr3(s18, s1C, [' ', ',']);
            n2C := Str_ToInt(s1C, 0);//����
            s24 := Trim(s18);//ְ��
            DivisionRank := nil;
          end;
          Continue;
        end;
        s18 := Copy(s18, 2, Length(s18) - 1);
        case n28 of
          1: NoticeList.Add(s18);//ʦ�Ź���
          2: begin
              if (n2C > 0) and (s24 <> '') then begin
                if Length(s24) > 30 then s24 := Copy(s24, 1, 30);//����ְ��ĳ���
                if Pos('|',s24) > 0 then s24 := AnsiReplaceText(s24, '|', '');//����ְ���|����
                if DivisionRank = nil then begin
                  New(DivisionRank);
                  DivisionRank.nRankNo := n2C;
                  DivisionRank.sRankName := s24;
                  DivisionRank.MemberList := TStringList.Create;
                  m_RankList.Add(DivisionRank);
                end;
                if (s18 <> '') then begin
                  s18 := GetValidStr3(s18, s1C, ['|']);//����
                  s18 := GetValidStr3(s18, sGender, ['|']);
                  s18 := GetValidStr3(s18, sJob, ['|']);
                  s18 := GetValidStr3(s18, sLevel, ['|']);
                  s18 := GetValidStr3(s18, sContribution, ['|']);
                  s18 := GetValidStr3(s18, sLogonTime, ['|']);
                  if s1C <> '' then begin
                    New(DivisionMember);
                    DivisionMember.btGender:= Str_ToInt(sGender, 0);
                    DivisionMember.btJob:= Str_ToInt(sJob, 0);
                    DivisionMember.nLevel:= Str_ToInt(sLevel, 0);
                    DivisionMember.nContribution:= Str_ToInt(sContribution, 0);
                    DivisionMember.dLogonTime:= Str_ToDate(sLogonTime);
                    DivisionMember.boStatus:= False;
                    DivisionRank.MemberList.AddObject(s1C, TObject(DivisionMember));
                  end;
                end;
              end;
            end;
            3: begin//�����Ա
              if (s18 <> '') then begin
                s18 := GetValidStr3(s18, s1C, ['|']);//����
                s18 := GetValidStr3(s18, sGender, ['|']);
                s18 := GetValidStr3(s18, sJob, ['|']);
                s18 := GetValidStr3(s18, sLevel, ['|']);
                if s1C <> '' then begin
                  New(ApplyDivision);
                  ApplyDivision.sChrName:= s1C;
                  ApplyDivision.btGender:= Str_ToInt(sGender, 0);
                  ApplyDivision.btJob:= Str_ToInt(sJob, 0);
                  ApplyDivision.nLevel:= Str_ToInt(sLevel, 0);
                  ApplyList.AddObject(s1C, TObject(ApplyDivision));
                end;
              end;
            end;//3
        end; // case
      end;
    finally
      LoadList.Free;
    end;
    Result := True;
    {$IFEND}
  except
    MainOutMessage(format('{%s} TDivision.LoadDivisionFile',[g_sExceptionVer]));
  end;
end;
//�����ķ�����
procedure TDivision.ActivMemberHeart(sUserName: String);
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  nCode: Byte;
  PlayObject: TPlayObject;
  sName: String;
begin
  {$IF M2Version <> 2}
  try
    if m_RankList.Count > 0 then begin
      nCode:=1;
      for I := 0 to m_RankList.Count - 1 do begin
        nCode:= 2;
        DivisionRank := m_RankList.Items[I];
        nCode:=3;
        if DivisionRank <> nil then begin
          nCode:=4;
          if DivisionRank.MemberList.Count > 0 then begin
            nCode:=5;
            for II := DivisionRank.MemberList.Count - 1 downto 0 do begin
              sName:= DivisionRank.MemberList.Strings[II];
              if CompareText(sUserName, sName) <> 0 then begin
                PlayObject := UserEngine.GetPlayObjectEx1(sName);
                nCode:=6;
                if PlayObject <> nil then begin
                  if (PlayObject.m_MagicSkill_106 <> nil) and (PlayObject.m_MagicSkill_105 = nil)
                    and (PlayObject.m_wStatusArrValue[21] = 0) then begin
                    PlayObject.DiscipleHeartUpAbility();//�����ķ�����
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TDivision.ActivMemberHeart Code:%d', [g_sExceptionVer, nCode]));
  end;
  {$IFEND}
end;

//�رյ����ķ�
procedure TDivision.CloseMemberHeart(sUserName: String);
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  nCode: Byte;
  PlayObject: TPlayObject;
  sName: String;
begin
  {$IF M2Version <> 2}
  try
    if m_RankList.Count > 0 then begin
      nCode:=1;
      for I := 0 to m_RankList.Count - 1 do begin
        nCode:= 2;
        DivisionRank := m_RankList.Items[I];
        nCode:=3;
        if DivisionRank <> nil then begin
          nCode:=4;
          if DivisionRank.MemberList.Count > 0 then begin
            nCode:=5;
            for II :=DivisionRank.MemberList.Count - 1 downto 0 do begin
              sName:= DivisionRank.MemberList.Strings[II];
              if CompareText(sUserName, sName) <> 0 then begin
                PlayObject := UserEngine.GetPlayObjectEx1(sName);
                nCode:=6;
                if PlayObject <> nil then begin
                  if (PlayObject.m_MagicSkill_106 <> nil) and (PlayObject.m_MagicSkill_105 = nil)
                    and (PlayObject.m_wStatusArrValue[21] > 0) then begin
                    PlayObject.m_dwStatusArrTimeOutTick[21]:= 0;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TDivision.CloseMemberHeart Code:%d', [g_sExceptionVer, nCode]));
  end;
  {$IFEND}
end;

//ˢ�³�Ա�б�����
procedure TDivision.RefMemberName(ssName: String);
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
  nCode: Byte;
  sName: String;
  PlayObject: TPlayObject;
begin
  nCode:=0;
  {$IF M2Version <> 2}
  try
    if m_RankList.Count > 0 then begin
      nCode:=1;
      for I := 0 to m_RankList.Count - 1 do begin
        nCode:= 2;
        DivisionRank := m_RankList.Items[I];
        nCode:=3;
        if DivisionRank <> nil then begin
          nCode:=4;
          if DivisionRank.MemberList.Count > 0 then begin
            nCode:=5;
            if sName = '' then begin//ȫ������
              for II := 0 to DivisionRank.MemberList.Count - 1 do begin
                sName:= DivisionRank.MemberList.Strings[II];
                PlayObject := UserEngine.GetPlayObjectEx1(sName);
                nCode:=6;
                if PlayObject <> nil then begin
                  if not PlayObject.m_boGhost then begin
                    DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
                    nCode:=7;
                    DivisionMember.btGender:= PlayObject.m_btGender;
                    DivisionMember.btJob:= PlayObject.m_btJob;
                    DivisionMember.nLevel:= PlayObject.m_Abil.Level;
                    DivisionMember.nContribution:= PlayObject.m_Contribution;//����ֵ
                    DivisionMember.dLogonTime:= Date();
                    DivisionMember.boStatus:= True;
                  end else begin
                    DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
                    DivisionMember.boStatus:= False;
                  end;
                end else begin
                  DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
                  DivisionMember.boStatus:= False;
                end;
              end;
              UpdateDivisionFile();
            end else begin
              II:= DivisionRank.MemberList.IndexOf(ssName);
              if II > -1 then begin
                UpdateDivisionFile();
                PlayObject := UserEngine.GetPlayObjectEx1(ssName);
                if PlayObject <> nil then begin
                  if not PlayObject.m_boGhost then begin
                    DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
                    nCode:=7;
                    DivisionMember.btGender:= PlayObject.m_btGender;
                    DivisionMember.btJob:= PlayObject.m_btJob;
                    DivisionMember.nLevel:= PlayObject.m_Abil.Level;
                    DivisionMember.nContribution:= PlayObject.m_Contribution;//����ֵ
                    DivisionMember.dLogonTime:= Date();
                    DivisionMember.boStatus:= True;
                  end else begin
                    DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
                    DivisionMember.boStatus:= False;
                  end;
                end else begin
                  DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
                  DivisionMember.boStatus:= False;
                end;
                Break;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TDivision.RefMemberName Code:%d', [g_sExceptionVer, nCode]));
  end;
  {$IFEND}
end;

procedure TDivision.SaveDivisionInfoFile;
begin
  try
    SaveDivisionFile(g_Config.sDivisionDir + sDivisionName + '.txt');
    SaveDivisionConfig(g_Config.sDivisionDir + sDivisionName + '.ini');
  except
    MainOutMessage(format('{%s} TDivision.SaveDivisionInfoFile',[g_sExceptionVer]));
  end;
end;

procedure TDivision.SaveDivisionConfig(sFileName: string);
begin
  try
    m_Config.WriteString('Division', 'DivisionName', sDivisionName);
    m_Config.WriteInteger('Division', 'DivisionMemberCount', m_nDivisionMemberCount);//��Ա����
    m_Config.WriteString('Division', 'HeartName', sHeartName);//�ķ�����
    m_Config.WriteInteger('Division', 'HeartTpye', nHeartTpye);//�ķ�����
    m_Config.WriteInteger('Division', 'Popularity', nDivisionPopularity);//����ֵ
    m_Config.WriteInteger('Division', 'PassHeartLevel', nPassHeartLevel);//�����ķ��ȼ�
  except
    MainOutMessage(format('{%s} TDivision.SaveDivisionConfig',[g_sExceptionVer]));
  end;
end;

procedure TDivision.SaveDivisionFile(sFileName: string);
var
  SaveList: TStringList;
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
  ApplyDivision: pTApplyDivision;
begin
  try
    {$IF M2Version <> 2}
    SaveList := TStringList.Create;
    try
      SaveList.Add(g_Config.sDivisionNotice);//ʦ�Ź���
      for I := 0 to NoticeList.Count - 1 do begin
        SaveList.Add('+' + NoticeList.Strings[I]);
      end;
      SaveList.Add(' ');
      SaveList.Add(g_Config.sDivisionMember);

      for I := 0 to m_RankList.Count - 1 do begin
        DivisionRank := m_RankList.Items[I];
        SaveList.Add('#' + IntToStr(DivisionRank.nRankNo) + ' ' + DivisionRank.sRankName);
        for II := 0 to DivisionRank.MemberList.Count - 1 do begin
          DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
          if DivisionMember <> nil then
            SaveList.Add(Format('+%s|%d|%d|%d|%d|%s|',[DivisionRank.MemberList.Strings[II],
                         DivisionMember.btGender, DivisionMember.btJob, DivisionMember.nLevel,
                         DivisionMember.nContribution, {DateToStr(DivisionMember.dLogonTime)}
                         FormatDatetime('yyyy-mm-dd',DivisionMember.dLogonTime)]));
        end;
      end;

      SaveList.Add(' ');
      SaveList.Add(g_Config.sApplyDivision);
      for I := 0 to ApplyList.Count - 1 do begin
        ApplyDivision:= pTApplyDivision(ApplyList.Objects[I]);
        if ApplyDivision <> nil then
          SaveList.Add(Format('+%s|%d|%d|%d|',[ApplyDivision.sChrName,
                       ApplyDivision.btGender, ApplyDivision.btJob, ApplyDivision.nLevel]));
      end;
      try
        SaveList.SaveToFile(sFileName);
      except
        MainOutMessage('����ʦ����Ϣʧ�ܣ����� ' + sFileName);
      end;
    finally
      SaveList.Free;
    end;
    {$IFEND}
  except
    MainOutMessage(format('{%s} TDivision.SaveDivisionFile',[g_sExceptionVer]));
  end;
end;

//ʦ������
procedure TDivision.SendDivisionMsg(sMsg: string);
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  PlayObject: TPlayObject;
  nCheckCode: Integer;
  sName: String;
begin
  {$IF M2Version <> 2}
  nCheckCode := 0;
  try
    if g_Config.boShowPreFixMsg then sMsg := g_Config.sDivisionMsgPreFix + sMsg;
    nCheckCode := 1;
    if m_RankList.Count > 0 then begin
      for I := 0 to m_RankList.Count - 1 do begin
        DivisionRank := m_RankList.Items[I];
        nCheckCode := 2;
        if DivisionRank.MemberList = nil then Continue;
        if DivisionRank.MemberList.Count > 0 then begin
          for II := 0 to DivisionRank.MemberList.Count - 1 do begin
            nCheckCode := 3;
            sName:= DivisionRank.MemberList.Strings[II];
            PlayObject := UserEngine.GetPlayObjectEx1(sName);
            if (PlayObject = nil) or (PlayObject.m_boNotOnlineAddExp) or (PlayObject.m_boAI) then Continue;
            nCheckCode := 4;
            PlayObject.SendMsg(PlayObject, RM_DIVISIONMESSAGE, 0, g_Config.btDivisionMsgFColor, g_Config.btDivisionMsgBColor, 0, sMsg);
          end;//for
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TDivision.SendDivisionMsg CheckCode:%d DivisionName:%s Msg:%s', [g_sExceptionVer, nCheckCode, sDivisionName, sMsg]));
    end;
  end;
  {$IFEND}
end;

//����ʦ����Ϣ
function TDivision.SetDivisionInfo(PlayObject: TPlayObject; nType: byte): Boolean;
var
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
begin
  try
    if m_RankList.Count = 0 then begin
      New(DivisionRank);
      DivisionRank.nRankNo := 1;//�ϴ�
      {$IF M2Version <> 2}
      DivisionRank.sRankName := g_Config.sDivisionChief;//����
      {$IFEND}
      DivisionRank.MemberList := TStringList.Create;
      if nType = 0 then begin
        New(DivisionMember);
        DivisionMember.btGender:= PlayObject.m_btGender;
        DivisionMember.btJob:= PlayObject.m_btJob;
        DivisionMember.nLevel:= PlayObject.m_Abil.Level;
        DivisionMember.nContribution:= 0;//����ֵ
        DivisionMember.dLogonTime:= Date();
        DivisionMember.boStatus:= True;
        DivisionRank.MemberList.AddObject(PlayObject.m_sCharName, TObject(DivisionMember));
      end else begin
        New(DivisionMember);
        DivisionMember.btGender:= 0;
        DivisionMember.btJob:= 0;
        DivisionMember.nLevel:= 65535;
        DivisionMember.nContribution:= 0;//����ֵ
        DivisionMember.dLogonTime:= Date();
        DivisionRank.MemberList.AddObject('*����ʦ��', TObject(DivisionMember));
      end;
      m_RankList.Add(DivisionRank);
      SaveDivisionInfoFile();
    end;
    Result := True;
  except
    MainOutMessage(format('{%s} TDivision.SetDivisionInfo',[g_sExceptionVer]));
  end;
end;

//ȡʦ���ϴ�����
function TDivision.GetChiefName: string;
var
  DivisionRank: pTDivisionRank;
begin
  Result := '';
  try
    if m_RankList.Count <= 0 then Exit;
    DivisionRank := m_RankList.Items[0];
    if DivisionRank.MemberList.Count <= 0 then Exit;
    Result := DivisionRank.MemberList.Strings[0];
  except
    MainOutMessage(format('{%s} TDivision.GetChiefName',[g_sExceptionVer]));
  end;
end;
//��ʱ����ʦ������
procedure TDivision.CheckSaveDivisionFile();
begin
  if boChanged and ((GetTickCount - dwSaveTick) > 30000{30 * 1000}) then begin
    boChanged := False;
    SaveDivisionInfoFile();
  end;
end;

//����ʦ������
procedure TDivision.UpdateDivisionFile();
begin
  boChanged := True;
  dwSaveTick := GetTickCount();
  //SaveDivisionInfoFile();
end;

procedure TDivision.BackupDivisionFile;
var
  I, II: Integer;
  PlayObject: TPlayObject;
  DivisionRank: pTDivisionRank;
  sName: String;
begin
  try
    if nServerIndex = 0 then
      SaveDivisionFile(g_Config.sDivisionDir + sDivisionName + '.' + IntToStr(GetTickCount) + '.bak');
    if m_RankList.Count > 0 then begin
      for I := 0 to m_RankList.Count - 1 do begin
        DivisionRank := m_RankList.Items[I];
        if DivisionRank.MemberList.Count > 0 then begin
          for II := 0 to DivisionRank.MemberList.Count - 1 do begin
            sName:= DivisionRank.MemberList.Strings[II];
            PlayObject := UserEngine.GetPlayObjectEx1(sName);
            if PlayObject <> nil then begin
              {$IF M2Version <> 2}
              PlayObject.m_MyDivision := nil;
              {$IFEND}
            end;
          end;
        end;
        DivisionRank.MemberList.Free;
        Dispose(DivisionRank);
      end;
    end;
    m_RankList.Clear;
    NoticeList.Clear;
    ApplyList.Clear;
    SaveDivisionInfoFile();
  except
    MainOutMessage(format('{%s} TDivision.BackupDivisionFile',[g_sExceptionVer]));
  end;
end;
//�Ƿ�Ϊ����������Ľ�ɫ
function TDivision.IsApplyUser(sCharName: String): Boolean;
begin
  Result := ApplyList.IndexOf(sCharName) > -1;
end;
//������ʦ��
function TDivision.ApplyMember(PlayObject: TPlayObject): Byte;
var
  I: Integer;
  ApplyDivision: pTApplyDivision;
begin
  Result := 0;
  try
    {$IF M2Version <> 2}
    if nDivisonType <> 1 then begin//���ǹ�������
      I:= ApplyList.IndexOf(PlayObject.m_sCharName);
      if I = -1 then begin
        New(ApplyDivision);
        ApplyDivision.sChrName:= PlayObject.m_sCharName;
        ApplyDivision.btGender:= PlayObject.m_btGender;
        ApplyDivision.btJob:= PlayObject.m_btJob;
        ApplyDivision.nLevel:= PlayObject.m_Abil.Level;
        ApplyList.AddObject(ApplyDivision.sChrName, TObject(ApplyDivision));
        SaveDivisionFile(g_Config.sDivisionDir + sDivisionName + '.txt');
        Result := 1;
      end;
    end else begin//��������ֱ�Ӽ�������
      if AddMember(PlayObject, PlayObject.m_sCharName) then begin
        Result := 2;
        PlayObject.m_MyDivision := Self;
        PlayObject.SysMsg(Format('%sͬ����������ɵ�����',[sDivisionName]), c_Green, t_Hint);
      end;
    end;
    {$IFEND}
  except
    MainOutMessage(format('{%s} TDivision.ApplyMember',[g_sExceptionVer]));
  end;
end;
//ȡ����������
function TDivision.DelApplyMember(sCharName: String): Boolean;
var
  I: Integer;
  ApplyDivision: pTApplyDivision;
begin
  Result := False;
  try
    if nDivisonType <> 1 then begin//���ǹ�������
      I:= ApplyList.IndexOf(sCharName);
      if I > -1 then begin
        ApplyDivision:= pTApplyDivision(ApplyList.Objects[I]);
        if ApplyDivision <> nil then begin
          ApplyList.Delete(I);
          Dispose(ApplyDivision);
          Result := True;
        end;
        SaveDivisionFile(g_Config.sDivisionDir + sDivisionName + '.txt');
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivision.DelApplyMember',[g_sExceptionVer]));
  end;
end;
//ʦ�����ӳ�Ա
function TDivision.AddMember(PlayObject: TPlayObject;sUserName: String): Boolean;
var
  I: Integer;
  DivisionRank, DivisionRank18: pTDivisionRank;
  DivisionMember: pTDivisionMember;
  ApplyDivision: pTApplyDivision;
begin
  Result := False;
  try
    DivisionRank18 := nil;
    if m_RankList.Count > 0 then begin
      for I := 0 to m_RankList.Count - 1 do begin
        DivisionRank := m_RankList.Items[I];
        if DivisionRank.nRankNo = 99 then begin
          DivisionRank18 := DivisionRank;
          Break;
        end;
      end;
    end;
    if DivisionRank18 = nil then begin
      New(DivisionRank18);
      DivisionRank18.nRankNo := 99;
      {$IF M2Version <> 2}
      DivisionRank18.sRankName := g_Config.sDivisionMember;
      {$IFEND}
      DivisionRank18.MemberList := TStringList.Create;
      m_RankList.Add(DivisionRank18);
    end;

    if PlayObject <> nil then begin
      New(DivisionMember);
      DivisionMember.btGender:= PlayObject.m_btGender;
      DivisionMember.btJob:= PlayObject.m_btJob;
      DivisionMember.nLevel:= PlayObject.m_Abil.Level;
      DivisionMember.nContribution:= 0;//����ֵ
      DivisionMember.dLogonTime:= Date();
      DivisionMember.boStatus:= True;
      DivisionRank18.MemberList.AddObject(sUserName, TObject(DivisionMember));
      SaveDivisionInfoFile();//����ʦ���ļ�
      Result := True;
    end else begin//��ɫδ����
      I:= ApplyList.IndexOf(sUserName);
      if I > -1 then begin
        ApplyDivision:= pTApplyDivision(ApplyList.Objects[I]);
        if ApplyDivision <> nil then begin
          New(DivisionMember);
          DivisionMember.btGender:= ApplyDivision.btGender;
          DivisionMember.btJob:= ApplyDivision.btJob;
          DivisionMember.nLevel:= ApplyDivision.nLevel;
          DivisionMember.nContribution:= 0;//����ֵ
          DivisionMember.dLogonTime:= Date();
          DivisionMember.boStatus:= False;
          DivisionRank18.MemberList.AddObject(sUserName, TObject(DivisionMember));
          SaveDivisionInfoFile();//����ʦ���ļ�
          Result := True;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivision.AddMember',[g_sExceptionVer]));
  end;
end;

//ʦ��ɾ����Ա
function TDivision.DelMember(sHumName: string): Boolean;
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
begin
  Result := False;
  try
    for I := 0 to m_RankList.Count - 1 do begin
      DivisionRank := m_RankList.Items[I];
      II:= DivisionRank.MemberList.IndexOf(sHumName);
      if II > -1 then begin
        DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
        DivisionRank.MemberList.Delete(II);
        if DivisionMember <> nil then Dispose(DivisionMember);
        Result := True;
        Break;
      end;
      {for II := DivisionRank.MemberList.Count - 1 downto 0 do begin
        if DivisionRank.MemberList.Count <= 0 then Break;
        if DivisionRank.MemberList.Strings[II] = sHumName then begin
          DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
          DivisionRank.MemberList.Delete(II);
          if DivisionMember <> nil then Dispose(DivisionMember);
          Result := True;
          Break;
        end;
      end;
      if Result then Break; }
    end;
    if Result then UpdateDivisionFile;
  except
    MainOutMessage(format('{%s} TDivision.DelMember',[g_sExceptionVer]));
  end;
end;
//ȡ�����������ֵ
function TDivision.GetMemberContribution(sHumName: string): LongWord;
var
  I, II: Integer;
  DivisionRank: pTDivisionRank;
  DivisionMember: pTDivisionMember;
begin
  Result := 0;
  try
    for I := 0 to m_RankList.Count - 1 do begin
      DivisionRank := m_RankList.Items[I];
      II:= DivisionRank.MemberList.IndexOf(sHumName);
      if II > -1 then begin
        DivisionMember:= pTDivisionMember(DivisionRank.MemberList.Objects[II]);
        if DivisionMember <> nil then Result := DivisionMember.nContribution;
        Exit;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivision.GetMemberContribution',[g_sExceptionVer]));
  end;
end;
//ȡ������
function TDivision.CancelDivision(sHumName: string): Boolean;
var
  DivisionRank: pTDivisionRank;
begin
  Result := False;
  try
    if GetMemberCount <> 1 then Exit;//��Ա����1�����ܽ�ɢ
    DivisionRank := m_RankList.Items[0];
    if DivisionRank.MemberList.Strings[0] = sHumName then begin
      Result := True;
    end;
  except
    MainOutMessage(format('{%s} TDivision.CancelDivision',[g_sExceptionVer]));
  end;
end;

function TDivision.GetMemberCount: Integer;
var
  I: Integer;
  DivisionRank: pTDivisionRank;
begin
  Result := 0;
  try
    if m_RankList.Count > 0 then begin
      for I := 0 to m_RankList.Count - 1 do begin
        DivisionRank := m_RankList.Items[I];
        Inc(Result, DivisionRank.MemberList.Count);
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivision.GetMemberCount',[g_sExceptionVer]));
  end;
end;
//�ж��Ƿ񳬹���������
function TDivision.GetMemgerIsFull: Boolean;
begin
  Result := False;
  if GetMemberCount >= m_nDivisionMemberCount then begin
    Result := True;
  end;
end;

procedure TDivision.SetChiefPopularity(nPoint: Integer);
begin
  nDivisionPopularity := nPoint;
  boChanged := True;
end;

procedure TDivision.SetChiefPassHeartLevel(nPoint: Byte);
begin
  nPassHeartLevel := nPoint;
  boChanged := True;
end;

{ TDivisionManager }
//�½�ʦ��
function TDivisionManager.AddDivision(sDivisionName: string; PlayObject: TPlayObject): Boolean;
var
  Division: TDivision;
begin
  Result := False;
  try
    if CheckGuildName(sDivisionName) and (FindDivision(sDivisionName) = nil) and (sDivisionName <> '') then begin
      Division := TDivision.Create(sDivisionName, 0);
      Division.SetDivisionInfo(PlayObject, 0);
      {$IF M2Version <> 2}
      Division.m_nDivisionMemberCount:= g_Config.nDivisionMemberCount;//��Ա����
      if PlayObject.m_MagicSkill_105 <> nil then begin
        if PlayObject.m_sHeartName <> '' then
          Division.sHeartName:= PlayObject.m_sHeartName
        else Division.sHeartName:= PlayObject.m_MagicSkill_105.MagicInfo.sMagicName;//�ķ�����
        Division.nHeartTpye:= PlayObject.m_nHeartType;//�ķ����� 0-�Ͻ� 1-��ľ 2-��� 3-��ˮ 4-����
        Case PlayObject.m_MagicSkill_105.btLevel of //�����ķ��ȼ�
          1..4: Division.nHeartLevel:= 1;
          5..9: Division.nHeartLevel:= 2;
          10..19: Division.nHeartLevel:= 3;
          20..29: Division.nHeartLevel:= 4;
          30..39: Division.nHeartLevel:= 5;
          40..49: Division.nHeartLevel:= 6;
          50..59: Division.nHeartLevel:= 7;
          60..69: Division.nHeartLevel:= 8;
          70..100: Division.nHeartLevel:= 9;
        end;
      end;
      {$IFEND}
      DivisionList.Add(Division);
      SaveDivisionList();
      Result := True;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.AddDivision',[g_sExceptionVer]));
  end;
end;
//ɾ���л�
function TDivisionManager.DelDivision(sDivisionName: string): Boolean;
var
  I: Integer;
  Division: TDivision;
begin
  Result := False;
  try
    for I := DivisionList.Count - 1 downto 0 do begin
      if DivisionList.Count <= 0 then Break;
      Division := TDivision(DivisionList.Items[I]);
      if CompareText(Division.sDivisionName, sDivisionName) = 0 then begin
        //if Division.m_RankList.Count > 1 then Break;
        Division.BackupDivisionFile();
        DivisionList.Delete(I);
        Division.Free;
        SaveDivisionList();
        Result := True;
        Break;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.DelDivision',[g_sExceptionVer]));
  end;
end;

procedure TDivisionManager.ClearDivisionInf;
var
  I: Integer;
begin
  try
    if DivisionList.Count > 0 then begin
      for I := 0 to DivisionList.Count - 1 do begin
        TDivision(DivisionList.Items[I]).Free;
      end;
    end;
    DivisionList.Clear;
  except
    MainOutMessage(format('{%s} TDivisionManager.ClearDivisionInf',[g_sExceptionVer]));
  end;
end;

constructor TDivisionManager.Create;
begin
  DivisionList:= TList.Create;
end;

destructor TDivisionManager.Destroy;
begin
  ClearDivisionInf;
  DivisionList.Free;
  inherited;
end;
//���������������
function TDivisionManager.UpDivisionInfo(sDivisionName: String; HeartTpye, PassHeartLevel: Byte; Popularity: Integer): Boolean;
var
  Division: TDivision;
begin
  Result := False;
  try
    Division:= FindDivision(sDivisionName);
    if Division <> nil then begin
      Division.nHeartTpye:= HeartTpye;
      Division.nHeartLevel:= PassHeartLevel;
      Division.nPopularity:= Popularity;
      Division.SaveDivisionConfig(g_Config.sDivisionDir + Division.sDivisionName + '.ini');
      Result := True;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.UpDivisionInfo',[g_sExceptionVer]));
  end;
end;
//����ʦ��
function TDivisionManager.FindDivision(sDivisionName: string): TDivision;
var
  I: Integer;
begin
  Result := nil;
  try
    if DivisionList.Count > 0 then begin
      for I := 0 to DivisionList.Count - 1 do begin
        if TDivision(DivisionList.Items[I]).sDivisionName = sDivisionName then begin
          Result := TDivision(DivisionList.Items[I]);
          Break;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.FindDivision',[g_sExceptionVer]));
  end;
end;
//������ʦ���Ҳ�����
function TDivisionManager.FindDivisionEx(sChiefName: string): TDivision;
var
  I: Integer;
begin
  Result := nil;
  try
    if DivisionList.Count > 0 then begin
      for I := 0 to DivisionList.Count - 1 do begin
        if TDivision(DivisionList.Items[I]).GetChiefName = sChiefName then begin
          Result := TDivision(DivisionList.Items[I]);
          Break;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.FindDivisionEx',[g_sExceptionVer]));
  end;
end;

procedure TDivisionManager.LoadDivisionInfo;
var
  LoadList: TStringList;
  Division: TDivision;
  sDivisionName: string;
  I: Integer;
begin
  try
    {$IF M2Version <> 2}
    if FileExists(g_Config.sDivisionFile) then begin
      try
        LoadList := TStringList.Create;
        try
          LoadList.LoadFromFile(g_Config.sDivisionFile);
          if LoadList.Count > 0 then begin
            for I := 0 to LoadList.Count - 1 do begin
              sDivisionName := Trim(LoadList.Strings[I]);
              if sDivisionName <> '' then begin
                if CompareText(sDivisionName, '����ʦ��')= 0 then
                  Division := TDivision.Create(sDivisionName, 1)
                else Division := TDivision.Create(sDivisionName, 0);
                DivisionList.Add(Division);
              end;
            end;
          end else begin//20111006 ����
            Division := TDivision.Create('����ʦ��', 1);
            Division.SetDivisionInfo(nil, 1);
            Division.sHeartName:= '�����ķ�';//�ķ�����
            Division.nHeartTpye:= 0;//�ķ����� 0-�Ͻ� 1-��ľ 2-��� 3-��ˮ 4-����
            Division.nHeartLevel:= g_Config.nPublicHeartLevel;//�����ķ��ȼ�
            DivisionList.Add(Division);
            SaveDivisionList;
            MainOutMessage('�Ѷ�ȡ ' + IntToStr(DivisionList.Count) + '��ʦ����Ϣ...');
          end;
        finally
          LoadList.Free;
        end;
        for I := DivisionList.Count - 1 downto 0 do begin
          if DivisionList.Count <= 0 then Break;
          Division := DivisionList.Items[I];
          if not Division.LoadDivision() then begin
            MainOutMessage(Division.sDivisionName + ' ��ȡ��������');
            Division.Free;
            DivisionList.Delete(I);
            SaveDivisionList();
          end;
        end;
        MainOutMessage('�Ѷ�ȡ ' + IntToStr(DivisionList.Count) + '��ʦ����Ϣ...');
      except
        on E: Exception do MainOutMessage('��ȡʦ����Ϣ�ļ�['+g_Config.sDivisionFile+']�쳣��'+ E.Message);
      end;
    end else begin
      Division := TDivision.Create('����ʦ��', 1);
      Division.SetDivisionInfo(nil, 1);
      Division.sHeartName:= '�����ķ�';//�ķ�����
      Division.nHeartTpye:= 0;//�ķ����� 0-�Ͻ� 1-��ľ 2-��� 3-��ˮ 4-����
      Division.nHeartLevel:= g_Config.nPublicHeartLevel;//�����ķ��ȼ�
      DivisionList.Add(Division);
      SaveDivisionList;
      MainOutMessage('�Ѷ�ȡ ' + IntToStr(DivisionList.Count) + '��ʦ����Ϣ...');
    end;
    {$IFEND}
  except
    MainOutMessage(format('{%s} TDivisionManager.LoadDivisionInfo',[g_sExceptionVer]));
  end;
end;
//ȡ���������ʦ��
function TDivisionManager.MemberOfDivision(sName: string): TDivision;
var
  I: Integer;
begin
  Result := nil;
  try
    if DivisionList.Count > 0 then begin
      for I := 0 to DivisionList.Count - 1 do begin
        if TDivision(DivisionList.Items[I]).IsMember(sName) then begin
          Result := TDivision(DivisionList.Items[I]);
          Break;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.MemberOfDivision',[g_sExceptionVer]));
  end;
end;

procedure TDivisionManager.SaveDivisionList;
var
  I: Integer;
  SaveList: TStringList;
begin
  try
    if nServerIndex <> 0 then Exit;
    SaveList := TStringList.Create;
    try
      if DivisionList.Count > 0 then begin
        for I := 0 to DivisionList.Count - 1 do begin
          SaveList.Add(TDivision(DivisionList.Items[I]).sDivisionName);
        end; // for
      end;
      try
        SaveList.SaveToFile(g_Config.sDivisionFile);
      except
        MainOutMessage('ʦ����Ϣ����ʧ�ܣ�����');
      end;
    finally
      SaveList.Free;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.SaveDivisionList',[g_sExceptionVer]));
  end;
end;
//��ȡ��������������ŵ�ʦ����
function TDivisionManager.LoadUserApplyInfo(sUserName: String):String;
var
  IniFile: TIniFile;
  Division: TDivision;
  nName: String;
begin
  Result := '';
  try
    if FileExists(g_Config.sApplyDivisionFile) then begin
      IniFile := TIniFile.Create(g_Config.sApplyDivisionFile);
      try
        nName:= IniFile.ReadString(sUserName,'��������', '');
        if nName <> '' then begin
          Division:= FindDivision(nName);
          if Division <> nil then Result := nName;
        end;
      finally
        IniFile.free;
      end;
    end;
  except
    MainOutMessage(format('{%s} TDivisionManager.LoadUserApplyInfo',[g_sExceptionVer]));
  end;
end;
//�����������ŵ�����
procedure TDivisionManager.SaveUserApplyList(sUserName, sDivisionName: String);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(g_Config.sApplyDivisionFile);
  try
    IniFile.WriteString(sUserName, '��������', sDivisionName);
  finally
    IniFile.Free;
  end;
end;

procedure TDivisionManager.Run;
var
  I: Integer;
  Division: TDivision;
begin
  try
    if DivisionList.Count > 0 then begin
      for I := 0 to DivisionList.Count - 1 do begin
        Division := TDivision(DivisionList.Items[I]);
        if Division <> nil then Division.CheckSaveDivisionFile;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TDivisionManager.Run', [g_sExceptionVer]));
  end;
end;

end.
