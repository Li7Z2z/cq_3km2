unit U_FrmDataEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, Mask, RzEdit, RzSpnEdt, StdCtrls, ComCtrls;

type
  TFrmDataEdit = class(TForm)
    lbl12: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lbl13: TLabel;
    lbl14: TLabel;
    lbl17: TLabel;
    lbl19: TLabel;
    cbb1: TComboBox;
    edt2: TRzSpinEdit;
    cbb2: TComboBox;
    edt3: TRzSpinEdit;
    btn22: TButton;
    btn23: TButton;
    edt4: TRzSpinEdit;
    edt5: TRzSpinEdit;
    chk1: TCheckBox;
    btn24: TButton;
    edt6: TRzSpinEdit;
    edt7: TRzSpinEdit;
    chk2: TCheckBox;
    cbb5: TComboBox;
    edt10: TRzSpinEdit;
    btn21: TButton;
    btn27: TButton;
    cbb6: TComboBox;
    edt11: TRzSpinEdit;
    cbb7: TComboBox;
    edt12: TRzSpinEdit;
    btn29: TButton;
    btn30: TButton;
    cbb8: TComboBox;
    edt13: TRzSpinEdit;
    edt14: TEdit;
    edt15: TRzSpinEdit;
    edt16: TRzSpinEdit;
    btn33: TButton;
    cbb9: TComboBox;
    edt20: TRzSpinEdit;
    cbb10: TComboBox;
    edt23: TRzSpinEdit;
    cbb11: TComboBox;
    edt24: TRzSpinEdit;
    cbb12: TComboBox;
    edt25: TRzSpinEdit;
    cbb13: TComboBox;
    edt26: TRzSpinEdit;
    edt27: TRzSpinEdit;
    cbb14: TComboBox;
    btn40: TButton;
    btn25: TButton;
    cbb3: TComboBox;
    lbl16: TLabel;
    edt8: TRzSpinEdit;
    edt9: TRzSpinEdit;
    lbl18: TLabel;
    cbb4: TComboBox;
    btn26: TButton;
    btn1: TButton;
    StatusBar1: TStatusBar;
    procedure btn1Click(Sender: TObject);
    procedure btn22Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btn23Click(Sender: TObject);
    procedure btn24Click(Sender: TObject);
    procedure btn25Click(Sender: TObject);
    procedure btn26Click(Sender: TObject);
    procedure btn33Click(Sender: TObject);
    procedure btn21Click(Sender: TObject);
    procedure btn27Click(Sender: TObject);
    procedure btn29Click(Sender: TObject);
    procedure btn30Click(Sender: TObject);
    procedure btn40Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sMirDB: string;
  end;

var
  FrmDataEdit: TFrmDataEdit;

implementation
uses Mudutil, MirDB, Share, U_FrmMain;
{$R *.dfm}

