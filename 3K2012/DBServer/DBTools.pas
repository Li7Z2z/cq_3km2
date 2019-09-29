unit DBTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, ExtCtrls, Spin, Buttons;

type
  TfrmDBTool = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GridMirDBInfo: TStringGrid;
    GroupBox2: TGroupBox;
    GridHumDBInfo: TStringGrid;
    TabSheet2: TTabSheet;
    ButtonStartRebuild: TButton;
    LabelProcess: TLabel;
    TimerShowInfo: TTimer;
    GroupBox3: TGroupBox;
    CheckBoxDelDenyChr: TCheckBox;
    CheckBoxDelAllItem: TCheckBox;
    CheckBoxDelAllSkill: TCheckBox;
    CheckBoxDelBonusAbil: TCheckBox;
    CheckBoxDelLevel: TCheckBox;
    CheckBoxDelMinLevel: TCheckBox;
    EditLevel: TSpinEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    TabSheet3: TTabSheet;
    Button2: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    EditUserCount: TSpinEdit;
    Memo1: TMemo;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    PageControl2: TPageControl;
    TabSheet6: TTabSheet;
    GroupBox4: TGroupBox;
    MemoHumQuery: TMemo;
    TabSheet7: TTabSheet;
    GroupBox5: TGroupBox;
    MemoHumEdit: TMemo;
    ButtonHumEdit: TButton;
    ButtonHumQuery: TButton;
    Label2: TLabel;
    EditMinLevel: TSpinEdit;
    EditMaxLevel: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartRebuildClick(Sender: TObject);
    procedure TimerShowInfoTimer(Sender: TObject);
    procedure CheckBoxDelDenyChrClick(Sender: TObject);
    procedure CheckBoxDelLevelClick(Sender: TObject);
    procedure CheckBoxDelAllItemClick(Sender: TObject);
    procedure CheckBoxDelAllSkillClick(Sender: TObject);
    procedure CheckBoxDelBonusAbilClick(Sender: TObject);
    procedure EditLevelChange(Sender: TObject);
    procedure CheckBoxDelMinLevelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ButtonHumQueryClick(Sender: TObject);
    procedure ButtonHumEditClick(Sender: TObject);
  private
    procedure RefDBInfo();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

  TBuildDB = class(TThread)
  private
    procedure UpdateProcess();
    { Private declarations }
  protected
    procedure Execute; override;
  end;
var
  frmDBTool: TfrmDBTool;

implementation

uses HumDB, DBShare, Grobal2, HUtil32, filectrl;
var
  boRebuilding: Boolean = False;
  BuildDB: TBuildDB;
  nProcID: Integer;
  nProcMax: Integer;
  UpdateProcessTick: LongWord;
  boDelDenyChr: Boolean = False;
  boDelAllItem: Boolean = False;
  boDelAllSkill: Boolean = False;
  boDelBonusAbil: Boolean = False;
  boDelLevel: Boolean = False;
  boDelMinLevel: Boolean = False;//ɾ���ȼ�С��ָ��ֵ�Ľ�ɫ 20080816
  boDelNameEorr: Boolean = False;
  nMinLevel: Integer;


{$R *.dfm}

  { TfrmDBTool }

procedure TfrmDBTool.Open;
begin
  RefDBInfo();
  Edit2.Text:= sEnvir;//�Զ��һ��ļ�����·�� 20090402
  ShowModal;
end;

procedure TfrmDBTool.RefDBInfo;
begin
  {$IF DBSMode = 0}
  try
    if HumDataDB.OpenEx then begin
      GridMirDBInfo.Cells[1, 1] := HumDataDB.m_sDBFileName;
      GridMirDBInfo.Cells[1, 2] := HumDataDB.m_Header.sDesc;
      GridMirDBInfo.Cells[1, 3] := IntToStr(HumDataDB.m_Header.nHumCount);
      GridMirDBInfo.Cells[1, 4] := IntToStr(HumDataDB.m_QuickList.Count);
      GridMirDBInfo.Cells[1, 5] := IntToStr(HumDataDB.m_DeletedList.Count);
      GridMirDBInfo.Cells[1, 6] := DateTimeToStr(HumDataDB.m_Header.dUpdateDate);
      GridMirDBInfo.Cells[1, 7] := IntToStr(HumDataDB.m_Header.n70);
    end;
  finally
    HumDataDB.Close();
  end;
  try
    if HumChrDB.OpenEx then begin
      GridHumDBInfo.Cells[1, 1] := HumChrDB.m_sDBFileName;
      GridHumDBInfo.Cells[1, 2] := HumChrDB.m_Header.sDesc;
      GridHumDBInfo.Cells[1, 3] := IntToStr(HumChrDB.m_Header.nHumCount);
      GridHumDBInfo.Cells[1, 4] := IntToStr(HumChrDB.m_QuickList.Count);
      GridHumDBInfo.Cells[1, 5] := IntToStr(HumChrDB.m_DeletedList.Count);
      GridHumDBInfo.Cells[1, 6] := DateTimeToStr(HumChrDB.m_Header.dUpdateDate);
      GridHumDBInfo.Cells[1, 7] := IntToStr(HumChrDB.m_Header.n70);
    end;
  finally
    HumChrDB.Close();
  end;
  {$IFEND}
