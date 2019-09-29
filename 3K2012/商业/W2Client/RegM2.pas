unit RegM2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls, Clipbrd;

type
  TFrmRegM2 = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtGameListURL: TEdit;
    EdtBakGameListURL: TEdit;
    EdtPatchListURL: TEdit;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Edit7: TEdit;
    EdtDLName: TEdit;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label12: TLabel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    SpeedButton1: TSpeedButton;
    EdtUserAccount: TEdit;
    EdtUserQQ: TEdit;
    Label4: TLabel;
    Edit1: TEdit;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure EdtUserAccountKeyPress(Sender: TObject; var Key: Char);
    procedure EdtUserQQKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    bois176: Boolean;
  public
    procedure Open(is176: Boolean);
  end;

var
  FrmRegM2: TFrmRegM2;
  dwCheckRegM2AccountTick: LongWord;
  dwRegM2Tick: LongWord;
implementation

uses Main, Share, Common, StrUtils;

{$R *.dfm}

procedure TFrmRegM2.Open(is176: Boolean);
begin
  if is176 then begin
    Caption := '1.76����ע��';
  end else Caption := '��������ע��';
  bois176 := is176;
  EdtDLName.Text := g_MySelf.sAccount;
  Edit7.Text:= CurrToStr(g_MySelf.sM2Price);
  Edit1.Text:= CurrToStr(g_MySelf.sM2PriceMonth);//��ʾ���¼۸� 20110712
  EdtUserAccount.Text := '';
  EdtUserQQ.Text := '';
  EdtGameListURL.Text := '';
  EdtBakGameListURL.Text := '10.10.10.10';
  EdtPatchListURL.Text := '';
  StatusBar1.Panels[0].Text := '';
  ShowModal;
end;

procedure TFrmRegM2.SpeedButton1Click(Sender: TObject);
begin
  if Trim(EdtUserAccount.Text) = '' then begin
    Application.MessageBox('����дҪ��ѯ���û�����', '��ʾ', MB_OK + 
      MB_ICONWARNING);
    EdtUserAccount.SetFocus;
    Exit;
  end;
  if GetTickCount - dwCheckRegM2AccountTick < 5000 then begin
    Application.MessageBox('��������죬���Ժ������', 'Error', MB_OK +
      MB_ICONWARNING);
    Exit;
  end;
  FrmMain.SendCheckRegM2Account(Trim(EdtUserAccount.Text));
  dwCheckRegM2AccountTick := GetTickCount();
end;