procedure TFrmDataEdit.btn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmDataEdit.btn21Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);
  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻PKֵ';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb10.ItemIndex of
        0: begin//����
            if FMirInfo.Data.nPKPOINT > StrToInt(edt23.Text) then begin
              case cbb5.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nPKPOINT + StrToInt(edt10.Text) > MAXLONG then
                      FMirInfo.Data.nPKPOINT := MAXLONG
                    else FMirInfo.Data.nPKPOINT := FMirInfo.Data.nPKPOINT + StrToInt(edt10.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nPKPOINT - StrToInt(edt10.Text) < 0 then
                      FMirInfo.Data.nPKPOINT := 0
                    else FMirInfo.Data.nPKPOINT := FMirInfo.Data.nPKPOINT - StrToInt(edt10.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nPKPOINT := StrToInt(edt10.Text);
                  end;
              end; //case cbb5 end
            end; //end if
          end;
        1: begin//����
            if FMirInfo.Data.nPKPOINT = StrToInt(edt23.Text) then begin
              case cbb5.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nPKPOINT + StrToInt(edt10.Text) > MAXLONG then
                      FMirInfo.Data.nPKPOINT := MAXLONG
                    else FMirInfo.Data.nPKPOINT := FMirInfo.Data.nPKPOINT + StrToInt(edt10.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nPKPOINT - StrToInt(edt10.Text) < 0 then
                      FMirInfo.Data.nPKPOINT := 0
                    else FMirInfo.Data.nPKPOINT := FMirInfo.Data.nPKPOINT - StrToInt(edt10.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nPKPOINT := StrToInt(edt10.Text);
                  end;
              end; //case cbb5 end
            end; //end if
          end;
        2: begin//С��
            if FMirInfo.Data.nPKPOINT < StrToInt(edt23.Text) then begin
              case cbb5.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nPKPOINT + StrToInt(edt10.Text) > MAXLONG then
                      FMirInfo.Data.nPKPOINT := MAXLONG
                    else FMirInfo.Data.nPKPOINT := FMirInfo.Data.nPKPOINT + StrToInt(edt10.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nPKPOINT - StrToInt(edt10.Text) < 0 then
                      FMirInfo.Data.nPKPOINT := 0
                    else FMirInfo.Data.nPKPOINT := FMirInfo.Data.nPKPOINT - StrToInt(edt10.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nPKPOINT := StrToInt(edt10.Text);
                  end;
              end; //case cbb5 end
            end; //end if
          end;
      end;
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
  if FileExists(ExtractFilePath(sMirDB) + 'MirRepPKPOINT' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirRepPKPOINT' + FormatDateTime('yyyymmdd', now) +'.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepPKPOINT' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn22Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);
  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻����ȼ�';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb1.ItemIndex of
        0: begin//����
            if FMirInfo.Data.Abil.Level > StrToInt(edt2.Text) then begin
              case cbb2.ItemIndex of
                0: begin//�滻
                    FMirInfo.Data.Abil.Level := StrToInt(edt3.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.Abil.Level + StrToint(edt3.Text) > 65535 then
                      FMirInfo.Data.Abil.Level := 65535
                    else FMirInfo.Data.Abil.Level := FMirInfo.Data.Abil.Level + StrToint(edt3.Text);
                  end;
                2: begin//����
                    if FMirInfo.Data.Abil.Level - StrToint(edt3.Text) < 0 then
                      FMirInfo.Data.Abil.Level := 0
                    else FMirInfo.Data.Abil.Level := FMirInfo.Data.Abil.Level - StrToint(edt3.Text);
                  end;
              end; //case cbb2 end
            end; //if end
          end;
        1: begin//����
            if FMirInfo.Data.Abil.Level = StrToInt(edt2.Text) then begin
              case cbb2.ItemIndex of
                0: begin//�滻
                    FMirInfo.Data.Abil.Level := StrToInt(edt3.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.Abil.Level + StrToint(edt3.Text) > 65535 then
                      FMirInfo.Data.Abil.Level := 65535
                    else FMirInfo.Data.Abil.Level := FMirInfo.Data.Abil.Level + StrToint(edt3.Text);
                  end;
                2: begin//����
                    if FMirInfo.Data.Abil.Level - StrToint(edt3.Text) < 0 then
                      FMirInfo.Data.Abil.Level := 0
                    else FMirInfo.Data.Abil.Level := FMirInfo.Data.Abil.Level - StrToint(edt3.Text);
                  end;
              end; //case cbb2 end
            end; //if end
          end;
        2: begin//С��
            if FMirInfo.Data.Abil.Level < StrToInt(edt2.Text) then begin
              case cbb2.ItemIndex of
                0: begin//�滻
                    FMirInfo.Data.Abil.Level := StrToInt(edt3.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.Abil.Level + StrToint(edt3.Text) > 65535 then
                      FMirInfo.Data.Abil.Level := 65535
                    else FMirInfo.Data.Abil.Level := FMirInfo.Data.Abil.Level + StrToint(edt3.Text);
                  end;
                2: begin//����
                    if FMirInfo.Data.Abil.Level - StrToint(edt3.Text) < 0 then
                      FMirInfo.Data.Abil.Level := 0
                    else FMirInfo.Data.Abil.Level := FMirInfo.Data.Abil.Level - StrToint(edt3.Text);
                  end;
              end; //case cbb2 end
            end; //if end
          end;
      end; //case cbb1 end
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirReplevel' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirReplevel' + FormatDateTime('yyyymmdd', now) +'.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirReplevel' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn23Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, j, nRecordCount: Integer;
  MakeIndex: Cardinal;
  Dura: Word; //��ǰ�־�ֵ
  DuraMax: Word; //���־�ֵ
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db',fmCreate);
  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻��Ʒ';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);

      for j := 0 to High(FMirInfo.Data.HumItems) do begin
        if FMirInfo.Data.HumItems[j].wIndex - 1 = StrToInt(edt4.Text) then begin
          if chk1.Checked then
            FMirInfo.Data.HumItems[j].wIndex := StrToInt(edt5.Text) + 1
          else begin
            MakeIndex := FMirInfo.Data.HumItems[j].MakeIndex;
            Dura := FMirInfo.Data.HumItems[j].Dura;
            DuraMax := FMirInfo.Data.HumItems[j].DuraMax;
            FillChar(FMirInfo.Data.HumItems[j], Sizeof(TUserItem), #0);
            FMirInfo.Data.HumItems[j].wIndex := StrToInt(edt5.Text) + 1;
            FMirInfo.Data.HumItems[j].MakeIndex := MakeIndex;
            FMirInfo.Data.HumItems[j].Dura := Dura;
            FMirInfo.Data.HumItems[j].DuraMax := DuraMax;
          end;
        end;
      end;
      for j := 0 to High(FMirInfo.Data.BagItems) do begin
        if FMirInfo.Data.BagItems[j].wIndex - 1 = StrToInt(edt4.Text) then begin
          if chk1.Checked then
            FMirInfo.Data.BagItems[j].wIndex := StrToInt(edt5.Text) + 1
          else begin
            MakeIndex := FMirInfo.Data.BagItems[j].MakeIndex;
            Dura := FMirInfo.Data.BagItems[j].Dura;
            DuraMax := FMirInfo.Data.BagItems[j].DuraMax;
            FillChar(FMirInfo.Data.BagItems[j], Sizeof(TUserItem), #0);
            FMirInfo.Data.BagItems[j].wIndex := StrToInt(edt5.Text) + 1;
            FMirInfo.Data.BagItems[j].MakeIndex := MakeIndex;
            FMirInfo.Data.BagItems[j].Dura := Dura;
            FMirInfo.Data.BagItems[j].DuraMax := DuraMax;
          end;
        end;
      end;

      for j := 0 to High(FMirInfo.Data.StorageItems) do begin
        if FMirInfo.Data.StorageItems[j].wIndex - 1 = StrToInt(edt4.Text) then begin
          if chk1.Checked then
            FMirInfo.Data.StorageItems[j].wIndex := StrToInt(edt5.Text) + 1
          else begin
            MakeIndex := FMirInfo.Data.StorageItems[j].MakeIndex;
            Dura := FMirInfo.Data.StorageItems[j].Dura;
            DuraMax := FMirInfo.Data.StorageItems[j].DuraMax;
            FillChar(FMirInfo.Data.StorageItems[j], Sizeof(TUserItem), #0);
            FMirInfo.Data.StorageItems[j].wIndex := StrToInt(edt5.Text) + 1;
            FMirInfo.Data.StorageItems[j].MakeIndex := MakeIndex;
            FMirInfo.Data.StorageItems[j].Dura := Dura;
            FMirInfo.Data.StorageItems[j].DuraMax := DuraMax;
          end;
        end;
      end;

      for j := 0 to High(FMirInfo.Data.HumAddItems) do begin
        if FMirInfo.Data.HumAddItems[j].wIndex - 1 = StrToInt(edt4.Text) then begin
          if chk1.Checked then
            FMirInfo.Data.HumAddItems[j].wIndex := StrToInt(edt5.Text) + 1
          else  begin
            MakeIndex := FMirInfo.Data.HumAddItems[j].MakeIndex;
            Dura := FMirInfo.Data.HumAddItems[j].Dura;
            DuraMax := FMirInfo.Data.HumAddItems[j].DuraMax;
            FillChar(FMirInfo.Data.HumAddItems[j], Sizeof(TUserItem), #0);
            FMirInfo.Data.HumAddItems[j].wIndex := StrToInt(edt5.Text) + 1;
            FMirInfo.Data.HumAddItems[j].MakeIndex := MakeIndex;
            FMirInfo.Data.HumAddItems[j].Dura := Dura;
            FMirInfo.Data.HumAddItems[j].DuraMax := DuraMax;
          end;
        end;
      end;

      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepItems' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirRepItems' + FormatDateTime('yyyymmdd', now) + '.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepItems' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn24Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, j, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻����';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);

      for j := 0 to High(FMirInfo.Data.HumMagics) do begin
        if FMirInfo.Data.HumMagics[j].wMagIdx = StrToInt(edt6.Text) then begin
          if chk2.Checked then
            FMirInfo.Data.HumMagics[j].wMagIdx := StrToInt(edt7.Text)
          else begin
            FillChar(FMirInfo.Data.HumMagics[j], SizeOf(THumMagic), #0);
            FMirInfo.Data.HumMagics[j].wMagIdx := StrToInt(edt7.Text);
          end;
        end;
      end;

      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepHumMagic' + FormatDateTime('yyyymmdd', now) + '.BAK') then
     DeleteFile(ExtractFilePath(sMirDB) + 'MirRepHumMagic' + FormatDateTime('yyyymmdd', now) + '.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepHumMagic' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn25Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, j, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '����������Ʒ';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb3.ItemIndex of
        0: begin//ָ����Ʒ
            for j := 0 to High(FMirInfo.Data.HumItems) do begin
              if FMirInfo.Data.HumItems[j].wIndex - 1 = StrToInt(edt8.Text) then
                FillChar(FMirInfo.Data.HumItems[j], Sizeof(TUserItem), #0);
            end;
            for j := 0 to High(FMirInfo.Data.BagItems) do begin
              if FMirInfo.Data.BagItems[j].wIndex - 1 = StrToInt(edt8.Text) then
                FillChar(FMirInfo.Data.BagItems[j], Sizeof(TUserItem), #0);
            end;
            for j := 0 to High(FMirInfo.Data.StorageItems) do begin
              if FMirInfo.Data.StorageItems[j].wIndex - 1 = StrToInt(edt8.Text) then
                FillChar(FMirInfo.Data.StorageItems[j], Sizeof(TUserItem), #0);
            end;
            for j := 0 to High(FMirInfo.Data.HumAddItems) do begin
              if FMirInfo.Data.HumAddItems[j].wIndex - 1 = StrToInt(edt8.Text) then
                FillChar(FMirInfo.Data.HumAddItems[j], Sizeof(TUserItem), #0);
            end;
          end;
        1: begin//������Ʒ
            FillChar(FMirInfo.Data.HumItems, Sizeof(THumItems), #0);
            FillChar(FMirInfo.Data.BagItems, Sizeof(TBagItems), #0);
            FillChar(FMirInfo.Data.StorageItems, Sizeof(TStorageItems), #0);
            FillChar(FMirInfo.Data.HumAddItems, Sizeof(THumAddItems), #0);
          end;
        2: begin//������Ʒ
            FillChar(FMirInfo.Data.HumItems, Sizeof(THumItems), #0);
            FillChar(FMirInfo.Data.HumAddItems, Sizeof(THumAddItems), #0);
          end;
        3: begin//������Ʒ
            FillChar(FMirInfo.Data.BagItems, Sizeof(TBagItems), #0);
          end;
        4: begin//�ֿ���Ʒ
            FillChar(FMirInfo.Data.StorageItems, Sizeof(TStorageItems), #0);
          end;
      end;
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
  Sleep(5);
  if FileExists(ExtractFilePath(sMirDB) + 'MirClearItems' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirClearItems' + FormatDateTime('yyyymmdd', now) + '.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirClearItems' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ',MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn26Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, j, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '����������';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      if cbb4.ItemIndex = 0 then begin//ָ������
        for j := 0 to High(FMirInfo.Data.HumMagics) do begin
          if FMirInfo.Data.HumMagics[j].wMagIdx = StrToInt(edt9.Text) then
            FillChar(FMirInfo.Data.HumMagics[j], Sizeof(THumMagic), #0);
        end;
      end else begin//���м���
        FillChar(FMirInfo.Data.HumMagics, Sizeof(THumMagics), #0);
      end;

      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirClearHumMagics' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirClearHumMagics' + FormatDateTime('yyyymmdd', now) + '.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirClearHumMagics' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn27Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻����';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb11.ItemIndex of
        0: begin//����
            if FMirInfo.Data.Abil.Exp > StrToInt64(edt24.Text) then begin
              case cbb6.ItemIndex of
                0: begin//����
                    FMirInfo.Data.Abil.Exp := FMirInfo.Data.Abil.Exp + StrToInt64(edt11.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.Abil.Exp - StrToInt64(edt11.Text) < 0 then
                      FMirInfo.Data.Abil.Exp := 0
                    else FMirInfo.Data.Abil.Exp := FMirInfo.Data.Abil.Exp - StrToInt64(edt11.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.Abil.Exp := StrToInt(edt11.Text);
                  end;
              end; //case cbb6 end
            end; //end if
          end;
        1: begin//����
            if FMirInfo.Data.Abil.Exp = StrToInt64(edt24.Text) then begin
              case cbb6.ItemIndex of
                0: begin//����
                    FMirInfo.Data.Abil.Exp := FMirInfo.Data.Abil.Exp + StrToInt64(edt11.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.Abil.Exp - StrToInt64(edt11.Text) < 0 then
                      FMirInfo.Data.Abil.Exp := 0
                    else FMirInfo.Data.Abil.Exp := FMirInfo.Data.Abil.Exp - StrToInt64(edt11.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.Abil.Exp := StrToInt(edt11.Text);
                  end;
              end; //case cbb6 end
            end; //end if
          end;
        2: begin//С��
            if FMirInfo.Data.Abil.Exp < StrToInt64(edt24.Text) then begin
              case cbb6.ItemIndex of
                0: begin//����
                    FMirInfo.Data.Abil.Exp := FMirInfo.Data.Abil.Exp + StrToInt64(edt11.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.Abil.Exp - StrToInt64(edt11.Text) < 0 then
                      FMirInfo.Data.Abil.Exp := 0
                    else FMirInfo.Data.Abil.Exp := FMirInfo.Data.Abil.Exp - StrToInt64(edt11.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.Abil.Exp := StrToInt(edt11.Text);
                  end;
              end; //case cbb6 end
            end; //end if
          end;
      end;
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepExp' + FormatDateTime('yyyymmdd', now) + '.BAK') then
     DeleteFile(ExtractFilePath(sMirDB) + 'MirRepExp' + FormatDateTime('yyyymmdd', now) +'.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepExp' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn29Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻���Ե�';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb12.ItemIndex of
        0: begin//����
            if FMirInfo.Data.nBonusPoint > StrToInt(edt25.Text) then begin
              case cbb7.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nBonusPoint + StrToInt(edt12.Text) > MAXLONG then
                      FMirInfo.Data.nBonusPoint := MAXLONG
                    else FMirInfo.Data.nBonusPoint := FMirInfo.Data.nBonusPoint + StrToInt(edt12.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nBonusPoint - StrToInt(edt12.Text) < 0 then
                      FMirInfo.Data.nBonusPoint := 0
                    else FMirInfo.Data.nBonusPoint := FMirInfo.Data.nBonusPoint - StrToInt(edt12.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nBonusPoint := StrToInt(edt12.Text);
                  end;
              end; //case cbb7 end
            end; // end if
          end;
        1: begin//����
            if FMirInfo.Data.nBonusPoint = StrToInt(edt25.Text) then begin
              case cbb7.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nBonusPoint + StrToInt(edt12.Text) > MAXLONG then
                      FMirInfo.Data.nBonusPoint := MAXLONG
                    else FMirInfo.Data.nBonusPoint := FMirInfo.Data.nBonusPoint + StrToInt(edt12.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nBonusPoint - StrToInt(edt12.Text) < 0 then
                      FMirInfo.Data.nBonusPoint := 0
                    else FMirInfo.Data.nBonusPoint := FMirInfo.Data.nBonusPoint - StrToInt(edt12.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nBonusPoint := StrToInt(edt12.Text);
                  end;
              end; //case cbb7 end
            end; // end if
          end;
        2: begin//С��
            if FMirInfo.Data.nBonusPoint < StrToInt(edt25.Text) then begin
              case cbb7.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nBonusPoint + StrToInt(edt12.Text) > MAXLONG then
                      FMirInfo.Data.nBonusPoint := MAXLONG
                    else FMirInfo.Data.nBonusPoint := FMirInfo.Data.nBonusPoint + StrToInt(edt12.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nBonusPoint - StrToInt(edt12.Text) < 0 then
                      FMirInfo.Data.nBonusPoint := 0
                    else FMirInfo.Data.nBonusPoint := FMirInfo.Data.nBonusPoint - StrToInt(edt12.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nBonusPoint := StrToInt(edt12.Text);
                  end;
              end; //case cbb7 end
            end; // end if
          end;
      end;
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepBonusPoint' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirRepBonusPoint' + FormatDateTime('yyyymmdd', now) + '.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepBonusPoint' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn30Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻��Ǯ';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb13.ItemIndex of
        0: begin//����
            if FMirInfo.Data.nGold > StrToInt(edt26.Text) then begin
              case cbb8.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nGold + StrToInt(edt13.Text) > MAXLONG then
                      FMirInfo.Data.nGold := MAXLONG
                    else FMirInfo.Data.nGold := FMirInfo.Data.nGold + StrToInt(edt13.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nGold - StrToInt(edt13.Text) < 0 then
                      FMirInfo.Data.nGold := 0
                    else FMirInfo.Data.nGold := FMirInfo.Data.nGold - StrToInt(edt13.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nGold := StrToInt(edt13.Text);
                  end;
              end; //case cbb8 end
            end; //end if
          end;
        1: begin//����
            if FMirInfo.Data.nGold = StrToInt(edt26.Text) then begin
              case cbb8.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nGold + StrToInt(edt13.Text) > MAXLONG then
                      FMirInfo.Data.nGold := MAXLONG
                    else FMirInfo.Data.nGold := FMirInfo.Data.nGold + StrToInt(edt13.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nGold - StrToInt(edt13.Text) < 0 then
                      FMirInfo.Data.nGold := 0
                    else FMirInfo.Data.nGold := FMirInfo.Data.nGold - StrToInt(edt13.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nGold := StrToInt(edt13.Text);
                  end;
              end; //case cbb8 end
            end; //end if
          end;
        2: begin//С��
            if FMirInfo.Data.nGold < StrToInt(edt26.Text) then begin
              case cbb8.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nGold + StrToInt(edt13.Text) > MAXLONG then
                      FMirInfo.Data.nGold := MAXLONG
                    else FMirInfo.Data.nGold := FMirInfo.Data.nGold + StrToInt(edt13.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nGold - StrToInt(edt13.Text) < 0 then
                      FMirInfo.Data.nGold := 0
                    else FMirInfo.Data.nGold := FMirInfo.Data.nGold - StrToInt(edt13.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nGold := StrToInt(edt13.Text);
                  end;
              end; //case cbb8 end
            end; //end if
          end;
      end;
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepGold' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirRepGold' + FormatDateTime('yyyymmdd', now) + '.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepGold' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn33Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻��ǰ��ͼ';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      FMirInfo.Data.sCurMap := edt14.Text;
      FMirInfo.Data.wCurX := StrToInt(edt15.Text);
      FMirInfo.Data.wCurY := StrToInt(edt16.Text);
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepMapName' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirRepMapName' + FormatDateTime('yyyymmdd', now) +'.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepMapName' + FormatDateTime('yyyymmdd', now) + '.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!', '��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.btn40Click(Sender: TObject);
var
  DBHeader: TDBHeader;
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  I, nRecordCount: Integer;
begin
  if FileExists(sMirDB) then
    FDBRecord := TMirRecord.Create(sMirDB, fmShareDenyNone)
  else FDBRecord := TMirRecord.Create(sMirDB, fmCreate);

  if FileExists(ExtractFilePath(sMirDB) + 'NewMir.db') then DeleteFile(ExtractFilePath(sMirDB) + 'NewMir.db');
  //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(ExtractFilePath(sMirDB) + 'NewMir.db', fmCreate);

  try
    FDBRecord.RecSize := SizeOf(FMirInfo);
    FDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize:=SizeOf(TDBHeader);
    FDBRecord.Seek(0, 0);
    FNewDBRecord.Seek(0, 0);
    FDBRecord.Read(DBHeader, SizeOf(DBHeader));
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    FDBRecord.First;
    nRecordCount := FDBRecord.NumRecs;
    StatusBar1.Panels[0].Text := '�����滻Ԫ��';
    for I := 1 to nRecordCount do begin
      FDBRecord.ReadRec(FMirInfo);
      case cbb14.ItemIndex of
        0: begin//����
            if FMirInfo.Data.nGameGold > StrToInt(edt27.Text) then begin
              case cbb9.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nGameGold + StrToInt(edt20.Text) > MAXLONG then
                      FMirInfo.Data.nGameGold := MAXLONG
                    else FMirInfo.Data.nGameGold := FMirInfo.Data.nGameGold + StrToInt(edt20.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nGameGold - StrToInt(edt20.Text) < 0 then
                      FMirInfo.Data.nGameGold := 0
                    else FMirInfo.Data.nGameGold := FMirInfo.Data.nGameGold - StrToInt(edt20.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nGameGold := StrToInt(edt20.Text);
                  end;
              end; //case cbb9 end
            end; //end if
          end;
        1: begin//����
            if FMirInfo.Data.nGameGold = StrToInt(edt27.Text) then begin
              case cbb9.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nGameGold + StrToInt(edt20.Text) > MAXLONG then
                      FMirInfo.Data.nGameGold := MAXLONG
                    else FMirInfo.Data.nGameGold := FMirInfo.Data.nGameGold + StrToInt(edt20.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nGameGold - StrToInt(edt20.Text) < 0 then
                      FMirInfo.Data.nGameGold := 0
                    else FMirInfo.Data.nGameGold := FMirInfo.Data.nGameGold - StrToInt(edt20.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nGameGold := StrToInt(edt20.Text);
                  end;
              end; //case cbb9 end
            end; //end if
          end;
        2: begin//С��
            if FMirInfo.Data.nGameGold < StrToInt(edt27.Text) then begin
              case cbb9.ItemIndex of
                0: begin//����
                    if FMirInfo.Data.nGameGold + StrToInt(edt20.Text) > MAXLONG then
                      FMirInfo.Data.nGameGold := MAXLONG
                    else FMirInfo.Data.nGameGold := FMirInfo.Data.nGameGold + StrToInt(edt20.Text);
                  end;
                1: begin//����
                    if FMirInfo.Data.nGameGold - StrToInt(edt20.Text) < 0 then
                      FMirInfo.Data.nGameGold := 0
                    else FMirInfo.Data.nGameGold := FMirInfo.Data.nGameGold - StrToInt(edt20.Text);
                  end;
                2: begin//����
                    FMirInfo.Data.nGameGold := StrToInt(edt20.Text);
                  end;
              end; //case cbb9 end
            end; //end if
          end;
      end;
      FNewDBRecord.AppendRec(FMirInfo);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i /nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
      FDBRecord.NextRec;
    end;
  finally
    FDBRecord.Free;
    FNewDBRecord.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';

  if FileExists(ExtractFilePath(sMirDB) + 'MirRepGameGold' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    DeleteFile(ExtractFilePath(sMirDB) + 'MirRepGameGold' +FormatDateTime('yyyymmdd', now) +'.BAK');
  //����ļ���������ɾ��

  Application.ProcessMessages;

  if not RenameFile(sMirDB, ExtractFilePath(sMirDB) + 'MirRepGameGold' + FormatDateTime('yyyymmdd', now) +'.BAK') then
    Application.MessageBox('���޸�Mir.db�ļ���ʱʧ�ܣ�������' + #13 +
                           '�ļ�ΪNewMir.db���ֶ��޸��ļ���!', '��ʾ��Ϣ', MB_ICONQUESTION)
  else if not RenameFile(ExtractFilePath(sMirDB) + 'NewMir.db', sMirDB) then
    Application.MessageBox('�ڶ�NewMir.db�޸��ļ���ʱʧ�ܣ����ֶ��޸��ļ���ΪMir.db!','��ʾ��Ϣ', MB_ICONQUESTION);
end;

procedure TFrmDataEdit.FormActivate(Sender: TObject);
begin
  sMirDB := FrmMain.EdtSlaveMir.Text;
end;

end.