end;

procedure TfrmDBTool.FormCreate(Sender: TObject);
begin
{$IF DBSMode = 1}
  TabSheet1.TabVisible:= False;
  TabSheet2.TabVisible:= False;
  TabSheet4.TabVisible:= False;
  TabSheet5.TabVisible:= False;
{$ELSE}
  TabSheet4.TabVisible:= False;
  TabSheet5.TabVisible:= False;
  GridMirDBInfo.Cells[0, 0] := '����';
  GridMirDBInfo.Cells[1, 0] := '����';
  GridMirDBInfo.Cells[0, 1] := '�ļ�λ��';
  GridMirDBInfo.Cells[0, 2] := '�ļ���ʶ';
  GridMirDBInfo.Cells[0, 3] := '��¼����';
  GridMirDBInfo.Cells[0, 4] := '��Ч����';
  GridMirDBInfo.Cells[0, 5] := 'ɾ������';
  GridMirDBInfo.Cells[0, 6] := '��������';
  GridMirDBInfo.Cells[0, 7] := '��ǰ�汾';

  GridHumDBInfo.Cells[0, 0] := '����';
  GridHumDBInfo.Cells[1, 0] := '����';
  GridHumDBInfo.Cells[0, 1] := '�ļ�λ��';
  GridHumDBInfo.Cells[0, 2] := '�ļ���ʶ';
  GridHumDBInfo.Cells[0, 3] := '��¼����';
  GridHumDBInfo.Cells[0, 4] := '��Ч����';
  GridHumDBInfo.Cells[0, 5] := 'ɾ������';
  GridHumDBInfo.Cells[0, 6] := '��������';
  GridHumDBInfo.Cells[0, 7] := '��ǰ�汾';
{$IFEND}
end;

procedure TfrmDBTool.ButtonStartRebuildClick(Sender: TObject);
begin
  boAutoClearDB := False;
  boRebuilding := True;
  ButtonStartRebuild.Enabled := False;
  BuildDB := TBuildDB.Create(False);
  BuildDB.FreeOnTerminate := True;
  TimerShowInfo.Enabled := True;
end;

{ TBuildDB }

procedure TBuildDB.Execute;
var
  i: Integer;
  NewChrDB: TFileHumDB;
  NewDataDB: TFileDB;
  sHumDBFile, sMirDBFile: string;
  SrcHumanRCD: THumDataInfo;
  HumRecord: THumInfo;
  nSrcHumIndex: Integer;
  sAccount: String;