procedure TFrmRegM2.EdtUserAccountKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in['0'..'9','a'..'z','A'..'Z',#8,#13]) then key := #0;
end;

procedure TFrmRegM2.EdtUserQQKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,#13]) then Key := #0;
end;

procedure TFrmRegM2.BitBtn3Click(Sender: TObject);
var
  Str, Str1: string;
begin
  if EdtGameListURL.Text = '' then begin
    Application.MessageBox('��˾��Ϣ����Ϊ�գ�', '����', MB_OK +
      MB_ICONSTOP);
    EdtGameListURL.SetFocus;
    Exit;
  end;
  if EdtBakGameListURL.Text = '' then begin
    Application.MessageBox('IP��ַ����Ϊ�գ�', '����', MB_OK +
      MB_ICONSTOP);
    EdtBakGameListURL.SetFocus;
    Exit;  
  end;
  if EdtPatchListURL.Text = '' then begin
    Application.MessageBox('Ӳ����Ϣ����Ϊ�գ�', '����', MB_OK +
      MB_ICONSTOP);
    EdtPatchListURL.SetFocus;
    Exit;  
  end;
  if bois176 then str1 := '1.76' else Str1 := '����';
  Str := '�𾴵��û�����ӭ����3K'+str1+'����' + #13 + #10 +
         '��ȷ��������Ϣ�Ƿ���ȷ,��ע����Ϣ���ܸ���!' + #13 + #10 +
         '' + #13 + #10 +
         '�û���½�ʺţ�' + EdtUserAccount.Text + #13 + #10 +
         '�û�QQ���룺' + EdtUserQQ.Text + #13 + #10 +
         '��˾��Ϣ��' + EdtGameListURL.Text + #13 + #10 +
         'IP��ַ��' + EdtBakGameListURL.Text + #13 + #10 +
         'Ӳ����Ϣ��' + EdtPatchListURL.Text;
  Clipbrd.Clipboard.AsText := str ;
  Application.MessageBox(PChar('������Ϣ�Ѿ����Ƴɹ�  �������£�' + #13 + #13 + #10 + Str), '��ʾ', MB_OK +
    MB_ICONINFORMATION);
end;

procedure TFrmRegM2.BitBtn1Click(Sender: TObject);
  {/////////////////////////////////////////////////////////
    ��  ��:  ���IP��ַ�Ƿ���Ч
    ��  ��:  �ַ���
    ����ֵ:  �ɹ�:  True  ʧ��: False;
    �� ע:   uses StrUtils
  ////////////////////////////////////////////////////////}
  function IsIPAddr(IP: string): Boolean;
  var
    Node: array[0..3] of Integer;
    tIP: string;
    tNode: string;
    tPos: Integer;
    tLen: Integer;
  begin
    Result := False;
    tIP := IP;
    tLen := Length(tIP);
    tPos := Pos('.', tIP);
    tNode := MidStr(tIP, 1, tPos - 1);
    tIP := MidStr(tIP, tPos + 1, tLen - tPos);
    if not TryStrToInt(tNode, Node[0]) then Exit;

    tLen := Length(tIP);
    tPos := Pos('.', tIP);
    tNode := MidStr(tIP, 1, tPos - 1);
    tIP := MidStr(tIP, tPos + 1, tLen - tPos);
    if not TryStrToInt(tNode, Node[1]) then Exit;

    tLen := Length(tIP);
    tPos := Pos('.', tIP);
    tNode := MidStr(tIP, 1, tPos - 1);
    tIP := MidStr(tIP, tPos + 1, tLen - tPos);
    if not TryStrToInt(tNode, Node[2]) then Exit;

    if not TryStrToInt(tIP, Node[3]) then Exit;
    for tLen := Low(Node) to High(Node) do begin
      if (Node[tLen] < 0) or (Node[tLen] > 255) then Exit;
    end;
    Result := True;
  end;
  function CheckAccountName(sName: string): Boolean;//����Ƿ��зǷ��ַ� 20090904
  var
    I: Integer;
    nLen: Integer;
  begin
    Result := False;
    if (sName = '') or (pos('/',sName) > 0) or (pos('\',sName) > 0) or (pos(':',sName) > 0) or (pos('?',sName) > 0) or (pos('<',sName) > 0) or (pos('>',sName) > 0) then Exit;
    Result := true;
    {nLen := length(sName);
    I := 1;
    while (true) do begin
      if I > nLen then break;
      if (sName[I] < '0') or (sName[I] > 'z') then begin
        Result := False;
        if (sName[I] >= #$B0) and (sName[I] <= #$C8) then begin //#��ʾת�����ַ� $B0-16���Ʊ���
          Inc(I);
          if I <= nLen then
            if (sName[I] >= #$A1) and (sName[I] <= #$FE) then Result := true;
        end;
        if not Result then break;
      end;
      Inc(I);
    end; }
  end;
var
  ue: TM2UserEntry;
  sUserTpye: String;
begin
  if not g_boConnect then begin
    Application.MessageBox('�ͷ������Ѿ��Ͽ�����,�����µ�½��', '����', MB_OK + MB_ICONSTOP);
    Exit;
  end;
  if RadioButton1.Checked then sUserTpye:= '[����ע��]' else sUserTpye:= '[����ע��]';

  if Application.MessageBox(PChar(sUserTpye+'�Ƿ�ȷ��ע����Ϣ��ע���������ģ�'), '��ʾ',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    if Trim(EdtUserAccount.Text) = '' then begin
      Application.MessageBox('����д�û���½�ʺţ�', 'Error', MB_OK +
        MB_ICONSTOP);
      EdtUserAccount.SetFocus;
      Exit;
    end;
    if not CheckAccountName(Trim(EdtUserAccount.Text)) then begin
      Application.MessageBox('�û���½�ʺŰ����Ƿ��ַ���', 'Error', MB_OK + MB_ICONSTOP);
      EdtUserAccount.SetFocus;
      Exit;
    end;
    if Trim(EdtUserQQ.Text) = '' then begin
      Application.MessageBox('����д�û�QQ���룡', 'Error', MB_OK + 
        MB_ICONSTOP);
      EdtUserQQ.SetFocus;
      Exit;
    end;
    if EdtGameListURL.Text = '' then begin
      Application.MessageBox('��˾��Ϣ����Ϊ�գ�', 'Error', MB_OK +
        MB_ICONSTOP);
      EdtGameListURL.SetFocus;
      Exit;
    end;
    if not CheckAccountName(Trim(EdtGameListURL.Text)) then begin
      Application.MessageBox('��˾��Ϣ�����Ƿ��ַ���', 'Error', MB_OK + MB_ICONSTOP);
      EdtGameListURL.SetFocus;
      Exit;
    end;
    if EdtBakGameListURL.Text = '' then begin
      Application.MessageBox('IP��ַ����Ϊ�գ�', 'Error', MB_OK +
        MB_ICONSTOP);
      EdtBakGameListURL.SetFocus;
      Exit;  
    end;
    if EdtPatchListURL.Text = '' then begin
      Application.MessageBox('Ӳ����Ϣ����Ϊ�գ�', 'Error', MB_OK +
        MB_ICONSTOP);
      EdtPatchListURL.SetFocus;
      Exit;
    end;
    if GetTickCount - dwRegM2Tick < 5000 then begin
      Application.MessageBox('��������죬���Ժ������', 'Error', MB_OK + 
        MB_ICONWARNING);
      Exit;
    end;
    if not IsIPAddr(Trim(EdtBakGameListURL.Text)) then begin
      Application.MessageBox('�����IP��ַ������Ч�ĵ�ַ��', 'Error', MB_OK +
        MB_ICONSTOP);
      EdtBakGameListURL.SetFocus;
      Exit;
    end;

    FillChar(ue, sizeof(TM2UserEntry), #0);
    ue.sAccount := Trim(EdtUserAccount.Text);
    ue.sUserQQ := Trim(EdtUserQQ.Text);
    ue.sGameListUrl := Trim(EdtGameListURL.Text);//��˾
    ue.sBakGameListUrl := Trim(EdtBakGameListURL.Text);//IP��ַ
    ue.sPatchListUrl := Trim(EdtPatchListURL.Text);//Ӳ����Ϣ
    if RadioButton1.Checked then ue.sUserTpye := 1 //����ע��M2���� 20110712
    else if RadioButton2.Checked then ue.sUserTpye := 2;
    FrmMain.SendAddRegM2Account(ue, bois176);
    dwRegM2Tick := GetTickCount();
    StatusBar1.Panels[0].Text := '����ע����Ϣ�����Ժ󡭡�';
  end;
end;

procedure TFrmRegM2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TFrmRegM2.FormDestroy(Sender: TObject);
begin
  FrmRegM2:= nil;
end;


end.