begin
  {$IF DBSMode = 0}
  sHumDBFile := sHumDBFilePath + 'NewHum.DB';
  sMirDBFile := sHumDBFilePath + 'NewMir.DB';
  if FileExists(sHumDBFile) then DeleteFile(sHumDBFile);
  if FileExists(sMirDBFile) then DeleteFile(sMirDBFile);

  NewChrDB := TFileHumDB.Create(sHumDBFile);
  NewDataDB := TFileDB.Create(sMirDBFile);
  try
    if HumDataDB.Open and HumChrDB.Open then begin
      nProcID := 0;
      nProcMax := HumDataDB.m_QuickList.Count - 1;
      for i := 0 to HumDataDB.m_QuickList.Count - 1 do begin
        nProcID := i;
        if (HumDataDB.Get(i, SrcHumanRCD) < 0) or (SrcHumanRCD.Data.sChrName = '') or (SrcHumanRCD.Data.sAccount= '') then Continue;
        if boDelNameEorr then begin
          if (HumChrDB.ChrCountOfAccount(SrcHumanRCD.Data.sAccount)<= 0) and (HumChrDB.Index(SrcHumanRCD.Data.sChrName)<=0) then begin
            frmDBTool.Memo1.Lines.Add('[ɾ������]�˺ţ�'+SrcHumanRCD.Data.sAccount+' ��ɫ��'+SrcHumanRCD.Data.sChrName);
            Continue;//���Hum.DB���Ƿ���ڶ�Ӧ���˺�,������������ 20090106
          end;
          if CompareText(SrcHumanRCD.Data.sChrName, SrcHumanRCD.Header.sName) <> 0 then begin
            frmDBTool.Memo1.Lines.Add('[ɾ������]��ɫ1��'+SrcHumanRCD.Header.sName+' ��ɫ2��'+SrcHumanRCD.Data.sChrName);
            Continue;//������������Ƿ�һ�£���һ������Ϊ������ 20090510
          end;
        end;
        if boDelDenyChr then begin
          FillChar(HumRecord, SizeOf(HumRecord), #0);
          nSrcHumIndex := HumChrDB.Index(SrcHumanRCD.Data.sChrName);
          if HumChrDB.GetBy(nSrcHumIndex, HumRecord) then begin
            if HumRecord.Header.boDeleted then begin//20091014 �޸�
              frmDBTool.Memo1.Lines.Add('[ɾ������]�˺ţ�'+SrcHumanRCD.Data.sAccount+' ��ɫ��'+SrcHumanRCD.Data.sChrName);
              Continue;
            end;
          end;
        end;
        if boDelMinLevel then begin//ɾ���ȼ�С��ָ��ֵ�Ľ�ɫ 20080816
          if SrcHumanRCD.Data.Abil.Level < nMinLevel then  Continue;
        end;
        if boDelLevel then begin
          FillChar(SrcHumanRCD.Data.Abil, SizeOf(TAbility), #0);
          SrcHumanRCD.Data.sCurMap := '3';
          SrcHumanRCD.Data.wCurX := 330;
          SrcHumanRCD.Data.wCurY := 330;
          SrcHumanRCD.Data.nGold := 0;
          SrcHumanRCD.Data.sHomeMap := '3';
          SrcHumanRCD.Data.wHomeX := 330;
          SrcHumanRCD.Data.wHomeY := 330;
          SrcHumanRCD.Data.btReLevel := 0;
          SrcHumanRCD.Data.sDearName := '';
          SrcHumanRCD.Data.boMaster := False;
          SrcHumanRCD.Data.sDearName := '';
          SrcHumanRCD.Data.btCreditPoint := 0;
          SrcHumanRCD.Data.btMarryCount := 0;
          SrcHumanRCD.Data.sStoragePwd := '';
          SrcHumanRCD.Data.nGameGold := 0;
          SrcHumanRCD.Data.nPKPoint := 0;
        end;

        if boDelAllItem then begin
          FillChar(SrcHumanRCD.Data.HumItems, SizeOf(THumItems), #0);
          FillChar(SrcHumanRCD.Data.BagItems, SizeOf(THumItems), #0);
          FillChar(SrcHumanRCD.Data.StorageItems, SizeOf(THumItems), #0);
          FillChar(SrcHumanRCD.Data.HumAddItems, SizeOf(THumItems), #0);
        end;

        if boDelAllSkill then begin
          FillChar(SrcHumanRCD.Data.HumMagics, SizeOf(THumMagics), #0);
        end;
        if boDelBonusAbil then begin
          FillChar(SrcHumanRCD.Data.BonusAbil, SizeOf(TNakedAbility), #0);
          SrcHumanRCD.Data.nBonusPoint := 0;
        end;

        try
          if NewDataDB.Open then begin
            if not NewDataDB.Add(SrcHumanRCD) then Continue;
          end;
        finally
          NewDataDB.Close;
        end;

        FillChar(HumRecord, SizeOf(THumInfo), #0);
        try
          if NewChrDB.Open then begin
            if NewChrDB.ChrCountOfAccount(SrcHumanRCD.Data.sChrName) < 2 then begin
              HumRecord.sChrName := SrcHumanRCD.Data.sChrName;
              HumRecord.sAccount := SrcHumanRCD.Data.sAccount;
              HumRecord.Header.boIsHero:= SrcHumanRCD.Data.boIsHero;//20080916 ͳһӢ�۱�ʶ
              HumRecord.boDeleted := SrcHumanRCD.Header.boDeleted;//20090824 �޸�
              HumRecord.btCount := 0;
              HumRecord.Header.sName := SrcHumanRCD.Data.sChrName;
              NewChrDB.Add(HumRecord);
            end;
          end;
        finally
          NewChrDB.Close;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
    HumChrDB.Close;
  end;

  NewChrDB.Free;
  NewDataDB.Free;
  {$IFEND}
  boRebuilding := False;
end;

procedure TBuildDB.UpdateProcess;
begin
  if (GetTickCount - UpdateProcessTick > 1000) or (nProcID >= nProcMax) then begin
    UpdateProcessTick := GetTickCount();
    //frmDBTool.LabelProcess.Caption:=IntToStr(nProcID) + '/' + IntToStr(nProcMax);
  end;

end;

procedure TfrmDBTool.TimerShowInfoTimer(Sender: TObject);
begin
  LabelProcess.Caption := IntToStr(nProcID) + '/' + IntToStr(nProcMax);
  if not boRebuilding then begin
    TimerShowInfo.Enabled := False;
    LabelProcess.Caption := '��ɣ�����';
    ShowMessage('��ɣ�����');
    ButtonStartRebuild.Enabled := True;
  end;
end;

procedure TfrmDBTool.CheckBoxDelDenyChrClick(Sender: TObject);
begin
  boDelDenyChr := CheckBoxDelDenyChr.Checked;
end;

procedure TfrmDBTool.CheckBoxDelLevelClick(Sender: TObject);
begin
  boDelLevel := CheckBoxDelLevel.Checked;
end;

procedure TfrmDBTool.CheckBoxDelAllItemClick(Sender: TObject);
begin
  boDelAllItem := CheckBoxDelAllItem.Checked;
end;

procedure TfrmDBTool.CheckBoxDelAllSkillClick(Sender: TObject);
begin
  boDelAllSkill := CheckBoxDelAllSkill.Checked;
end;

procedure TfrmDBTool.CheckBoxDelBonusAbilClick(Sender: TObject);
begin
  boDelBonusAbil := CheckBoxDelBonusAbil.Checked;
end;

procedure TfrmDBTool.EditLevelChange(Sender: TObject);
begin
  nMinLevel:= EditLevel.Value;
end;

procedure TfrmDBTool.CheckBoxDelMinLevelClick(Sender: TObject);
begin
  boDelMinLevel:= CheckBoxDelMinLevel.Checked;
end;

//�޸�Mir.DB�˺���Hum.DB����Ӧ 20081220
procedure TfrmDBTool.Button1Click(Sender: TObject);
var
  i: Integer;
  SrcHumanRCD: THumDataInfo;
  HumRecord: THumInfo;
  nIdx: Integer;
begin
{$IF DBSMode = 0}
  Button1.Enabled:= False;
  try
    if HumChrDB.Open and HumDataDB.Open then begin
      for I := 0 to HumChrDB.m_QuickList.Count - 1 do begin
        if HumChrDB.GetBy(I, HumRecord) then begin
          nIdx := HumDataDB.Index(HumRecord.sChrName);
          if nIdx >= 0 then begin
            if HumDataDB.Get(nIdx, SrcHumanRCD) >= 0 then begin
              if (SrcHumanRCD.Data.sChrName = '') then Continue;
              if CompareText(HumRecord.sAccount , SrcHumanRCD.Data.sAccount) <> 0 then begin
                SrcHumanRCD.Data.sAccount:= HumRecord.sAccount;
                HumDataDB.Update(nIdx, SrcHumanRCD);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
    HumChrDB.Close;
    Button1.Enabled:= True;
    ShowMessage('�޸�Mir.DB��ɣ�����');
  end;
{$IFEND}
end;

procedure TfrmDBTool.CheckBox1Click(Sender: TObject);
begin
  boDelNameEorr:= CheckBox1.Checked;
end;

//��ɫ�� �˺ŵ���
procedure TfrmDBTool.Button2Click(Sender: TObject);
var
  i, J, L: Integer;
  SrcHumanRCD: THumDataInfo;
  HumRecord: THumInfo;
  nIdx: Integer;
  sLoadList: TStringList;
  bo15: Boolean;
  s10, sHumName, sListFileName, sAcount: string;
begin
  Button2.Enabled:= False;
  EditUserCount.ReadOnly:= True;
  EditMinLevel.ReadOnly:= True;
  EditMaxLevel.ReadOnly:= True;
  try
    sLoadList := TStringList.Create;
    sListFileName := Edit2.text+ 'AutoAddExpPlay.txt';
    if FileExists(sListFileName) then  DeleteFile(sListFileName);
    {$IF DBSMode = 1}
    if HumDataDB.Open then begin
      HumDataDB.GetAutoAddExpPlay(EditUserCount.Value, EditMaxLevel.Value, sLoadList);
    end;
    {$ELSE}
    if HumChrDB.Open and HumDataDB.Open then begin
      for I := 0 to HumChrDB.m_QuickList.Count - 1 do begin
        if L > EditUserCount.Value then Break;
        if HumChrDB.GetBy(I, HumRecord) then begin
          nIdx := HumDataDB.Index(HumRecord.sChrName);
          if nIdx >= 0 then begin
            if HumDataDB.Get(nIdx, SrcHumanRCD) >= 0 then begin
              if (SrcHumanRCD.Data.sChrName = '') or (SrcHumanRCD.Header.boDeleted) or
                 (SrcHumanRCD.Data.sAccount = '') or (SrcHumanRCD.Data.boIsHero) then Continue;
              if (SrcHumanRCD.Data.Abil.Level >= EditMinLevel.Value) and
                 (SrcHumanRCD.Data.Abil.Level <= EditMaxLevel.Value) then begin
                bo15 := False;
                Inc(L);
                if sLoadList.Count > 0 then begin//��������Ƿ�����б���
                  for J := sLoadList.Count - 1 downto 0 do begin
                    s10 := sLoadList.Strings[J];
                    if (s10 <> '') then begin
                      s10 := GetValidStr3(s10, sHumName, [' ', #9]);
                      s10 := GetValidStr3(s10, sAcount, [' ', #9]);
                      if CompareText(sAcount, SrcHumanRCD.Data.sAccount) = 0 then begin
                        bo15 := True;
                        Break;
                      end;
                    end;
                  end;
                end;
                if not bo15 then begin
                  sLoadList.Add(SrcHumanRCD.Data.sChrName+' '+SrcHumanRCD.Data.sAccount);
                end;
              end;
            end;
          end;
        end;
      end;  
    end;
    {$IFEND}
    if sLoadList.Count > 0 then sLoadList.SaveToFile(sListFileName);
  finally
    HumDataDB.Close;
    {$IF DBSMode = 0}
    HumChrDB.Close;
    {$IFEND}
    sLoadList.Free;
    Button2.Enabled:= True;
    EditUserCount.ReadOnly:= False;
    EditMinLevel.ReadOnly:= False;
    EditMaxLevel.ReadOnly:= False;
    ShowMessage('�����һ����� '+ sListFileName +' ��ɣ�����');
  end;
end;

procedure TfrmDBTool.SpeedButton1Click(Sender: TObject);
var
  path:string;
begin
  if SelectDirectory('','',Path) then begin
    if path[length(path)]<>'\' then path:=path+'\';
    Edit2.Text:= path;
  end;
end;

procedure TfrmDBTool.ButtonHumQueryClick(Sender: TObject);
begin
{$IF DBSMode = 1}
  try
    if HumChrDB.Open then begin
      if HumChrDB.Query(MemoHumQuery.Lines.Text) then begin
        Application.MessageBox('��ѯ�ɹ�������', '��ʾ��Ϣ', MB_ICONQUESTION);
      end else Application.MessageBox('��ѯʧ�ܣ��鿴���SQL�����Ƿ���ȷ����������ļ�¼�����ڣ�����', '��ʾ��Ϣ', MB_ICONQUESTION);
    end;
  finally
    HumChrDB.Close;
  end;
  {$IFEND}
end;

procedure TfrmDBTool.ButtonHumEditClick(Sender: TObject);
begin
{$IF DBSMode = 1}
  try
    if HumChrDB.Open then begin
      if HumChrDB.Edit(MemoHumEdit.Lines.Text) then begin
        Application.MessageBox('�޸ĳɹ�������', '��ʾ��Ϣ', MB_ICONQUESTION);
      end else Application.MessageBox('�޸�ʧ�ܣ��鿴���SQL�����Ƿ���ȷ���������޸ĵļ�¼�����ڣ�����', '��ʾ��Ϣ', MB_ICONQUESTION);
    end;
  finally
    HumChrDB.Close;
  end;
  {$IFEND}  
end;

end.
