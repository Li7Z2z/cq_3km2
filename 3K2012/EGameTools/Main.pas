unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Login,   ComCtrls,Printers,
  Grids, DBGrids, StdCtrls,  ExtCtrls, DBCtrls,
  bsSkinData, BusinessSkinForm, bsSkinTabs, bsSkinGrids, bsDBGrids,
  bsSkinCtrls, bsSkinBoxCtrls, bsdbctrls, Mask, DBTables, DB, bsMessages,DM,Inifiles,
  RzLabel, DBGridEh, Buttons, bsSkinShellCtrls, Menus, bsSkinMenus,
  RzPrgres, RzEdit, PrnDbgeh,  bsColorCtrls, FFPBox,mywil, bsDialogs,ADODB,
  GridsEh;

type
  TFrmMain = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinData1: TbsSkinData;
    bsCompressedStoredSkin1: TbsCompressedStoredSkin;
    bsSkinMessage1: TbsSkinMessage;
    OpenDialog1: TbsSkinOpenDialog;
    SaveDialog1: TbsSkinSaveDialog;
    bsSkinPopupMenu3: TbsSkinPopupMenu;
    N5: TMenuItem;
    PrintDBGridEh1: TPrintDBGridEh;
    bsSkinPanel17: TbsSkinPanel;
    bsSkinStdLabel7: TbsSkinStdLabel;
    LabelProductName: TbsSkinStdLabel;
    bsSkinLinkLabel1: TbsSkinLinkLabel;
    bsSkinButtonLabel1: TbsSkinButtonLabel;
    bsSkinStdLabel17: TbsSkinStdLabel;
    LabelVersion: TbsSkinStdLabel;
    bsSkinPageControl1: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinPageControl2: TbsSkinPageControl;
    bsSkinTabSheet4: TbsSkinTabSheet;
    bsSkinSplitter1: TbsSkinSplitter;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    BtnMagicBaseBak: TbsSkinButton;
    BtnMagicBaseRestore: TbsSkinButton;
    bsSkinCheckRadioBox1: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox2: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox3: TbsSkinCheckRadioBox;
    EditMagName: TbsSkinEdit;
    bsSkinSpinEdit1: TbsSkinSpinEdit;
    BtnFindMagName: TbsSkinButton;
    BtnAlterMagicExp: TbsSkinButton;
    bsSkinButton12: TbsSkinButton;
    bsSkinButton15: TbsSkinButton;
    bsSkinDBNavigator1: TbsSkinDBNavigator;
    bsSkinExPanel1: TbsSkinExPanel;
    bsSkinMemo1: TbsSkinMemo;
    bsSkinPanel2: TbsSkinPanel;
    MagicDBGrid: TDBGridEh;
    bsSkinTabSheet5: TbsSkinTabSheet;
    bsSkinSplitter2: TbsSkinSplitter;
    bsSkinPanel3: TbsSkinPanel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    BtnMobBaseBak: TbsSkinButton;
    BtnMobBaseRestore: TbsSkinButton;
    EditMobName: TbsSkinEdit;
    BtnFindMonName: TbsSkinButton;
    bsSkinButton11: TbsSkinButton;
    bsSkinButton14: TbsSkinButton;
    bsSkinDBNavigator2: TbsSkinDBNavigator;
    bsSkinExPanel2: TbsSkinExPanel;
    bsSkinMemo2: TbsSkinMemo;
    bsSkinPanel4: TbsSkinPanel;
    MobDBGrid: TDBGridEh;
    bsSkinTabSheet6: TbsSkinTabSheet;
    bsSkinSplitter3: TbsSkinSplitter;
    bsSkinPanel5: TbsSkinPanel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    BtnItemsBaseBak: TbsSkinButton;
    BtnItemsBaseRestore: TbsSkinButton;
    BtnFindItemName: TbsSkinButton;
    EditItemsName: TbsSkinEdit;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel4: TbsSkinStdLabel;
    ComboBoxFilterItemsMode: TbsSkinComboBox;
    bsSkinButton7: TbsSkinButton;
    bsSkinButton13: TbsSkinButton;
    bsSkinDBNavigator3: TbsSkinDBNavigator;
    bsSkinExPanel3: TbsSkinExPanel;
    bsSkinSplitter4: TbsSkinSplitter;
    MemoItemsHint: TbsSkinMemo;
    ListBoxItemsHint: TbsSkinListBox;
    bsSkinScrollBar4: TbsSkinScrollBar;
    bsSkinPanel6: TbsSkinPanel;
    bsSkinScrollBar5: TbsSkinScrollBar;
    ItemsDBGrid: TDBGridEh;
    bsSkinTabSheet2: TbsSkinTabSheet;
    bsSkinGroupBox2: TbsSkinGroupBox;
    RzLabel1: TRzLabel;
    bsSkinPanel7: TbsSkinPanel;
    TrackEditColor1: TbsSkinTrackEdit;
    TrackEditColor2: TbsSkinTrackEdit;
    bsSkinTabSheet3: TbsSkinTabSheet;
    bsSkinPanel8: TbsSkinPanel;
    bsSkinSplitter5: TbsSkinSplitter;
    bsSkinPanel9: TbsSkinPanel;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinGroupBox4: TbsSkinGroupBox;
    checkboxTransparent: TbsSkinCheckRadioBox;
    CheckBoxjump: TbsSkinCheckRadioBox;
    CheckBoxzuobiao: TbsSkinCheckRadioBox;
    checkboxXY: TbsSkinCheckRadioBox;
    Rb50: TbsSkinCheckRadioBox;
    rb100: TbsSkinCheckRadioBox;
    rb200: TbsSkinCheckRadioBox;
    rb400: TbsSkinCheckRadioBox;
    rb800: TbsSkinCheckRadioBox;
    rbauto: TbsSkinCheckRadioBox;
    btnx: TbsSkinButton;
    btny: TbsSkinButton;
    bsSkinPanel10: TbsSkinPanel;
    bsSkinStdLabel6: TbsSkinStdLabel;
    Label3: TbsSkinStdLabel;
    Label2: TbsSkinStdLabel;
    Label7: TbsSkinStdLabel;
    btnup: TbsSkinButton;
    btndelete: TbsSkinButton;
    BtnAutoPlay: TbsSkinButton;
    btninput: TbsSkinButton;
    btnAdd: TbsSkinButton;
    btnallinput: TbsSkinButton;
    btndown: TbsSkinButton;
    BtnJump: TbsSkinButton;
    btnstop: TbsSkinButton;
    BtnOut: TbsSkinButton;
    btnCreate: TbsSkinButton;
    btnallOut: TbsSkinButton;
    bsSkinPanel11: TbsSkinPanel;
    bsSkinPanel12: TbsSkinPanel;
    bsSkinSplitter6: TbsSkinSplitter;
    DrawGrid1: TDrawGrid;
    Image1: TImage;
    ScrollBox1: TScrollBox;
    PaintBox1: TFlickerFreePaintBox;
    SavePictureDialog1: TbsSkinSavePictureDialog;
    OpenPictureDialog1: TbsSkinOpenPictureDialog;
    Labeltype: TbsSkinStdLabel;
    LabelSize: TbsSkinStdLabel;
    LabelIndex: TbsSkinStdLabel;
    LabelX: TbsSkinStdLabel;
    LabelY: TbsSkinStdLabel;
    InputDialog: TbsSkinInputDialog;
    Timer1: TTimer;
    EditFileName: TbsSkinFileEdit;
    bsSkinGroupBox5: TbsSkinGroupBox;
    bsSkinCheckRadioBox4: TbsSkinCheckRadioBox;
    bsSkinFileEdit1: TbsSkinFileEdit;
    bsSkinStdLabel8: TbsSkinStdLabel;
    bsSkinSelectDirectoryDialog1: TbsSkinSelectDirectoryDialog;
    bsSkinButton1: TbsSkinButton;
    LabelColorCount: TbsSkinStdLabel;
    bsSkinGroupBox6: TbsSkinGroupBox;
    bsSkinStdLabel9: TbsSkinStdLabel;
    bsSkinFileEdit2: TbsSkinFileEdit;
    bsSkinButton2: TbsSkinButton;
    bsSkinButton3: TbsSkinButton;
    bsSkinButton4: TbsSkinButton;
    bsSkinButton5: TbsSkinButton;
    bsSkinGroupBox7: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinFileEdit3: TbsSkinFileEdit;
    bsSkinButton6: TbsSkinButton;
    bsSkinTabSheet7: TbsSkinTabSheet;
    bsSkinPanel13: TbsSkinPanel;
    bsSkinStdLabel11: TbsSkinStdLabel;
    BtnFongHaoBaseBak: TbsSkinButton;
    BtnFongHaoRestore: TbsSkinButton;
    bsSkinButton10: TbsSkinButton;
    bsSkinEdit1: TbsSkinEdit;
    bsSkinGroupBox8: TbsSkinGroupBox;
    bsSkinStdLabel12: TbsSkinStdLabel;
    ComboBoxFilterFongHaoMode: TbsSkinComboBox;
    bsSkinButton16: TbsSkinButton;
    bsSkinButton17: TbsSkinButton;
    bsSkinButton18: TbsSkinButton;
    bsSkinDBNavigator4: TbsSkinDBNavigator;
    bsSkinExPanel4: TbsSkinExPanel;
    bsSkinSplitter7: TbsSkinSplitter;
    MemoFongHaoHint: TbsSkinMemo;
    ListBoxFongHaoHint: TbsSkinListBox;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinSplitter8: TbsSkinSplitter;
    FongHaoDBGrid: TDBGridEh;
    procedure BtnFindMagNameClick(Sender: TObject);
    procedure BtnFindMonNameClick(Sender: TObject);
    procedure BtnFindItemNameClick(Sender: TObject);
    procedure ComboBoxFilterItemsModeChange(Sender: TObject);
    procedure TrackEditColor1Change(Sender: TObject);
    procedure TrackEditColor2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bsSkinButton7Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure bsSkinButton12Click(Sender: TObject);
    procedure bsSkinButton11Click(Sender: TObject);
    procedure bsSkinButton15Click(Sender: TObject);
    procedure bsSkinButton14Click(Sender: TObject);
    procedure bsSkinButton13Click(Sender: TObject);
    procedure BtnMagicBaseBakClick(Sender: TObject);
    procedure BtnMagicBaseRestoreClick(Sender: TObject);
    procedure bsSkinButtonLabel1Click(Sender: TObject);
    procedure BtnAlterMagicExpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    Function Extractrec(Restype,ResName,ResNewNAme:string):boolean;
    procedure FillInfo(index:Integer);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnupClick(Sender: TObject);
    procedure btndownClick(Sender: TObject);
    procedure btnxClick(Sender: TObject);
    procedure btnyClick(Sender: TObject);
    procedure Rb50Click(Sender: TObject);
    procedure BtnJumpClick(Sender: TObject);
    procedure BtnAutoPlayClick(Sender: TObject);
    procedure btnstopClick(Sender: TObject);
    procedure btninputClick(Sender: TObject);
    procedure BtnOutClick(Sender: TObject);
    procedure btndeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnallinputClick(Sender: TObject);
    procedure btnallOutClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure EditFileNameButtonClick(Sender: TObject);
    procedure bsSkinFileEdit1ButtonClick(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinCheckRadioBox4Click(Sender: TObject);
    procedure bsSkinTabSheet2Show(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure bsSkinFileEdit2ButtonClick(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure bsSkinButton5Click(Sender: TObject);
    procedure bsSkinButton6Click(Sender: TObject);
    procedure bsSkinFileEdit3ButtonClick(Sender: TObject);
    procedure bsSkinButton16Click(Sender: TObject);
    procedure bsSkinButton18Click(Sender: TObject);
    procedure bsSkinButton17Click(Sender: TObject);
    procedure bsSkinButton10Click(Sender: TObject);
    procedure ComboBoxFilterFongHaoModeChange(Sender: TObject);
    procedure bsSkinTabSheet7Show(Sender: TObject);
  private
    Function ExportTxt(DBGridEh:TDBGrideh;Var TextName:string):BooLean;//����TXT
    Function ExportTxt1(DBGridEh:TDBGrideh;Var TextName:string):BooLean;
    procedure BeforePrint();
  public
    procedure LoadConfig(); //��������
    procedure Open();
  end;

var
  FrmMain: TFrmMain;
  boDelDenyChr: Boolean;
  boSellOffItem: Boolean;
  boBigStorage: Boolean;
  Wil:TWil;
  Bmpx,bmpy: Integer;
  BmpIndex,BmpWidth,BmpHeight: Integer;
  BmpZoom: Real;
  BmpTran: Boolean;
  MainBitMap:TBitMap;
  Stop:Boolean;
  boIsSort: Boolean;//��Ʒ���ݿ��Ƿ�����
implementation

uses EGameToolsShare,EDcodeUnit,AboutUnit, DelWil, AddOneWil, NewWil, AddWil,
  OutWil;

{$R *.dfm}

procedure TFrmMain.LoadConfig; //��������
var
  MyIni: TIniFile;
begin
  MyIni := TIniFile.Create(ConfigFileName);
  DBEName := MyIni.ReadString('SYSTEM','DBEName',DBEName);
  sGameDirectory := MyIni.ReadString('SYSTEM','ServerDir',sGameDirectory);
  sWilDirectory:= MyIni.ReadString('SYSTEM','WilDirectory',sWilDirectory);
  MyIni.Free;
end;

procedure TFrmMain.Open;
begin
  FrmDM.TableMagic.DatabaseName := DBEName;
  FrmDM.TableMagic.Active := True;
       MagicDBGrid.Columns[0].Title.Caption := '���';
       MagicDBGrid.Columns[1].Title.Caption := '����';
       MagicDBGrid.Columns[2].Title.Caption := '����Ч��';
       MagicDBGrid.Columns[3].Title.Caption := 'ħ��Ч��';
       MagicDBGrid.Columns[4].Title.Caption := 'ħ������';
       MagicDBGrid.Columns[5].Title.Caption := '��������';
       MagicDBGrid.Columns[6].Title.Caption := '�������';
       MagicDBGrid.Columns[7].Title.Caption := '����ħ��';
       MagicDBGrid.Columns[8].Title.Caption := '��������';
       MagicDBGrid.Columns[9].Title.Caption := '�����������';
       MagicDBGrid.Columns[10].Title.Caption := 'ְҵ';
       MagicDBGrid.Columns[11].Title.Caption := '1���ȼ�';
       MagicDBGrid.Columns[12].Title.Caption := '1������';
       MagicDBGrid.Columns[13].Title.Caption := '2���ȼ�';
       MagicDBGrid.Columns[14].Title.Caption := '2������';
       MagicDBGrid.Columns[15].Title.Caption := '3���ȼ�';
       MagicDBGrid.Columns[16].Title.Caption := '3������';
       MagicDBGrid.Columns[17].Title.Caption := '������ʱ';
       MagicDBGrid.Columns[18].Title.Caption := '��ע˵��';
  FrmDM.TableMonster.DatabaseName := DBEName;
  FrmDM.TableMonster.Active := True;
       MobDBGrid.Columns[0].Title.Caption := '����';
       MobDBGrid.Columns[1].Title.Caption := '����';
       MobDBGrid.Columns[2].Title.Caption := '����ͼ��';
       MobDBGrid.Columns[3].Title.Caption := '�������';
       MobDBGrid.Columns[4].Title.Caption := '�ȼ�';
       MobDBGrid.Columns[5].Title.Caption := '����ϵ';
       MobDBGrid.Columns[6].Title.Caption := '�Ӿ���Χ';
       MobDBGrid.Columns[7].Title.Caption := '����ֵ';
       MobDBGrid.Columns[8].Title.Caption := '����ֵ';
       MobDBGrid.Columns[9].Title.Caption := 'ħ��ֵ';
       MobDBGrid.Columns[10].Title.Caption := '������';
       MobDBGrid.Columns[11].Title.Caption := 'ħ����';
       MobDBGrid.Columns[12].Title.Caption := '������';
       MobDBGrid.Columns[13].Title.Caption := '��󹥻���';
       MobDBGrid.Columns[14].Title.Caption := 'ħ����';
       MobDBGrid.Columns[15].Title.Caption := '������';
       MobDBGrid.Columns[16].Title.Caption := '����';
       MobDBGrid.Columns[17].Title.Caption := '������';
       MobDBGrid.Columns[18].Title.Caption := '�����ٶ�';
       MobDBGrid.Columns[19].Title.Caption := '���߲���';
       MobDBGrid.Columns[20].Title.Caption := '���ߵȴ�';
       MobDBGrid.Columns[21].Title.Caption := '�����ٶ�';
  FrmDM.TableStdItems.DatabaseName := DBEName;
  FrmDM.TableStdItems.Active := True;
       ItemsDBGrid.Columns[0].Title.Caption := '���';
       ItemsDBGrid.Columns[1].Title.Caption := '����';
       ItemsDBGrid.Columns[2].Title.Caption := '�����';
       ItemsDBGrid.Columns[3].Title.Caption := 'װ�����';
       ItemsDBGrid.Columns[4].Title.Caption := '����';
       ItemsDBGrid.Columns[5].Title.Caption := 'Anicount';
       ItemsDBGrid.Columns[6].Title.Caption := 'Դ����';
       ItemsDBGrid.Columns[7].Title.Caption := '����';
       ItemsDBGrid.Columns[8].Title.Caption := '��Ʒ���';
       ItemsDBGrid.Columns[9].Title.Caption := '�־���';
       ItemsDBGrid.Columns[10].Title.Caption := 'HP���޼���';
       ItemsDBGrid.Columns[11].Title.Caption := '��������';
       ItemsDBGrid.Columns[12].Title.Caption := 'MP���޼���';
       ItemsDBGrid.Columns[13].Title.Caption := '������ʱ';
       ItemsDBGrid.Columns[14].Title.Caption := '��͹�����';
       ItemsDBGrid.Columns[15].Title.Caption := '��߹�����';
       ItemsDBGrid.Columns[16].Title.Caption := '���ħ����';
       ItemsDBGrid.Columns[17].Title.Caption := '���ħ����';
       ItemsDBGrid.Columns[18].Title.Caption := '��͵�����';
       ItemsDBGrid.Columns[19].Title.Caption := '��ߵ�����';
       ItemsDBGrid.Columns[20].Title.Caption := '��������';
       ItemsDBGrid.Columns[21].Title.Caption := '��Ҫ�ȼ�';
       ItemsDBGrid.Columns[22].Title.Caption := '�ۼ�';
       ItemsDBGrid.Columns[23].Title.Caption := '�����';

  FrmDM.TableFongHao.DatabaseName := DBEName;
  FrmDM.TableFongHao.Active := True;
end;
//���Ҽ�����
procedure TFrmMain.BtnFindMagNameClick(Sender: TObject);
begin
  if EditMagName.Text = '' then Exit;
  with FrmDM.TableMagic do begin
    if not Eof then begin
      EditKey;
      DisableControls;
      while not Eof do begin
        if pos(Trim(EditMagName.Text), FieldByName('MagName').AsString)   <=   0   then Next
        else Break;
      end;
      EnableControls;
    end;
  end;
end;
//���ҹ���
procedure TFrmMain.BtnFindMonNameClick(Sender: TObject);
begin
  if EditMobName.Text = '' then Exit;
  with FrmDM.TableMonster do begin
    if not Eof then begin
      EditKey;
      DisableControls;
      while not Eof do begin
        if pos(Trim(EditMobName.Text), FieldByName('Name').AsString)   <=   0   then Next
        else Break;
      end;
      EnableControls;
    end;
  end;
end;
//������Ʒ��
procedure TFrmMain.BtnFindItemNameClick(Sender: TObject);
begin
  if EditItemsName.Text = '' then Exit;
  with FrmDM.TableStdItems do begin
    if not Eof then begin
      EditKey;
      DisableControls;
      while not Eof do begin
        if pos(Trim(EditItemsName.Text), FieldByName('Name').AsString)   <=   0   then Next
        else Break;
      end;
      EnableControls;
    end;
  end;
end;
//������Ʒ
procedure TFrmMain.ComboBoxFilterFongHaoModeChange(Sender: TObject);
  function FilterItems(Num: string):Boolean;
  begin
    Result := False;
    FrmDM.TableFongHao.Close;
    FrmDM.TableFongHao.Filter := 'Stdmode = '+Num;
    FrmDM.TableFongHao.Filtered := True;
    FrmDM.TableFongHao.Open;
    Result := True;
  end;
  function NoFilterItems():Boolean;
  begin
    Result := False;
    FrmDM.TableFongHao.Close;
    FrmDM.TableFongHao.Filter := '';
    FrmDM.TableFongHao.Filtered := False;
    FrmDM.TableFongHao.Open;
    Result := True;
  end;
begin
  case ComboBoxFilterFongHaoMode.ItemIndex of
    0: begin
        if NoFilterItems() then begin
          ListBoxFongHaoHint.Clear;
          MemoFongHaoHint.Clear;
          ListBoxFongHaoHint.Items.Add('0=һ��ƺ�');
          ListBoxFongHaoHint.Items.Add('1=ˮ��֮��(���ǧ�ﴫ��)');
          ListBoxFongHaoHint.Items.Add('2=��������');
          ListBoxFongHaoHint.Items.Add('3=����ʹ��');
          ListBoxFongHaoHint.Items.Add('4=������ɽ(��ײ����+10��)');
          ListBoxFongHaoHint.Items.Add('5=�۷���ʿ(�����������,����3�λ�0��ʱ״̬��ʧ');
          ListBoxFongHaoHint.Items.Add('           ʱ��������Ч DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('6=��Ѫʹ��(���(Ϊ�ӳ�),ͬ��ͼʱ���ж�Ա��־��鷭��)');
          ListBoxFongHaoHint.Items.Add('7=����֮��(ħ����,�һ𽣷�,��ʥս����,����ܱ�ɷۺ�ɫ)');
          ListBoxFongHaoHint.Items.Add('8=�л�֮��(�˳��л�ƺ���ʧ)');
          ListBoxFongHaoHint.Items.Add('9=�귨������(���⴫�͵�ͼ)');
          ListBoxFongHaoHint.Items.Add('10=�߼��۷���ʿ(�����������,����������������');
          ListBoxFongHaoHint.Items.Add('                DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('11=0����ʧ�ƺ�(ʱ��������Ч)');
        end;
    end;
    1: begin
        if FilterItems('0') then begin
          ListBoxFongHaoHint.Clear;
          ListBoxFongHaoHint.Items.Add('0=һ��ƺ�');
          ListBoxFongHaoHint.Items.Add('1=ˮ��֮��(���ǧ�ﴫ��)');
          ListBoxFongHaoHint.Items.Add('2=��������');
          ListBoxFongHaoHint.Items.Add('3=����ʹ��');
          ListBoxFongHaoHint.Items.Add('4=������ɽ(��ײ����+10��)');
          ListBoxFongHaoHint.Items.Add('5=�۷���ʿ(�����������,����3�λ�0��ʱ״̬��ʧ');
          ListBoxFongHaoHint.Items.Add('           ʱ��������Ч DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('6=��Ѫʹ��(���(Ϊ�ӳ�),ͬ��ͼʱ���ж�Ա��־��鷭��)');
          ListBoxFongHaoHint.Items.Add('7=����֮��(ħ����,�һ𽣷�,��ʥս����,����ܱ�ɷۺ�ɫ)');
          ListBoxFongHaoHint.Items.Add('8=�л�֮��(�˳��л�ƺ���ʧ)');
          ListBoxFongHaoHint.Items.Add('9=�귨������(���⴫�͵�ͼ)');
          ListBoxFongHaoHint.Items.Add('10=�߼��۷���ʿ(�����������,����������������');
          ListBoxFongHaoHint.Items.Add('                DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('11=0����ʧ�ƺ�(ʱ��������Ч)');
          MemoFongHaoHint.Clear;
          MemoFongHaoHint.Lines.Text := 'Shape  =Ԥ��'+#13+
                                        'Anicount=�ƺ�����Ч��'+#13+
                                        'nHours =�ƺ�ʱ��(Сʱ) 65535-����'+#13+
                                        'Looks  =�ƺŵ��ڹ�'+#13+
                                        'AC     =��������'+#13+
                                        'AC2    =ǿ��ȼ�'+#13+
                                        'MAC    =���˵ȼ�'+#13+
                                        'MAC2   =�����ȼ�'+#13+
                                        'DC     =��Կ���'+#13+
                                        'DC2    =��������'+#13+
                                        'MC     =��ħ�ȼ�'+#13+
                                        'MC2    =ħ������'+#13+
                                        'SC     =�ϻ�����'+#13+
                                        'SC2    =��������'+#13+#13+
                                        'Need(��������)'+#13+
                                        '0:��ȼ�   NeedLevel=�ȼ�'+#13+
                                        '1:�蹥���� NeedLevel=������'+#13+
                                        '2:��ħ��   NeedLevel=ħ��'+#13+
                                        '3:�����   NeedLevel=����';
        end;
    end;
    2: begin
        if FilterItems('1') then begin
          ListBoxFongHaoHint.Clear;
          ListBoxFongHaoHint.Items.Add('0=һ��ƺ�');
          ListBoxFongHaoHint.Items.Add('1=ˮ��֮��(���ǧ�ﴫ��)');
          ListBoxFongHaoHint.Items.Add('2=��������');
          ListBoxFongHaoHint.Items.Add('3=����ʹ��');
          ListBoxFongHaoHint.Items.Add('4=������ɽ(��ײ����+10��)');
          ListBoxFongHaoHint.Items.Add('5=�۷���ʿ(�����������,����3�λ�0��ʱ״̬��ʧ');
          ListBoxFongHaoHint.Items.Add('           ʱ��������Ч DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('6=��Ѫʹ��(���(Ϊ�ӳ�),ͬ��ͼʱ���ж�Ա��־��鷭��)');
          ListBoxFongHaoHint.Items.Add('7=����֮��(ħ����,�һ𽣷�,��ʥս����,����ܱ�ɷۺ�ɫ)');
          ListBoxFongHaoHint.Items.Add('8=�л�֮��(�˳��л�ƺ���ʧ)');
          ListBoxFongHaoHint.Items.Add('9=�귨������(���⴫�͵�ͼ)');
          ListBoxFongHaoHint.Items.Add('10=�߼��۷���ʿ(�����������,����������������');
          ListBoxFongHaoHint.Items.Add('                DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('11=0����ʧ�ƺ�(ʱ��������Ч)');
          MemoFongHaoHint.Clear;
          MemoFongHaoHint.Lines.Text := 'Anicount=�����ƺŵ�����Ч��'+#13+
                                        'Looks=�ƺŵ����'+#13+#13+
                                        'Need(��������)'+#13+
                                        '0:��ȼ�   NeedLevel=�ȼ�'+#13+
                                        '1:�蹥���� NeedLevel=������'+#13+
                                        '2:��ħ��   NeedLevel=ħ��'+#13+
                                        '3:�����   NeedLevel=����';
        end;
    end;
  end;
end;

procedure TFrmMain.ComboBoxFilterItemsModeChange(Sender: TObject);
  function FilterItems(Num: string):Boolean;
  begin
    Result := False;
    FrmDM.TableStdItems.Close;
    FrmDM.TableStdItems.Filter := 'Stdmode = '+Num;
    FrmDM.TableStdItems.Filtered := True;
    FrmDM.TableStdItems.Open;
    Result := True;
  end;
  function NoFilterItems():Boolean;
  begin
    Result := False;
    FrmDM.TableStdItems.Close;
    FrmDM.TableStdItems.Filter := '';
    FrmDM.TableStdItems.Filtered := False;
    FrmDM.TableStdItems.Open;
    Result := True;
  end;    
begin
  case ComboBoxFilterItemsMode.ItemIndex of
    0: begin
        if NoFilterItems() then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    1: begin
        if FilterItems('0') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=���������');
          ListBoxItemsHint.Items.Add('1=���������');
          ListBoxItemsHint.Items.Add('2=����ˮ����');
          ListBoxItemsHint.Items.Add('3=��ҩƿ1����');
          ListBoxItemsHint.Items.Add('4=��ҩƿ2����');
          MemoItemsHint.Lines.Text := 'װ�����(Shape)=������ҩƷ������Ч��'+#13+
                                      'HP������(Ac)=����ֵ������'+#13+
                                      'MP������(Mac)=ħ��ֵ������'+#13+
                                      '������ʱ(Mac2)=������Чʱ�䣬��λΪ��';
        end;
    end;
    2: begin
        if FilterItems('1') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    3: begin
        if FilterItems('2') then begin
          ListBoxItemsHint.Clear;
          ListBoxItemsHint.Items.Add('��������=1,��Ʒ���ܷ���6���ݿ���');
          ListBoxItemsHint.Items.Add('Anicount=21 Ϊף��������Ʒ');
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'װ����ۣ�'+#13+
                                      '   Shape=1,�ٻ�ǿ����'+#13+
                                      '   Shape=2,�������ʯ'+#13+
                                      '   Shape=4,ɳ�Ϳ����ʯ'+#13+
                                      '   Shape=5,���'+#13+
                                      '   Shape=9,�޸���ˮ'+#13+
                                      '   Shape=10,�����������׵�'+#13+
                                      '   Shape=11,���ܲ�(�������)'+#13+
                                      '   Shape=12,�������(�������)'+#13+
                                      '   Shape=253,��������(�����־�)'+#13+
                                      '   Shape=254,��������(�����־�)'+#13+
                                      '   Shape=255,������ˮ';
        end;
    end;
    4: begin
        if FilterItems('3') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('1=���������Ѿ�');
          ListBoxItemsHint.Items.Add('2=��������;�');
          ListBoxItemsHint.Items.Add('3=���سǾ�');
          ListBoxItemsHint.Items.Add('4=��ף���ͣ�');
          ListBoxItemsHint.Items.Add('5=���л�سǾ�');
          ListBoxItemsHint.Items.Add('9=�޸��͵�����');
          ListBoxItemsHint.Items.Add('10=��ս���ͣ�');
          ListBoxItemsHint.Items.Add('11=����Ʊ��');
          ListBoxItemsHint.Items.Add('12=����ħ�����ȸ���ҩˮ');
          ListBoxItemsHint.Items.Add('13=��ħ����ҩ��');
          ListBoxItemsHint.Items.Add('14=��ħ����ҩ��');
          MemoItemsHint.Lines.Text := 'װ�����(Shape)=����12ʱ��Ϊ����ҩˮ����Ʒ'+#13+
                                      'shape=12������ҩƷ��'+#13+
                                      '��������ҩˮ��������ʱ(Mac2)=180����͹�����(Dc)=5���򹥻�������5��������ʱ180�룻'+#13+
                                      '������ҩˮ��������ʱ(Mac2)=180����������(Ac2)=1���򹥻��ٶ�˲�����180�룻'+#13+
                                      '��HPǿ��ˮ��������ʱ(Mac2)=120��HP���޼���(Ac)=50����HP��������50��������ʱ120��'+#13+#13+
                                      'shape=13 ��ħ����ҩ��'+#13+
                                      '  ������ʱ(Mac2)=3600��HP���޼���(Ac)=10 ʹ��ʱ����ְҵ���������10��Ӧ���ԣ�ʱ��3600��'+#13+#13+
                                      'shape=14 ��ħ����ҩ��'+#13+
                                      '  ������ʱ(Mac2)=3600��HP���޼���(Ac)=10 ʹ��ʱ��������ӷ�����ħ�����������10��Ӧ���ԣ�ʱ��3600��'+#13+#13+
                                      '������12ʱ��Ϊһ��ľ��顢�͡���Ʊ��Ʒ��';
       end;
    end;


    5: begin
        if FilterItems('4') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('�ֶ�װ�����:');
          ListBoxItemsHint.Items.Add('0=սʿְҵ��');
          ListBoxItemsHint.Items.Add('1=��ʦְҵ��');
          ListBoxItemsHint.Items.Add('2=��ʿְҵ��');
          ListBoxItemsHint.Items.Add('99=(ͨ��)');

          MemoItemsHint.Lines.Text := 'ѧϰ�ȼ�(DuraMax)=Ϊ��ϰʱ����Ҫ�ĵȼ��������ǡ���Ҫ�ȼ�(NeedLevel)����'+#13+
                                      'Source=127ʱ,�������ӻ���֮�ĵ�ŭ��(Reserved*100=����ŭ��ֵ)'+#13+
                                      'Anicount(0-��ͨ�� 1-�ڹ���)'+#13+
                                      '�ļ�������(AC 0-������ 1-Ӣ����)';
        end;
    end;
    6: begin
        if FilterItems('5') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=Ϊ����������');
          ListBoxItemsHint.Items.Add('1=��ľ������ľ����');
          ListBoxItemsHint.Items.Add('2=����������ͭ����');
          ListBoxItemsHint.Items.Add('3=����ͭ����');
          ListBoxItemsHint.Items.Add('4=���̽���');
          ListBoxItemsHint.Items.Add('5=����磩');
          ListBoxItemsHint.Items.Add('6=���ƻꡢذ�ף�');
          ListBoxItemsHint.Items.Add('7=�����ޣ�');
          ListBoxItemsHint.Items.Add('9=�����ߣ�');
          ListBoxItemsHint.Items.Add('10=��ն����');
          ListBoxItemsHint.Items.Add('13=����˪��');
          ListBoxItemsHint.Items.Add('14=����ħ��');
          ListBoxItemsHint.Items.Add('15=���˻ģ�');
          ListBoxItemsHint.Items.Add('16=�����£�');
          ListBoxItemsHint.Items.Add('17=�������¡�ն�µ���');
          ListBoxItemsHint.Items.Add('21=���޼�����');
          ListBoxItemsHint.Items.Add('22=��Ѫ����');
          ListBoxItemsHint.Items.Add('23=����֮�У�');
          ListBoxItemsHint.Items.Add('25=�����ƽ������ǽ���');
          ListBoxItemsHint.Items.Add('26=��������GM������');
          ListBoxItemsHint.Items.Add('29=������֮�У�');
          ListBoxItemsHint.Items.Add('30=����Ѫħ����GM����');
          ListBoxItemsHint.Items.Add('31=��ͳ˧֮�У�');
          ListBoxItemsHint.Items.Add('32=������֮�ȣ�');
          ListBoxItemsHint.Items.Add('33=�������ȣ�');
          ListBoxItemsHint.Items.Add('75=���ڽ����');
          ListBoxItemsHint.Items.Add('76=����ղ���');
          ListBoxItemsHint.Items.Add('77=�����ֲ���������');
          MemoItemsHint.Lines.Text := '����������׼ȷ'+#13+
                                      '������ʱ������'+#13+
                                      'Դ��������ʥǿ��'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      'ǿ����ʥ(Source)=����ǿ�ȣ�����ֵ��0~100����������ʥ������ֵ��-100~0��'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '����(AC)=������ֵ��0~100��'+#13+
                                      '׼ȷ(AC2)=������ֵ��0~200��'+#13+
                                      '����(Mac)=������ֵ��0~100��'+#13+
                                      '�����ٶ�(Mac2)=���㹫ʽ�������ٶ�=246+X��XΪ������ֵ������Ϊ�������磺�����ٶ�+6������Mac2=-240������ֵ��-236~0'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�'+#13+
                                      '  Need=0ʱNeedLevelΪ����ȼ���'+#13+
                                      '  Need=1ʱNeedLevelΪ���蹥������'+#13+
                                      '  Need=2ʱNeedLevelΪ����ħ������'+#13+
                                      '  Need=3ʱNeedLevelΪ���������';
        end;
    end;
    7: begin
        if FilterItems('6') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('8=�����꣩');
          ListBoxItemsHint.Items.Add('11=��������ն�죩');
          ListBoxItemsHint.Items.Add('12=��ħ�ȡ����ȣ�');
          ListBoxItemsHint.Items.Add('18=�����£�');
          ListBoxItemsHint.Items.Add('19=���������');
          ListBoxItemsHint.Items.Add('24=���þ�֮�ȣ�');
          ListBoxItemsHint.Items.Add('27=���Ȼ귨�ȡ�GMȨ�ȣ�');
          ListBoxItemsHint.Items.Add('28=������Ȩ�ȡ�����Ȩ�ȣ�');
          MemoItemsHint.Lines.Text := 'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      'ǿ����ʥ(Source)=����ǿ�ȣ�����ֵ��0~100����������ʥ������ֵ��-100~0��'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '����(AC)=������ֵ��0~100��'+#13+
                                      '׼ȷ(AC2)=������ֵ��0~200��'+#13+
                                      '����(Mac)=������ֵ��0~100��'+#13+
                                      '�����ٶ�(Mac2)=���㹫ʽ�������ٶ�=246+X��XΪ������ֵ������Ϊ�������磺�����ٶ�+6������Mac2=-240������ֵ��-236~0'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';
        end;
    end;

    8: begin
        if FilterItems('7') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'װ�����(Shape) 0 ǧ�ﴫ��'+#13+
                                      '                1 ��Ѫʯ'+#13+
                                      '                2 ��ħʯ'+#13+
                                      '                3 ħѪʯ'+#13+
                                      '                4 ����Ͳ'+#13+
                                      '                5 ����ӡ������ӡ';
        end;
    end;
    9:begin
        if FilterItems('8') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'װ�����(Shape)=0-��ͨ���� 1-���Ʋ���'+#13+
                                      'Anicount=��(Shape)ʱ�����������,'+#13+
                                      '����(Reserved)=���������еľƾ���'+#13+
                                      'HP���޼���(AC)=���Ʋ��������е�Ʒ��';
        end;
    end;
    10:begin
        if FilterItems('9') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    11: begin
        if FilterItems('10') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('1=����');
          ListBoxItemsHint.Items.Add('2=���');
          ListBoxItemsHint.Items.Add('3=�ؿ�');
          ListBoxItemsHint.Items.Add('4=ħ������');
          ListBoxItemsHint.Items.Add('5=���ս��');
          MemoItemsHint.Lines.Text := 'HP���޺͹��������Ƿ������޺�����'+#13+
                                      'MP���޺�������ʱ��ħ�����޺�����';
        end;
    end;
    12: begin
        if FilterItems('11') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('1=����');
          ListBoxItemsHint.Items.Add('2=���');
          ListBoxItemsHint.Items.Add('3=�ؿ�');
          ListBoxItemsHint.Items.Add('4=ħ������');
          ListBoxItemsHint.Items.Add('5=���ս��');
          MemoItemsHint.Lines.Text := 'HP���޺͹��������Ƿ������޺�����'+#13+
                                      'MP���޺�������ʱ��ħ�����޺�����';
        end;
    end;
    13:begin
        if FilterItems('12') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'װ�����(Shape) 0-��ͨ��ʹ�� 1-ҩ��ʹ��';
        end;
    end;
    14:begin
        if FilterItems('13') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'װ�����(Shape)=�����ϵ�AniCount,��Ʒ��+1';
        end;
    end;
    15:begin
        if FilterItems('14') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'Anicount��Ӧ��(Shape)ʱ�����������';
        end;
    end;
    16: begin
        if FilterItems('15') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=��ͨͷ��');
          ListBoxItemsHint.Items.Add('125=����ͷ��');
          ListBoxItemsHint.Items.Add('129=��ͷ��');
          ListBoxItemsHint.Items.Add('132=����ͷ��');
          MemoItemsHint.Lines.Text := 'HP���޺͹��������Ƿ������޺�����'+#13+
                                      'MP���޺�������ʱ��ħ�����޺�����';
        end;
    end;
    17: begin
        if FilterItems('16') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('��ͨ����(ShapeΪ0)�ɿ�����ʾ������');
          ListBoxItemsHint.Items.Add('���߶���(ShapeΪ1)�ɿ�����ʾ������');
          ListBoxItemsHint.Items.Add('��    ��(ShapeΪ2)����ʾ������');
          ListBoxItemsHint.Items.Add('��ɱ����(ShapeΪ3)�ɿ�����ʾ������');
          ListBoxItemsHint.Items.Add('��ţ����(ShapeΪ4)�ɿ�����ʾ������');
          ListBoxItemsHint.Items.Add('���׶���(ShapeΪ5)�ɿ�����ʾ������');
          ListBoxItemsHint.Items.Add('���涷��(ShapeΪ6)�ɿ�����ʾ������');
          ListBoxItemsHint.Items.Add('��¶���(ShapeΪ7)�ɿ�����ʾ������');
          MemoItemsHint.Lines.Text := '�������ƣ�'+#13+
                                      'Anicount 0-����Ӣ��ȫ�ɴ�'+#13+
                                      '         1-����ɴ�'+#13+
                                      '         2-Ӣ�ۿɴ�'+#13+
                                      'Դ����(0-125) ��ɱ����ʱ�����ֱ�������';
        end;
    end;
    18: begin
      if FilterItems('17') then begin
        ListBoxItemsHint.Clear;
        MemoItemsHint.Clear;
        ListBoxItemsHint.Items.Add('Shape:');
        ListBoxItemsHint.Items.Add('  0-6 ������,��ʾ�ȼ�(��Ӧ���ȼ�)');
        ListBoxItemsHint.Items.Add('  237 ҩƷ(˫��ʹ��)');
        ListBoxItemsHint.Items.Add('  238 Ϊ�澭��Ԫ��');
        ListBoxItemsHint.Items.Add('  239-241 Ϊ1-3����(����)');
        ListBoxItemsHint.Items.Add('  242 Ϊ����ʯ��Ƭ');
        ListBoxItemsHint.Items.Add('  243-252 Ϊ1-10������ʯ');
        ListBoxItemsHint.Items.Add('  253-255 ΪӢ�۾�����');

        MemoItemsHint.Lines.Text := 'Դ���� 0-��ʾ����'+#13+
                                    'DuraMax(�־�)-�ɵ�������ֵ'+#13+
                                    'Anicount:'+#13+
                                    '  (��)-�ϳɳɹ���'+#13+
                                    '  (Ӣ�۾�����)-Ӣ�۾��羭��'+#13+
                                    '  (�澭��Ԫ��)-�澭���� 1:1000'+#13+
                                    '  (ҩƷ)0-������ 1-������'+#13+
                                    'Reserved-�ϳɺ����Ʒ�ı�ʶ,��2'+#13+
                                    '   ,�ϳɳɹ�����(����17,���2)'+#13+
                                    'Ac--(ҩƷ��)����ֵ������'+#13+
                                    'Mac-(ҩƷ��)ħ��ֵ������'+#13+
                                    'Dc--(ҩƷ��)>0ʱ�ɽ��������ķ�����';
      end;
    end;
    19: begin
      if FilterItems('18') then begin
        ListBoxItemsHint.Clear;
        MemoItemsHint.Clear;
        ListBoxItemsHint.Items.Add('Shape--��ʾ�ȼ�(����ĵȼ���Ӧ)');
        ListBoxItemsHint.Items.Add('Դ���� 0-��ʾ����');
        ListBoxItemsHint.Items.Add('DuraMax(�־�)--�ɵ�������ֵ');
        ListBoxItemsHint.Items.Add('Anicount--�ϳɳɹ���');
        MemoItemsHint.Lines.Text := '���������������˷���Ʒ';
      end;
    end;
    20: begin
        if FilterItems('19') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=��������ɫ���ݡ�ˮ��');
          ListBoxItemsHint.Items.Add('123=��������');
          MemoItemsHint.Lines.Text := '������ʱ Ϊ ���� '+#13+
                                      '�������� Ϊ ħ�����'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      'Դ����(0-125) ��ɱ����ʱ�����ֱ�������'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      'ħ�����(Ac2)=��1��10%��2��20%����������ֵ��0~100��'+#13+
                                      '����(Mac)=������ֵ��0~100��'+#13+
                                      '����(Mac2)=������ֵ��0~100��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';
        end;
    end;
    21: begin
        if FilterItems('20') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=��ͨ����');
          ListBoxItemsHint.Items.Add('113=��������');
          ListBoxItemsHint.Items.Add('120=��������');
          ListBoxItemsHint.Items.Add('121=̽������');
          ListBoxItemsHint.Items.Add('135=��������');
          ListBoxItemsHint.Items.Add('138=��������');
          MemoItemsHint.Lines.Text := '����������׼ȷ'+#13+
                                      '������ʱ������'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '׼ȷ(Ac2)=������ֵ��0~100��'+#13+
                                      '����(Mac2)=������ֵ��0~100��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';
        end;
    end;
    22: begin
        if FilterItems('21') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=�������');
          ListBoxItemsHint.Items.Add('113=������');
          ListBoxItemsHint.Items.Add('127=GM����');
          MemoItemsHint.Lines.Text := 'HP���� Ӧ���ǹ�������'+#13+
                                      '��������Ӧ���������ָ�'+#13+
                                      '������ʱӦ����ħ���ָ�'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '�������ٶ�(Ac)=������ֵ��0~10��'+#13+
                                      '�����ָ�(Ac2)=��1��10%��2��20%����������ֵ��0~100��'+#13+
                                      '�������ٶ�(Mac)=������ֵ��0~10��'+#13+
                                      'ħ���ָ�(Mac2)=��1��10%��2��20%����������ֵ��0~100��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';
        end;
    end;
    23: begin
        if FilterItems('22') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=��ͨ��ָ');
          ListBoxItemsHint.Items.Add('111=�����ָ');
          ListBoxItemsHint.Items.Add('112=���ͽ�ָ');
          ListBoxItemsHint.Items.Add('113=��Խ�ָ');
          ListBoxItemsHint.Items.Add('114=�����ָ');
          ListBoxItemsHint.Items.Add('115=�����ָ');
          ListBoxItemsHint.Items.Add('116=������ָ');
          ListBoxItemsHint.Items.Add('117=��ŭ��ָ');
          ListBoxItemsHint.Items.Add('118=�����ָ');
          ListBoxItemsHint.Items.Add('119=�����ؽ�ָ');
          ListBoxItemsHint.Items.Add('122,123,124,125=�����ָ');
          ListBoxItemsHint.Items.Add('130,131,132=���ؽ�ָ');
          ListBoxItemsHint.Items.Add('133=������ָ');
          ListBoxItemsHint.Items.Add('136=���ѽ�ָ');
          ListBoxItemsHint.Items.Add('169=���ǻ����ָ');
          ListBoxItemsHint.Items.Add('189=��ħ�����ָ');
          ListBoxItemsHint.Items.Add('190=ս����Խ�ָ');
          ListBoxItemsHint.Items.Add('191=ħ����Խ�ָ');
          ListBoxItemsHint.Items.Add('192=����ٵؼ���');
          ListBoxItemsHint.Items.Add('197=������ָ');
          MemoItemsHint.Lines.Text := 'HP���޺͹��������Ƿ������޺ͷ�������'+#13+
                                      'MP���޺�������ʱӦ����ħ�����޺�����'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '�������߹���(Ac��Ac2)=������ֵ��0~200��'+#13+
                                      '��������ħ��(Mac��Mac2)=������ֵ��0~200��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';
        end;
    end;
    24: begin
        if FilterItems('23') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=���������¡�����ָ');
          ListBoxItemsHint.Items.Add('113=��˹��ָ');
          ListBoxItemsHint.Items.Add('114=��˹��ָ');
          ListBoxItemsHint.Items.Add('119=��˹��ָ');
          ListBoxItemsHint.Items.Add('128=����ָ');
          MemoItemsHint.Lines.Text := 'HP�����ǹ�������'+#13+
                                      '�����ٶ��Ƕ�����'+#13+
                                      '������ʱ���ж��ָ�'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '�������ٶ�(Ac)=������ֵ��0~10��'+#13+
                                      '������(Ac2)=��1��10%��2��20%����������ֵ��0~100��'+#13+
                                      '�������ٶ�(Mac)=������ֵ��0~10��'+#13+
                                      '�ж��ָ�(Mac2)=��1��10%��2��20%����������ֵ��0~100��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';

        end;
    end;
    25: begin
        if FilterItems('24') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=�����������ն�����а����������');
          ListBoxItemsHint.Items.Add('124=��������');
          MemoItemsHint.Lines.Text := '����������׼ȷ'+#13+
                                      '������ʱ������'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '׼ȷ(Ac2)=������ֵ��0~100��'+#13+
                                      '����(Mac2)=������ֵ��0~100��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';

        end;
    end;
    26: begin
        if FilterItems('25') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=��������');
          ListBoxItemsHint.Items.Add('1=��ɫҩ��');
          ListBoxItemsHint.Items.Add('2=��ɫҩ��');
          ListBoxItemsHint.Items.Add('5=�����');
        end;
    end;
    27: begin
        if FilterItems('26') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=��ͨ��');
          ListBoxItemsHint.Items.Add('126=������');
          ListBoxItemsHint.Items.Add('131=��������');
          ListBoxItemsHint.Items.Add('134=��������');
          ListBoxItemsHint.Items.Add('137=��������');
          MemoItemsHint.Lines.Text := 'HP���޺͹��������Ƿ������޺�����'+#13+
                                      'MP���޺�������ʱ��ħ�����޺�����'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '�������߹���(Ac��Ac2)=������ֵ��0~200��'+#13+
                                      '��������ħ��(Mac��Mac2)=������ֵ��0~200��'+#13+
                                      '�������߹�����(Dc��Dc2)=������ֵ��0~200��'+#13+
                                      '��������ħ����(Mc��Mc2)=������ֵ��0~200��'+#13+
                                      '�������ߵ�����(Sc��Sc2)=������ֵ��0~200��'+#13+
                                      '��Ҫ�ȼ�(Need)�븽������(NeedLevel)=��Ҫ���ʹ�ã�Need=0ʱNeedLevelΪ����ȼ���Need=1ʱNeedLevelΪ���蹥������Need=2ʱNeedLevelΪ����ħ������Need=3ʱNeedLevelΪ���������';

        end;
    end;
    28:begin
      if FilterItems('27') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := '����������׼ȷ'+#13+
                                      '������ʱ������'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '׼ȷ(Ac2)=������ֵ��0~100��'+#13+
                                      '����(Mac2)=������ֵ��0~100��';
      end;
    end;
    29:begin
      if FilterItems('28') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := '������ʱ Ϊ ���� '+#13+
                                      '�������� Ϊ ׼ȷ'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      'Դ����(0-125) ��ɱ����ʱ�����ֱ�������'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '׼ȷ(Ac2)=������ֵ��0~100��'+#13+
                                      '����(Mac)=������ֵ��0~100��'+#13+
                                      '����(Mac2)=������ֵ��0~100��';
      end;
    end;
    30: begin
      if FilterItems('29') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := '������ʱ Ϊ ���� '+#13+
                                      '�������� Ϊ ����'+#13+
                                      'װ�����(Shape)=����װ����ۣ�����ֵ��ͬ����Ʒ������������Ͽ�Ҳ��ͬ'+#13+
                                      'Դ����(0-125) ��ɱ����ʱ�����ֱ�������'+#13+
                                      '��Ʒ���(Looks)=����ֵ��ͬ����Ʒ������Ʒ�������Ҳ��ͬ'+#13+
                                      '�־ö�(DuraMax)=��1000Ϊ��λ��1000��Ϊ1����ĳ־�'+#13+
                                      '����(Ac2)=������ֵ��0~100��'+#13+
                                      '����(Mac)=������ֵ��0~100��'+#13+
                                      '����(Mac2)=������ֵ��0~100��';
      end;
    end;
    31: begin
        if FilterItems('30') then begin
          ListBoxItemsHint.Clear;
          ListBoxItemsHint.Items.Add('Source=0 ��ʱ����־�');//20090416
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'Դ����������'+#13+
                                      'HP���޺͹��������Ƿ������޺�����'+#13+
                                      'MP���޺�������ʱ��ħ�����޺�����'+#13+#13+
                                      'Anicount=202 ����ѫ��(��ԡ�������������)';

        end;
    end;
    32: begin
        if FilterItems('31') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('98=������ǿ��ҩ');
          ListBoxItemsHint.Items.Add('99=������ǿħ��ҩ');
          ListBoxItemsHint.Items.Add('100=������ҩ');
          ListBoxItemsHint.Items.Add('101=����ħ��ҩ');
          ListBoxItemsHint.Items.Add('102=��ҩ��С����');
          ListBoxItemsHint.Items.Add('103=ħ��ҩ��С����');
          ListBoxItemsHint.Items.Add('104=��ҩ���У���');
          ListBoxItemsHint.Items.Add('105=ħ��ҩ���У���');
          ListBoxItemsHint.Items.Add('106=�������Ѿ��');
          ListBoxItemsHint.Items.Add('107=������;��');
          ListBoxItemsHint.Items.Add('108=�سǾ��');
          ListBoxItemsHint.Items.Add('109=�л�سǾ��');
          ListBoxItemsHint.Items.Add('110=�����');
          ListBoxItemsHint.Items.Add('111=���������');
          ListBoxItemsHint.Items.Add('112=ѩ˪��');
          ListBoxItemsHint.Items.Add('113=��ľ��');
          ListBoxItemsHint.Items.Add('114=��ľ��');
          ListBoxItemsHint.Items.Add('115=�������춾');
          ListBoxItemsHint.Items.Add('116=����������');
          MemoItemsHint.Lines.Text := 'װ�������ҩƷ������'+#13+
                                      'Anicount�ǽű�������';
        end;
    end;
    33:begin
        if FilterItems('36') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('1=���š���ľ����ľ����ľ��');
        end;
    end;
    34: begin
        if FilterItems('40') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    35: begin
        if FilterItems('41') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=����֮�顢���֤��');
          ListBoxItemsHint.Items.Add('1=Ѫ����');
        end;
    end;
    36: begin
        if FilterItems('42') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    37: begin
        if FilterItems('43') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    38: begin
        if FilterItems('44') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=����Ž�');
          ListBoxItemsHint.Items.Add('1=����ͷ��ˮ����');

          MemoItemsHint.Lines.Text := '248=��ת�鵤'+#13+
                                      '249=һ����ϰ����'+#13+
                                      '250=������ϰ����'+#13+
                                      '251=������ϰ����'+#13+
                                      '252=��ϰ���ؾ���'+#13+
                                      '253=��ħ��ý(Ʒ�ʣ�����[Reserved]���ܴ���228)'+#13+
                                      '254=��Ƥ��'+#13+
                                      '255=���ؾ���';
        end;
    end;
    39: begin
        if FilterItems('45') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=�׾ջ�');
          ListBoxItemsHint.Items.Add('2=����');
          ListBoxItemsHint.Items.Add('6=����');
        end;
    end;
    40: begin
        if FilterItems('46') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('0=ƾ֤');
          ListBoxItemsHint.Items.Add('1=���롢ҩ��ʦ���ŵ�');
        end;
    end;
    41: begin
        if FilterItems('47') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          MemoItemsHint.Lines.Text := 'Source=127ʱ,�������ӻ���֮�ĵ�ŭ��(Reserved*100=����ŭ��ֵ)';
        end;
    end;
    42: begin
      if FilterItems('48') then begin
        ListBoxItemsHint.Clear;
        MemoItemsHint.Clear;
        MemoItemsHint.Lines.Text := 'Reserved 0=�ɱ���'+#13+
                                    '         1=�±���'+#13+
                                    '         2-�����걦��'+#13+#13+
                                    'Source   ���Ӷ�Ӧ�������ļ���'+#13+#13+
                                    'AniCount ��ӦԿ�׵�Shape';
      end;
    end;
    43: begin
      if FilterItems('49') then begin
        ListBoxItemsHint.Clear;
        MemoItemsHint.Clear;
        MemoItemsHint.Lines.Text := 'Reserved ��ʾ���������ڵ�Ԫ����[ֻ������0-255]'+#13+#13+
                                    'Anicount ��ʾһ�ο��Թ������Ʒ����(��������)'+#13+#13+
                                    'Shape    ��Ӧ�����AniCount,�ſɴ򿪱���';
      end;
    end;
    44: begin
        if FilterItems('50') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    45: begin
        if FilterItems('51') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('������ �־�ֵ1=1W');
          ListBoxItemsHint.Items.Add('�ڹ��� �־�ֵ1=1000');
          ListBoxItemsHint.Items.Add('       �־�ֵ1-65535');
          ListBoxItemsHint.Items.Add('��  �� �־�ֵ1=1W');
          ListBoxItemsHint.Items.Add('NeedLevel--Ϊ��ʹ�þۼ���Ʒ�ĵȼ�');
          ListBoxItemsHint.Items.Add('Need--0-�ȼ��ﵽNeedLevelֵ���ʹ��');
          ListBoxItemsHint.Items.Add('      1-�ȼ�С��NeedLevelֵʱ��ʹ��');
          MemoItemsHint.Lines.Text := 'װ�����=0 ������(�ۼ�����) Anicount=1 ��������'+#13+#13+
                                      'װ�����=1 �ڹ���(�ۼ��ڹ�����)'+#13+#13+
                                      'װ�����=2 Ӣ�۾�����(�ۼ�����,˫��Ӣ�۵þ���)'+#13+#13+
                                      'װ�����=3 ��������(����ۼ�,��ʱ������,˫��Ӣ�۵þ���,����Ӣ�۵ȼ���������) Anicount�ֶδ���ʹ�������Ԫ���� Reserved=255(���õȼ����Ʒ������)';
        end;
    end;
    46: begin
        if FilterItems('52') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    47: begin
        if FilterItems('53') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    48: begin
        if FilterItems('54') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    49:begin
        if FilterItems('60') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
          ListBoxItemsHint.Items.Add('DC1��DC2Ϊ�ƾ��ȷ�Χ(�����Ч)');
          MemoItemsHint.Lines.Text := 'Anicount 1-��ͨ�� 2-ҩ��'+#13+
                                      'װ�����(Shape)=����(Shape),���ʱ'+#13+
                                      '�Ż��п��ܻ�ö�Ӧ�ľ���'+#13+
                                      'NeedLevel--ҩ��ʹ������ľ���ֵ'+#13+#13+
                                      'Shape  0--�վ�'+#13+
                                      '       1-7--��ͨ��'+#13+
                                      '       8--���Ǿ�'+#13+
                                      '       9--�𲭾�'+#13+
                                      '       10--������'+#13+
                                      '       11--���ξ�'+#13+
                                      '       12--�ߵ���'+#13+
                                      '       13--��˴�'+#13+
                                      '       14--����������'+#13+
                                      '       15--���������'+#13+
                                      '       16--��Ԫ��';
        end;
    end;
    50: begin
        if FilterItems('62') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    51: begin
        if FilterItems('63') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
    52: begin
        if FilterItems('64') then begin
          ListBoxItemsHint.Clear;
          MemoItemsHint.Clear;
        end;
    end;
  end;
end;
//���ݿ�
procedure TFrmMain.BtnMagicBaseBakClick(Sender: TObject);
begin
  SaveDialog1.Filter := '���ݿ�(*.DB)|*.DB';
  if Sender = BtnMagicBaseBak then begin
     if not FileExists(sGameDirectory + 'Mud2\DB\Magic.DB') then begin
       FrmMain.bsSkinMessage1.MessageDlg('����İ汾Ŀ¼��û���ҵ�ħ�����ݿ�!!',mtInformation,[mbOK],0);
       Exit;
     end;
     if SaveDialog1.Execute then
     CopyFile(PChar(sGameDirectory + 'Mud2\DB\Magic.DB'),PChar(SaveDialog1.FileName),False);
  end;
  if Sender = BtnMobBaseBak then begin
     if not FileExists(sGameDirectory + 'Mud2\DB\Monster.DB') then begin
       FrmMain.bsSkinMessage1.MessageDlg('����İ汾Ŀ¼��û���ҵ��������ݿ�!!',mtInformation,[mbOK],0);
       Exit;
     end;
     if SaveDialog1.Execute then
     CopyFile(PChar(sGameDirectory + 'Mud2\DB\Monster.DB'),PChar(SaveDialog1.FileName),False);
  end;
  if Sender = BtnItemsBaseBak then begin
     if not FileExists(sGameDirectory + 'Mud2\DB\StdItems.DB') then begin
       FrmMain.bsSkinMessage1.MessageDlg('����İ汾Ŀ¼��û���ҵ���Ʒ���ݿ�!!',mtInformation,[mbOK],0);
       Exit;
     end;
     if SaveDialog1.Execute then
     CopyFile(PChar(sGameDirectory + 'Mud2\DB\StdItems.DB'),PChar(SaveDialog1.FileName),False);
  end;
  if Sender = BtnFongHaoBaseBak then begin
     if not FileExists(sGameDirectory + 'Mud2\DB\FengHaos.DB') then begin
       FrmMain.bsSkinMessage1.MessageDlg('����İ汾Ŀ¼��û���ҵ��ƺ����ݿ�!!',mtInformation,[mbOK],0);
       Exit;
     end;
     if SaveDialog1.Execute then
     CopyFile(PChar(sGameDirectory + 'Mud2\DB\FengHaos.DB'),PChar(SaveDialog1.FileName),False);
  end;
end;
//�ָ���
procedure TFrmMain.BtnMagicBaseRestoreClick(Sender: TObject);
begin
  SaveDialog1.Filter := '���ݿ�(*.DB)|*.DB';
  OpenDialog1.Filter := '���ݿ�(*.DB)|*.DB';
  if Sender = BtnMagicBaseRestore then begin
     if OpenDialog1.Execute then
     if bsSkinMessage1.MessageDlg('ȷ����ѡ�ļ�������������ݿ���'+#13+'(��ѡ�Ŀ⽫������еĿ�)' ,mtInformation,[mbYes,mbNo],0) = ID_NO then Exit;
     FrmDM.TableMagic.Active := False;
     CopyFile(PChar(OpenDialog1.FileName),PChar(sGameDirectory + 'Mud2\DB\Magic.DB'),False);
     FrmDM.TableMagic.Active := True;
  end;
  if Sender = BtnMobBaseRestore then begin
     if OpenDialog1.Execute then
     if bsSkinMessage1.MessageDlg('ȷ����ѡ�ļ�������������ݿ���'+#13+'(��ѡ�Ŀ⽫������еĿ�)' ,mtInformation,[mbYes,mbNo],0) = ID_NO then Exit;
     FrmDM.TableMonster.Active := False;
     CopyFile(PChar(OpenDialog1.FileName),PChar(sGameDirectory + 'Mud2\DB\Monster.DB'),False);
     FrmDM.TableMonster.Active := True;
  end;
  if Sender = BtnItemsBaseRestore then begin
     if OpenDialog1.Execute then
     if bsSkinMessage1.MessageDlg('ȷ����ѡ�ļ�������������ݿ���'+#13+'(��ѡ�Ŀ⽫������еĿ�)' ,mtInformation,[mbYes,mbNo],0) = ID_NO then Exit;
     FrmDM.TableStdItems.Active := False;
     CopyFile(PChar(OpenDialog1.FileName),PChar(sGameDirectory + 'Mud2\DB\StdItems.DB'),False);
     FrmDM.TableStdItems.Active := True;
  end;
  if Sender = BtnFongHaoRestore then begin
     if OpenDialog1.Execute then
     if bsSkinMessage1.MessageDlg('ȷ����ѡ�ļ�������������ݿ���'+#13+'(��ѡ�Ŀ⽫������еĿ�)' ,mtInformation,[mbYes,mbNo],0) = ID_NO then Exit;
     FrmDM.TableStdItems.Active := False;
     CopyFile(PChar(OpenDialog1.FileName),PChar(sGameDirectory + 'Mud2\DB\FengHaos.DB'),False);
     FrmDM.TableStdItems.Active := True;
  end;
end;
{******************************************************************************}
//��������ɫ����������
function GetRGB(c256: Byte): TColor;
begin
  Move(ColorArray, ColorTable, SizeOf(ColorArray));
  Result := RGB(ColorTable[c256].rgbRed, ColorTable[c256].rgbGreen, ColorTable[c256].rgbBlue);
end;

procedure TFrmMain.TrackEditColor1Change(Sender: TObject);
begin
  RzLabel1.Color := GetRGB(TrackEditColor1.Value);
end;

procedure TFrmMain.TrackEditColor2Change(Sender: TObject);
begin
   RzLabel1.Font.Color := GetRGB(TrackEditColor2.Value);
end;

procedure TFrmMain.FormShow(Sender: TObject);
var
  sProductName: string;
  sVersion: string;
  sBbsSite: string;
begin
  Decode(g_sProductName, sProductName);
  Decode(g_sVersion, sVersion);
  Decode(g_sBbsSite, sBbsSite);
  LabelProductName.Caption := sProductName;
  LabelVersion.Caption := sVersion;
  bsSkinLinkLabel1.Caption := sBbsSite;
  bsSkinLinkLabel1.URL := sBbsSite;
  bsSkinPageControl1.ActivePage:= bsSkinTabSheet1;
end;
{******************************************************************************}
//�ı���������
Function TFrmMain.ExportTxt(DBGridEh:TDBGrideh;Var TextName:string):BooLean;
Var F:TextFile;
    I:Integer;
    LStrField:String;
    Field: Array of String;
begin
   if DBGridEh.DataSource.DataSet.IsEmpty then
      Raise Exception.Create('û�����ݼ�¼���뵼����');
   DBGridEh.DataSource.DataSet.First;
   SetLength(Field,DBGridEh.DataSource.DataSet.FieldCount);
   if FileExists(TextName) then
      if bsSkinMessage1.MessageDlg('���ļ��Ѵ���,�Ƿ񸲸�',mtInformation,[mbOK,mbCancel],0) = IdCancel then Abort;
   DBGridEh.DataSource.DataSet.DisableControls;
   AssignFile(F,TextName);
   ReWrite(F);
   try
     try
       While Not DBGridEh.DataSource.DataSet.Eof do begin
         LStrField:='';
         For I:=0 to DBGridEh.DataSource.DataSet.FieldCount-1 do begin
           IF DBGridEh.Columns[I].Visible then  Field[I]:=Trim(DBGridEh.DataSource.DataSet.Fields[I].AsString)+';';
           LStrField:=LStrField+Trim(Field[I]);
         end;
         WriteLn(F,LStrField);
         DBGridEh.DataSource.DataSet.Next;
       end;
       Result:=True;
     Except
       Result:=False;
     end;
   finally
     CloseFile(F);
     DBGridEh.DataSource.DataSet.EnableControls;
   end;
end;
//�ı����е���
Function TFrmMain.ExportTxt1(DBGridEh:TDBGrideh;Var TextName:string):BooLean;
var J:integer;
    S:string;
    F:TextFile;
begin
  if DBGridEh.SelectedField = nil then
    Raise Exception.Create('û�����ݼ�¼���뵼����');

   AssignFile(F,TextName);
   ReWrite(F);
   try
     try
      with DBGridEh.DataSource.DataSet do begin
        for J := 0 to DBGridEh.FieldCount-1 do begin
          S:= S + DBGridEh.Fields[J].AsString+';';
        end;
        WriteLn(F,S);
      end;
     Result:=True;
     Except
       Result:=False;
     end;
   finally
     CloseFile(F);
   end;
end;

procedure TFrmMain.bsSkinButton7Click(Sender: TObject);
var
  Filename: STRING;
begin
  if FrmDM.TableStdItems.RecordCount = 0 then
  Begin
   //Application.MessageBox(#13'û�пɵ���������,�븴��!!!', MBInfo, 16+MB_OK);
   bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
   Exit;
  end;
  SaveDialog1.Filter:='�ı��ļ�(*.txt)|*.txt';
  if Not SaveDialog1.Execute then Exit;
  Filename:=SaveDialog1.FileName ;
  if ExportTxt(ItemsDBGrid,Filename) then
    bsSkinMessage1.MessageDlg('��Ʒ���ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('��Ʒ���ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
end;

procedure TFrmMain.N5Click(Sender: TObject);
var
  Filename: STRING;
begin
  IF ItemsDBGrid.DataSource=nil then Exit;
  SaveDialog1.Filter:='�ı��ļ�(*.txt)|*.txt';
  if Not SaveDialog1.Execute then Exit;
  Filename:=SaveDialog1.FileName ;

  case bsSkinPageControl2.TabIndex of
    0:begin
       if FrmDM.TableMagic.RecordCount = 0 then
          Begin
           //Application.MessageBox(#13'û�пɵ���������,�븴��!!!', MBInfo, 16+MB_OK);
           bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
           Exit;
          end;
       if ExportTxt1(MagicDBGrid,Filename) then bsSkinMessage1.MessageDlg('�������ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('�������ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
      end;
    1:begin
        if FrmDM.TableMonster.RecordCount = 0 then
          Begin
           //Application.MessageBox(#13'û�пɵ���������,�븴��!!!', MBInfo, 16+MB_OK);
           bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
           Exit;
          end;
       if ExportTxt1(MobDBGrid,Filename) then
          bsSkinMessage1.MessageDlg('������ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('������ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
      end;
    2:begin
        if FrmDM.TableStdItems.RecordCount = 0 then
          Begin
           //Application.MessageBox(#13'û�пɵ���������,�븴��!!!', MBInfo, 16+MB_OK);
           bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
           Exit;
          end;
       if ExportTxt1(ItemsDBGrid,Filename) then
          bsSkinMessage1.MessageDlg('��Ʒ���ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('��Ʒ���ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
      end;
    3: begin
        if FrmDM.TableFongHao.RecordCount = 0 then Begin
          //Application.MessageBox(#13'û�пɵ���������,�븴��!!!', MBInfo, 16+MB_OK);
          bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
          Exit;
        end;
        if ExportTxt1(FongHaoDBGrid,Filename) then
          bsSkinMessage1.MessageDlg('�ƺ����ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('��Ʒ���ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
      end;
  end;
end;

procedure TFrmMain.bsSkinButton12Click(Sender: TObject);
var
  Filename: STRING;
begin
  IF MagicDBGrid.DataSource=nil then Exit;
  if FrmDM.TableMagic.RecordCount = 0 then
  Begin
   bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
   Exit;
  end;
  SaveDialog1.Filter:='�ı��ļ�(*.txt)|*.txt';
  if Not SaveDialog1.Execute then Exit;
  Filename:=SaveDialog1.FileName ;
  if ExportTxt(MagicDBGrid,Filename) then
     bsSkinMessage1.MessageDlg('�������ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('�������ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
end;

procedure TFrmMain.bsSkinButton10Click(Sender: TObject);
begin
  if bsSkinEdit1.Text = '' then Exit;
  with FrmDM.TableFongHao do begin
    if not Eof then begin
      EditKey;
      DisableControls;
      while not Eof do begin
        if pos(Trim(bsSkinEdit1.Text), FieldByName('Name').AsString)   <=   0   then Next
        else Break;
      end;
      EnableControls;
    end;
  end;
end;

procedure TFrmMain.bsSkinButton11Click(Sender: TObject);
var
  Filename: STRING;
begin
  IF MobDBGrid.DataSource=nil then Exit;
  if FrmDM.TableMonster.RecordCount = 0 then
  Begin
   bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
   Exit;
  end;
  SaveDialog1.Filter:='�ı��ļ�(*.txt)|*.txt';
  if Not SaveDialog1.Execute then Exit;
  Filename:=SaveDialog1.FileName ;
  if ExportTxt(MobDBGrid,Filename) then
     bsSkinMessage1.MessageDlg('������ݵ����ɹ�!!!',mtInformation,[mbOK],0);
end;
{******************************************************************************}
//�����Ǳ������
procedure TFrmMain.BeforePrint();
begin
 {if Printer.Printers.Count = 0 then begin
   bsSkinMessage1.MessageDlg('��Ҫ��װ��ӡ�����ܴ�ӡ!!!',mtInformation,[mbOK],0);
   Abort;
  end; }
  PrintDBGridEh1.PageFooter.CenterText.Add('��&[Page]ҳ ��&[Pages]ҳ');
  PrintDBGridEh1.PageHeader.CenterText.Clear;
  {�������������}
  PrintDBGridEh1.PageHeader.Font.Size:=16;                //��С
  PrintDBGridEh1.PageHeader.Font.Name:='����';            //����
  PrintDBGridEh1.PageHeader.Font.Charset:=GB2312_CHARSET; //�ַ���
  PrintDBGridEh1.PageHeader.Font.Style:=[fsBold];         //����Ӵ�
end;

procedure TFrmMain.bsSkinButton15Click(Sender: TObject);
begin
  PrintDBGridEh1.DBGridEh:=MagicDBGrid;
  BeforePrint();
  PrintDBGridEh1.PageHeader.CenterText.Add('3K�Ƽ�--��������');
  PrintDBGridEh1.Preview;
end;

procedure TFrmMain.bsSkinButton16Click(Sender: TObject);
var
  Filename: STRING;
begin
  if FrmDM.TableFongHao.RecordCount = 0 then Begin
   bsSkinMessage1.MessageDlg('û�пɵ���������,�븴��!!!',mtInformation,[mbOK],0);
   Exit;
  end;
  SaveDialog1.Filter:='�ı��ļ�(*.txt)|*.txt';
  if Not SaveDialog1.Execute then Exit;
  Filename:=SaveDialog1.FileName ;
  if ExportTxt(FongHaoDBGrid,Filename) then
    bsSkinMessage1.MessageDlg('�ƺ����ݵ����ɹ�!!!',mtInformation,[mbOK],0);//Application.MessageBox('��Ʒ���ݵ����ɹ�!!!', MBInfo, 64+MB_OK);
end;

procedure TFrmMain.bsSkinButton17Click(Sender: TObject);
begin
  PrintDBGridEh1.DBGridEh:=FongHaoDBGrid;
  BeforePrint();
  PrintDBGridEh1.PageHeader.CenterText.Add('3K�Ƽ�--�ƺ�����');
  PrintDBGridEh1.Preview;
end;

procedure TFrmMain.bsSkinButton14Click(Sender: TObject);
begin
  PrintDBGridEh1.DBGridEh:=MobDBGrid;
  BeforePrint();
  PrintDBGridEh1.PageHeader.CenterText.Add('3K�Ƽ�--��������');
  PrintDBGridEh1.Preview;
end;

procedure TFrmMain.bsSkinButton13Click(Sender: TObject);
begin
  PrintDBGridEh1.DBGridEh:=ItemsDBGrid;
  BeforePrint();
  PrintDBGridEh1.PageHeader.CenterText.Add('3K�Ƽ�--��Ʒ����');
  PrintDBGridEh1.Preview;
end;
{******************************************************************************}



procedure TFrmMain.bsSkinButtonLabel1Click(Sender: TObject);
begin
  FrmAbout := TFrmAbout.Create(Owner);
  FrmAbout.Open();
  FrmAbout.Free;
end;

procedure TFrmMain.BtnAlterMagicExpClick(Sender: TObject);
var
  str,SQLstr: string;
begin
  if bsSkinCheckRadioBox1.Checked then str:=' L1Train='+ FloatToStr(bsSkinSpinEdit1.Value)
  else if bsSkinCheckRadioBox2.Checked then str:=' L2Train='+ FloatToStr(bsSkinSpinEdit1.Value)
  else if bsSkinCheckRadioBox3.Checked then str:=' L3Train='+ FloatToStr(bsSkinSpinEdit1.Value);
  SQLstr:='Update Magic set '+ str;
  with FrmDM.Query1 do begin
    close;
    Sql.Clear;
    sql.Add(Sqlstr);
    ExecSql;
  end;
  FrmDM.TableMagic.Refresh;
end;
//----------------------------------------------------------------------------
//Wil�༭��
function TFrmMain.Extractrec(Restype,ResName,ResNewNAme:string):boolean;
var
  Res:TResourceStream;
Begin
  Res:=TResourceStream.Create(HinStance,ResName,Pchar(ResType));
  Res.SaveToFile(ResNewName);
  Res.Free;
  Result:=True;
End;

procedure TFrmMain.FillInfo(index:Integer);
var
  Width1,Height1:Integer;
  zoom,zoom1:real;
begin
  zoom:= 0;
  zoom1:=0;
  if Wil.Stream<>nil then begin
      BMpIndex:=Index;
      BmpTran:=checkboxTransparent.Checked;
      MainBitMap:=Wil.Bitmaps[index];
      Width1:=Wil.Width;
      Height1:=WIl.Height;
      if CheckBoxjump.Checked then begin
        While ((Width1<=1) or (Height1<=1))and (BmpIndex<Wil.ImageCount-1) do Begin
          Inc(BmpIndex);
          Width1:=Wil.Bitmaps[Bmpindex].Width;
          Height1:=WIl.Bitmaps[Bmpindex].Height;
        End;
      End;
      if RbAuto.Checked then Begin
        if (Width1<PaintBox1.Width) and (Height1<Paintbox1.Height) then Begin
         BmpZoom:=1;
         if checkboxXY.Checked then Begin
           Bmpx:=Paintbox1.Width div 2 +WIl.px;
           Bmpy:=PaintBox1.Height div 2+Wil.py;
         End Else Begin
           Bmpx:=(Paintbox1.Width-Width1) div 2;
           Bmpy:=(Paintbox1.Height-Height1) div 2;
         end;
        End else Begin
          if Width1>PaintBox1.Width then Zoom:=Width1/PaintBox1.Width;
          if Height1>PaintBox1.Height then Zoom1:=Height1/PaintBox1.Height;
          if zoom>zoom1 then BmpZoom:=Zoom
          else Bmpzoom:=Zoom1;
          bmpx:=1;
          Bmpy:=1;
        End;
      End else Begin
         if Rb50.Checked then BmpZoom:=0.5;
         if Rb100.Checked then BmpZoom:=1;
         if Rb200.Checked then BmpZoom:=2;
         if Rb400.Checked then BmpZoom:=4;
         if Rb800.Checked then BmpZoom:=8;
         bmpx:=1;
         Bmpy:=1;
        Paintbox1.Width:=ScrollBox1.Width-5;
        PaintBox1.Height:=ScrollBox1.Height-5;
        Width1:=Round(Width1*BMpZoom);
        Height1:=Round(Height1*BmpZoom);
        if (Width1<PaintBox1.Width) and (Height1<Paintbox1.Height) then Begin
         if checkboxXY.Checked then Begin
           Bmpx:=Paintbox1.Width div 2 +WIl.px;
           Bmpy:=PaintBox1.Height div 2+Wil.py;
         End Else Begin
           Bmpx:=(Paintbox1.Width-width1) div 2;
           Bmpy:=(Paintbox1.Height-Height1) div 2;
         end;
        End else Begin
          PaintBox1.Width:=Width1;
          PaintBox1.Height:=Height1;
        End;
      End;

      Labelx.Caption:=InttoStr(Wil.px);
      Labely.Caption:=InttoStr(Wil.py);
      LabelSize.Caption:=Inttostr(Width1)+'*'+Inttostr(Height1);
      LabelIndex.Caption:=Inttostr(Index)+'/'+Inttostr(WIl.ImageCount-1);
      case WIl.FileType of
       0: LabelType.Caption:='MIR2 ��ʽ(1)';
       1: LabelType.Caption:='MIR2 ��ʽ(2)';
       2:Begin
         if WIl.OffSet=0 then LabelType.Caption:='EI3 ��ʽ(1)'
         else LabelType.Caption:='EI3 ��ʽ(2)';
       End;
      end;
      LabelColorCount.Caption := '��ɫ('+ IntToStr(Wil.FileColorCount)+')';
      PaintBox1.Refresh;
      if Wil.FileType=2 then Begin
        BtnAllInput.Enabled:=False;
        BtnAllOut.Enabled:=True;
        Btnout.Enabled:=True;
        BtnInput.Enabled:=False;
        BtnAdd.Enabled:=False;
        BtnUp.Enabled:=True;
        BtnDown.Enabled:=True;
        BtnJump.Enabled:=True;
        BtnStop.Enabled:=True;
        BtnAutoPlay.Enabled:=True;
        BtnCreate.Enabled:=True;
        BtnStop.Enabled:=True;
        btndelete.Enabled:=False;
        btnx.Enabled:=False;
        Btny.Enabled:=False;
      End else Begin
        Btnx.Enabled:=True;
        Btny.Enabled:=True;
        btndelete.Enabled:=True;
        BtnUp.Enabled:=True;
        BtnDown.Enabled:=True;
        BtnJump.Enabled:=True;
        BtnStop.Enabled:=True;
        BtnAdd.Enabled:=True;
        BtnAllInput.Enabled:=True;
        BtnAllOut.Enabled:=True;
        BtnAutoPlay.Enabled:=True;
        BtnCreate.Enabled:=True;
        Btnout.Enabled:=True;
        BtnStop.Enabled:=True;
        BtnInput.Enabled:=True;
      End;

      if Index=(WIl.ImageCount-1) then Begin
        BtnDown.Enabled:=False;
        BtnUp.Enabled:=True;
      End;
      if Index=0 then  BtnUp.Enabled:=False;
      DrawGrid1.Row:=BmpIndex div 6;
      Drawgrid1.Col:=BmpIndex mod 6;
  End;
End;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Wil:=TWil.Create(self);
end;

procedure TFrmMain.FormPaint(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFrmMain.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
begin
 if Wil.Stream<>nil then
 Begin
   Wil.DrawZoom(Canvas,Bmpx,Bmpy,BmpINdex,BmpZoom,BmpTran,false);

 End;
 if CheckBoxzuobiao.Checked then
 Begin
   Canvas.Pen.Style:=psDot;
   Canvas.MoveTo(0,Paintbox1.Height div 2);
   Canvas.LineTo(Paintbox1.Width,Paintbox1.Height div 2);
   Canvas.MoveTo(Paintbox1.Width div 2,0);
   Canvas.LineTo(Paintbox1.Width div 2,Paintbox1.Height);
 End;
end;

procedure TFrmMain.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Index:integer;
  w,h:integer;
  str:string;
begin
  index:=ARow*6+ACol;
  if (Wil.Stream<>nil) and (Index<wil.ImageCount) then Begin
    Wil.DrawZoomEx(DrawGrid1.Canvas,Rect,index,true);
    Str:=format('%.5d',[index]);
    DrawGrid1.Canvas.Brush.Style:=bsclear;
    w:=DrawGrid1.Canvas.TextWidth(str);
    h:=DrawGrid1.Canvas.TextHeight(str);
    DrawGrid1.Canvas.TextOut(Rect.Right-w-1,Rect.Bottom-h-1,str);
    if State<>[] then FillInfo(Index);
  End;
end;

procedure TFrmMain.btnupClick(Sender: TObject);
begin
 if Wil.Stream<>nil then Begin
   Dec(BmpIndex);
   if BmpIndex < 0 then BmpIndex:=0;
   FillInfo(BmpIndex);
 end;
end;

procedure TFrmMain.btndownClick(Sender: TObject);
begin
 if Wil.Stream <> nil then Begin
   Inc(BmpIndex);
   if BmpIndex > Wil.ImageCount then  BmpIndex:=Wil.ImageCount;
   FillInfo(BmpIndex);
 End;
end;

procedure TFrmMain.btnxClick(Sender: TObject);
var
  x:smallint;
  code:Integer;
  Str:string;
Begin
  str:= InputDialog.InputBox('����ͼƬ������','������ͼƬ�����꣺','1');
  if str='' then exit;
  val(str,x,code);
  if code > 0 then Begin
     bsSkinMessage1.MessageDlg('��������ȷ�ĸ�ʽ',mtInformation,[mbOK],0);
     exit;
  End;
  Wil.Changex(BmpIndex,x);
  FillInfo(BmpIndex);
end;

procedure TFrmMain.btnyClick(Sender: TObject);
var
  x:smallint;
  code:Integer;
  Str:string;
Begin
  str:= InputDialog.InputBox('����ͼƬ������','������ͼƬ�����꣺','1');
  if str='' then exit;
  val(str,x,code);
  if code > 0 then Begin
     bsSkinMessage1.MessageDlg('��������ȷ�ĸ�ʽ',mtInformation,[mbOK],0);
     exit;
  End;
  Wil.Changey(BmpIndex,x);
  FillInfo(BmpIndex);
end;

procedure TFrmMain.Rb50Click(Sender: TObject);
begin
  FillInfo(BmpIndex);
end;

procedure TFrmMain.BtnJumpClick(Sender: TObject);
var
  Index,Code:Integer;
  str:string;
begin
  if Wil.Stream <> nil then Begin
    str:= InputDialog.InputBox('��ת','������ͼƬ�����ţ�','');
    if str=''	then exit;
    val(str,index,code);
    if (Index>=0) and (Index<Wil.ImageCount) then FillInfo(Index);
  end;
end;

procedure TFrmMain.BtnAutoPlayClick(Sender: TObject);
begin
  Stop:=False;
  Timer1.Enabled:= True;
end;

procedure TFrmMain.btnstopClick(Sender: TObject);
begin
  Stop:= True;
  Timer1.Enabled:= False;
end;

procedure TFrmMain.btninputClick(Sender: TObject);
var
  FileName:String;
  BitMap:TBitMap;
begin
  if OpenPictureDialog1.Execute then FileName:=OpenPictureDialog1.FileName;
  Application.ProcessMessages;

  if (FileName<>'') then Begin
    Image1.Picture.LoadFromFile(FileName);
    BitMap:=Image1.Picture.Bitmap;
  if WIl.ReplaceBitMap(BmpIndex,BitMap) then
     bsSkinMessage1.MessageDlg('����ͼƬ�ɹ���',mtInformation,[mbOK],0)
  else
    bsSkinMessage1.MessageDlg('����ͼƬʧ�ܣ�',mtInformation,[mbOK],0);
  end Else bsSkinMessage1.MessageDlg('����ͼƬʧ�ܣ�',mtInformation,[mbOK],0);
end;

procedure TFrmMain.BtnOutClick(Sender: TObject);
var
  FileName:String;
begin
  if WIl.Stream <> nil then Begin
    SavePictureDialog1.FileName:=format('%.6d.bmp',[BmpIndex]);
    if SavePictureDialog1.Execute then FileName:=SavePictureDialog1.FileName;
    if FileName<>'' then Begin
      Wil.Bitmaps[BmpIndex].SaveToFile(FileName);
      bsSkinMessage1.MessageDlg('����ͼƬ�ɹ���',mtInformation,[mbOK],0)
    end;
  end;
end;

procedure TFrmMain.btndeleteClick(Sender: TObject);
begin
  FormDel := TFormDel.Create(Owner);
  FormDel.ShowModal;
  FormDel.Free;
end;

procedure TFrmMain.btnAddClick(Sender: TObject);
begin
  if Wil.Stream <> nil then begin
    FrmAddOneWil := TFrmAddOneWil.Create(Owner);
    FrmAddOneWil.ShowModal;
    FrmAddOneWil.Free;
  end;
end;

procedure TFrmMain.btnCreateClick(Sender: TObject);
begin
  FrmNewWil := TFrmNewWil.Create(Owner);
  FrmNewWil.ShowModal;
  FrmNewWil.Free;
end;

procedure TFrmMain.btnallinputClick(Sender: TObject);
begin
  if WIl.Stream <> nil then begin
     FrmAddWil := TFrmAddWil.Create(Owner);
     FrmAddWil.EditEnd.Text:=Inttostr(Wil.ImageCount-1);
     FrmAddWil.EditPicPath.Text:='';
     FrmAddWil.ShowModal;
     FrmAddWil.Free;
  end;
end;

procedure TFrmMain.btnallOutClick(Sender: TObject);
begin
 if WIl.Stream <> nil then Begin
    FrmOutWil := TFrmOutWil.Create(Owner);
    FrmOutWil.EditPicPath.Text:='';
    FrmOutWil.editBegin.Text:='0';
    FrmOutWil.EditEnd.Text:=Inttostr(wil.ImageCount-1);
    FrmOutWil.ShowModal;
    FrmOutWil.Free;
 end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  if (BmpIndex >= WIl.ImageCount-1) or Stop then Timer1.Enabled:=False;
  Inc(BmpIndex);
  FillInfo(BmpIndex);
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  application.Terminate;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FrmMain:= nil;
  application.Terminate;
end;

procedure TFrmMain.EditFileNameButtonClick(Sender: TObject);
  function SaveConfig: Boolean;
  var
    MyIni: TIniFile;
  begin
    Result := False;
    MyIni:= TIniFile.Create(ConfigFileName);
    MyIni.WriteString('SYSTEM','WilDirectory',sWilDirectory);
    MyIni.Free;
    Result := True;
  end;
begin
  OpenDialog1.Filter := 'Wil�ļ�(*.Wil)|*.Wil';
  OpenDialog1.InitialDir := sWilDirectory;
  if OpenDialog1.Execute then begin
    EditFileName.Text:= OPenDialog1.FileName;
    sWilDirectory:= ExtractFilePath(EditFileName.Text);
    SaveConfig;
    if FileExists(EditFileName.Text) then begin
      if Wil.Stream<>nil then Wil.Finalize;
      Wil.FileName:=EditFileName.Text;
      Wil.Initialize;
      if wil.Stream= nil then begin
         bsSkinMessage1.MessageDlg('WIl�ļ��Ѿ����ƻ�����wil�ļ���',mtInformation,[mbOK],0);
         Exit;
      end;
      BmpIndex:=0;
      DrawGrid1.RowCount:=(Wil.ImageCount div 6)+1;
      DrawGrid1.Refresh;
      FillInfo(BmpIndex);
    end;
  end;
end;

procedure TFrmMain.bsSkinFileEdit1ButtonClick(Sender: TObject);
begin
  if bsSkinSelectDirectoryDialog1.Execute then begin
    bsSkinFileEdit1.Text:= bsSkinSelectDirectoryDialog1.Directory;
    if bsSkinFileEdit1.Text <> '' then bsSkinButton1.Enabled:= True;
  end;
end;
//��Ʒ���ݿ���չ 20080619
procedure TFrmMain.bsSkinButton1Click(Sender: TObject);
  function GetParadoxConnectionString(Path: string; Password: string): string;
  var
    s: string;
  begin
    s := 'Provider=Microsoft.Jet.OLEDB.4.0;';
    s := s + 'Data Source=' + Path + ';';
    s := s + 'Extended Properties=Paradox 7.x;Persist Security Info=False;';
    s := s + 'Mode=Share Deny None;';
    if Password <> '' then
      s := s + 'Jet OLEDB:Database Password=' + Password;
    Result := s;
  end;
var
  DestTable:TTable;
  ADOA: TAdoquery;
  I: Integer;
begin
  bsSkinCheckRadioBox4.Enabled := False;
  DestTable:=TTable.Create(Application);
  try
    FrmDM.TableStdItems.Open;
    with DestTable do begin
      FieldDefs.Assign(FrmDM.TableStdItems.FieldDefs);//���Ʊ�ṹ
      DataBaseName:= bsSkinFileEdit1.text;//����·��
      TableName:='NewStdItems';//���ݿ���
      TableType:=ttParadox;//���ݿ�����
      CreateTable;//�����µ����ݱ�
    end;

    if FrmDM.TableStdItems.findfield('Desc') = nil  then begin//�ж��ֶ��Ƿ����
      ADOA:=TADOQUERY.Create(nil);
      with ADOA do begin
        ConnectionString:=GetParadoxConnectionString(bsSkinFileEdit1.text,'');
        SQL.Add('ALTER TABLE NewStdItems ADD [Desc] CHAR(80)');
        ExecSQL;
      end;
      ADOA.Free;
    end;

    DestTable.Open;
    FrmDM.Query1.DataBaseName:=DBEName;
    with FrmDM.Query1 do begin
      close;
      sql.Clear ;
      sql.add('select * from StdItems order by idx  DESC');
      open;
      First;
      I:= FrmDM.Query1.RecordCount - 1;
      while not FrmDM.Query1.Eof do begin
        with DestTable  do begin
          Insert;
          if boIsSort then FieldByName('Idx').AsInteger:= I
          else FieldByName('Idx').AsInteger:= FrmDM.Query1.FieldByName('Idx').AsInteger;
          FieldByName('Name').AsString:=FrmDM.Query1.FieldByName('Name').AsString;
          FieldByName('StdMode').AsInteger:=FrmDM.Query1.FieldByName('StdMode').AsInteger;
          FieldByName('Shape').AsInteger:=FrmDM.Query1.FieldByName('Shape').AsInteger;//װ�����
          FieldByName('Weight').AsInteger:=FrmDM.Query1.FieldByName('Weight').AsInteger;//����
          FieldByName('AniCount').AsInteger:= FrmDM.Query1.FieldByName('AniCount').AsInteger;
          FieldByName('Source').AsInteger:= FrmDM.Query1.FieldByName('Source').AsInteger;
          FieldByName('Reserved').AsInteger:= FrmDM.Query1.FieldByName('Reserved').AsInteger;//����
          FieldByName('Looks').AsInteger:= FrmDM.Query1.FieldByName('Looks').AsInteger;//��Ʒ���
          FieldByName('DuraMax').AsInteger:= FrmDM.Query1.FieldByName('DuraMax').AsInteger;
          FieldByName('Ac').AsInteger:=FrmDM.Query1.FieldByName('Ac').AsInteger;
          FieldByName('Ac2').AsString:=FrmDM.Query1.FieldByName('Ac2').AsString;
          FieldByName('Mac').AsInteger:=FrmDM.Query1.FieldByName('Mac').AsInteger;
          FieldByName('Mac2').AsInteger:=FrmDM.Query1.FieldByName('Mac2').AsInteger;
          FieldByName('Dc').AsInteger:=FrmDM.Query1.FieldByName('Dc').AsInteger;
          FieldByName('DC2').AsInteger:= FrmDM.Query1.FieldByName('DC2').AsInteger;
          FieldByName('Mc').AsInteger:= FrmDM.Query1.FieldByName('Mc').AsInteger;
          FieldByName('Mc2').AsInteger:= FrmDM.Query1.FieldByName('Mc2').AsInteger;
          FieldByName('Sc').AsInteger:= FrmDM.Query1.FieldByName('Sc').AsInteger;
          FieldByName('Sc2').AsInteger:= FrmDM.Query1.FieldByName('Sc2').AsInteger;
          FieldByName('Need').AsInteger:= FrmDM.Query1.FieldByName('Need').AsInteger;
          FieldByName('NeedLevel').AsInteger:= FrmDM.Query1.FieldByName('NeedLevel').AsInteger;
          FieldByName('Stock').AsInteger:= FrmDM.Query1.FieldByName('Stock').AsInteger;
          FieldByName('Price').AsInteger:= FrmDM.Query1.FieldByName('Price').AsInteger;
          post;
          if boIsSort then Dec(I);
        end;
        FrmDM.Query1.Next;
      end;
    end;
  finally
    DestTable.Free;
  end;
  bsSkinMessage1.MessageDlg('��Ʒ���ݿ���չ��ɣ�'+bsSkinFileEdit1.text+'\NewStdItems.db',mtInformation,[mbOK],0);
  bsSkinButton1.Enabled:= False;
  bsSkinCheckRadioBox4.Enabled := True;
end;

procedure TFrmMain.bsSkinCheckRadioBox4Click(Sender: TObject);
begin
  boIsSort:= bsSkinCheckRadioBox4.Checked;
end;

procedure TFrmMain.bsSkinTabSheet2Show(Sender: TObject);
begin
  boIsSort:= bsSkinCheckRadioBox4.Checked;
end;

procedure TFrmMain.bsSkinTabSheet7Show(Sender: TObject);
begin
          ListBoxFongHaoHint.Clear;
          ListBoxFongHaoHint.Items.Add('0=һ��ƺ�');
          ListBoxFongHaoHint.Items.Add('1=ˮ��֮��(���ǧ�ﴫ��)');
          ListBoxFongHaoHint.Items.Add('2=��������');
          ListBoxFongHaoHint.Items.Add('3=����ʹ��');
          ListBoxFongHaoHint.Items.Add('4=������ɽ(��ײ����+10��)');
          ListBoxFongHaoHint.Items.Add('5=�۷���ʿ(�����������,����3�λ�0��ʱ״̬��ʧ');
          ListBoxFongHaoHint.Items.Add('           ʱ��������Ч DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('6=��Ѫʹ��(���(Ϊ�ӳ�),ͬ��ͼʱ���ж�Ա��־��鷭��)');
          ListBoxFongHaoHint.Items.Add('7=����֮��(ħ����,�һ𽣷�,��ʥս����,����ܱ�ɷۺ�ɫ)');
          ListBoxFongHaoHint.Items.Add('8=�л�֮��(�˳��л�ƺ���ʧ)');
          ListBoxFongHaoHint.Items.Add('9=�귨������(���⴫�͵�ͼ)');
          ListBoxFongHaoHint.Items.Add('10=�߼��۷���ʿ(�����������,����������������');
          ListBoxFongHaoHint.Items.Add('                DC=��ͱ��� DC2-��߱���)');
          ListBoxFongHaoHint.Items.Add('11=0����ʧ�ƺ�(ʱ��������Ч)');
          MemoFongHaoHint.Clear;
          MemoFongHaoHint.Lines.Text := 'Shape  =Ԥ��'+#13+
                                        'Anicount=�ƺ�����Ч��'+#13+
                                        'nHours =�ƺ�ʱ��(Сʱ) 65535-����'+#13+
                                        'Looks  =�ƺŵ��ڹ�'+#13+
                                        'AC     =��������'+#13+
                                        'AC2    =ǿ��ȼ�'+#13+
                                        'MAC    =���˵ȼ�'+#13+
                                        'MAC2   =�����ȼ�'+#13+
                                        'DC     =��Կ���'+#13+
                                        'DC2    =��������'+#13+
                                        'MC     =��ħ�ȼ�'+#13+
                                        'MC2    =ħ������'+#13+
                                        'SC     =�ϻ�����'+#13+
                                        'SC2    =��������'+#13+#13+
                                        'Need(��������)'+#13+
                                        '0:��ȼ�   NeedLevel=�ȼ�'+#13+
                                        '1:�蹥���� NeedLevel=������'+#13+
                                        '2:��ħ��   NeedLevel=ħ��'+#13+
                                        '3:�����   NeedLevel=����';
end;

procedure TFrmMain.bsSkinButton2Click(Sender: TObject);
  function GetParadoxConnectionString(Path: string; Password: string): string;
  var
    s: string;
  begin
    s := 'Provider=Microsoft.Jet.OLEDB.4.0;';
    s := s + 'Data Source=' + Path + ';';
    s := s + 'Extended Properties=Paradox 7.x;Persist Security Info=False;';
    s := s + 'Mode=Share Deny None;';
    if Password <> '' then
      s := s + 'Jet OLEDB:Database Password=' + Password;
    Result := s;
  end;
var
  DestTable:TTable;
  KK: TFieldDef;
begin
  DestTable:=TTable.Create(Application);
  try
    FrmDM.TableMonster.Open;
    with DestTable do begin
      FieldDefs.Assign(FrmDM.TableMonster.FieldDefs);//���Ʊ�ṹ
      DataBaseName:= bsSkinFileEdit2.text;//����·��
      KK:= FieldDefs.Find('HP');
      KK.DataType:= ftInteger;//�޸�HPΪInteger����
      TableName:='NewMonster';//���ݿ���
      TableType:=ttParadox;//���ݿ�����
      CreateTable;//�����µ����ݱ�
    end;

    DestTable.Open;
    FrmDM.Query1.DataBaseName:=DBEName;
    with FrmDM.Query1 do begin
      close;
      sql.Clear ;
      sql.add('select * from Monster order by Name DESC');
      open;
      First;
      //I:= FrmDM.Query1.RecordCount - 1;
      while not FrmDM.Query1.Eof do begin
        with DestTable  do begin
          Insert;
          FieldByName('Name').AsString:=FrmDM.Query1.FieldByName('Name').AsString;
          FieldByName('Race').AsInteger:=FrmDM.Query1.FieldByName('Race').AsInteger;
          FieldByName('RaceImg').AsInteger:=FrmDM.Query1.FieldByName('RaceImg').AsInteger;
          FieldByName('Appr').AsInteger:=FrmDM.Query1.FieldByName('Appr').AsInteger;
          FieldByName('Lvl').AsInteger:= FrmDM.Query1.FieldByName('Lvl').AsInteger;
          FieldByName('Undead').AsInteger:= FrmDM.Query1.FieldByName('Undead').AsInteger;
          FieldByName('CoolEye').AsInteger:= FrmDM.Query1.FieldByName('CoolEye').AsInteger;
          FieldByName('Exp').AsInteger:= FrmDM.Query1.FieldByName('Exp').AsInteger;
          FieldByName('HP').AsInteger:= FrmDM.Query1.FieldByName('HP').AsInteger;
          FieldByName('MP').AsInteger:=FrmDM.Query1.FieldByName('MP').AsInteger;
          FieldByName('AC').AsString:=FrmDM.Query1.FieldByName('AC').AsString;
          FieldByName('MAC').AsInteger:=FrmDM.Query1.FieldByName('MAC').AsInteger;
          FieldByName('DC').AsInteger:=FrmDM.Query1.FieldByName('DC').AsInteger;
          FieldByName('DCMAX').AsInteger:=FrmDM.Query1.FieldByName('DCMAX').AsInteger;
          FieldByName('MC').AsInteger:= FrmDM.Query1.FieldByName('MC').AsInteger;
          FieldByName('SC').AsInteger:= FrmDM.Query1.FieldByName('SC').AsInteger;
          FieldByName('SPEED').AsInteger:= FrmDM.Query1.FieldByName('SPEED').AsInteger;
          FieldByName('HIT').AsInteger:= FrmDM.Query1.FieldByName('HIT').AsInteger;
          FieldByName('WALK_SPD').AsInteger:= FrmDM.Query1.FieldByName('WALK_SPD').AsInteger;
          FieldByName('WalkStep').AsInteger:= FrmDM.Query1.FieldByName('WalkStep').AsInteger;
          FieldByName('WalkWait').AsInteger:= FrmDM.Query1.FieldByName('WalkWait').AsInteger;
          FieldByName('ATTACK_SPD').AsInteger:= FrmDM.Query1.FieldByName('ATTACK_SPD').AsInteger;
          post;
        end;
        FrmDM.Query1.Next;
      end;
    end;
  finally
    DestTable.Free;
  end;
  bsSkinMessage1.MessageDlg('���ݿ���չ��ɣ�'+bsSkinFileEdit2.text+'\NewMonster.db',mtInformation,[mbOK],0);

end;

procedure TFrmMain.bsSkinFileEdit2ButtonClick(Sender: TObject);
begin
  if bsSkinSelectDirectoryDialog1.Execute then begin
    bsSkinFileEdit2.Text:= bsSkinSelectDirectoryDialog1.Directory;
    if bsSkinFileEdit2.Text <> '' then bsSkinButton2.Enabled:= True;
  end;
end;

function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
const
  BUF_SIZE = 20480; //$7FFF;
var
  buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, srclen, I, ArrCount: LongInt;
  Ch: Char;
label
  CATCH_DIV;
begin
  Ch := #0; //Jacky
  try
    srclen := Length(Str);
    BufCount := 0;
    Count := 1;

    if srclen >= BUF_SIZE - 1 then begin
      Result := '';
      Dest := '';
      Exit;
    end;

    if Str = '' then begin
      Dest := '';
      Result := Str;
      Exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do begin
      if Count <= srclen then begin
        Ch := Str[Count];
        for I := 0 to ArrCount - 1 do
          if Ch = Divider[I] then
            goto CATCH_DIV;
      end;
      if (Count > srclen) then begin
        CATCH_DIV:
        if (BufCount > 0) then begin
          if BufCount < BUF_SIZE - 1 then begin
            buf[BufCount] := #0;
            Dest := string(buf);
            Result := Copy(Str, Count + 1, srclen - Count);
          end;
          Break;
        end else begin
          if (Count > srclen) then begin
            Dest := '';
            Result := Copy(Str, Count + 2, srclen - 1);
            Break;
          end;
        end;
      end else begin
        if BufCount < BUF_SIZE - 1 then begin
          buf[BufCount] := Ch;
          Inc(BufCount);
        end;
      end;
      Inc(Count);
    end;
  except
    Dest := '';
    Result := '';
  end;
end;

function Str_ToInt(Str: string; Def: LongInt): LongInt;
begin
  Result := Def;
  if Str <> '' then begin
    if ((Word(Str[1]) >= Word('0')) and (Word(Str[1]) <= Word('9'))) or
      (Str[1] = '+') or (Str[1] = '-') then try
      Result := StrToInt64(Str);
    except
    end;
  end;
end;

procedure TFrmMain.bsSkinButton3Click(Sender: TObject);
var
  LoadList:TStringList;
  sLineText:String;
  sIdx, sName, sStdMode, sShape, sWeight, sAniCount, sSource, sReserved, sLooks: string;
  sDuraMax, sAc, sAc2, sMac, sMac2, sDc, sDC2, sMc, sMc2, sSc, sSc2, sNeed, sNeedLevel, sStock, sPrice:string;
  I, Idx:integer;
begin
  OpenDialog1.Filter := 'Text�ļ�(*.txt)|*.txt';
  with OpenDialog1 do begin
    if Execute then begin
      if FileExists(FileName) then begin
        LoadList:=TStringList.Create;
        LoadList.LoadFromFile(FileName);
        try
          Idx:= FrmDM.TableStdItems.RecordCount;
          for I := 0 to LoadList.Count - 1 do begin
            sLineText:= Trim(LoadList.Strings[I]);
            if (sLineText <> '') and (sLineText[1] <> ';') then begin
              sLineText := GetValidStr3(sLineText, sIdx, [';']);
              sLineText := GetValidStr3(sLineText, sName, [';']);
              sLineText := GetValidStr3(sLineText, sStdMode, [';']);
              sLineText := GetValidStr3(sLineText, sShape, [';']);
              sLineText := GetValidStr3(sLineText, sWeight, [';']);
              sLineText := GetValidStr3(sLineText, sAniCount, [';']);
              sLineText := GetValidStr3(sLineText, sSource, [';']);
              sLineText := GetValidStr3(sLineText, sReserved, [';']);
              sLineText := GetValidStr3(sLineText, sLooks, [';']);
              sLineText := GetValidStr3(sLineText, sDuraMax, [';']);
              sLineText := GetValidStr3(sLineText, sAc, [';']);
              sLineText := GetValidStr3(sLineText, sAc2, [';']);
              sLineText := GetValidStr3(sLineText, sMac, [';']);
              sLineText := GetValidStr3(sLineText, sMac2, [';']);
              sLineText := GetValidStr3(sLineText, sDc, [';']);
              sLineText := GetValidStr3(sLineText, sDC2, [';']);
              sLineText := GetValidStr3(sLineText, sMc, [';']);
              sLineText := GetValidStr3(sLineText, sMc2, [';']);
              sLineText := GetValidStr3(sLineText, sSc, [';']);
              sLineText := GetValidStr3(sLineText, sSc2, [';']);
              sLineText := GetValidStr3(sLineText, sNeed, [';']);
              sLineText := GetValidStr3(sLineText, sNeedLevel, [';']);
              sLineText := GetValidStr3(sLineText, sPrice, [';']);
              sLineText := GetValidStr3(sLineText, sStock, [';']);


              if sName <> '' then begin
                with FrmDM.TableStdItems do begin//д�����ݿ�
                  Append;
                  FieldByName('Idx').AsInteger:= Idx;
                  FieldByName('Name').AsString:= sName;
                  FieldByName('StdMode').AsInteger:=Str_ToInt( sStdMode, 0);
                  FieldByName('Shape').AsInteger:=Str_ToInt( sShape, 0);//װ�����
                  FieldByName('Weight').AsInteger:=Str_ToInt( sWeight, 0);//����
                  FieldByName('AniCount').AsInteger:= Str_ToInt( sAniCount, 0);
                  FieldByName('Source').AsInteger:= Str_ToInt( sSource, 0);
                  FieldByName('Reserved').AsInteger:= Str_ToInt( sReserved, 0);//����
                  FieldByName('Looks').AsInteger:= Str_ToInt( sLooks, 0);//��Ʒ���
                  FieldByName('DuraMax').AsInteger:= Str_ToInt( sDuraMax, 0);
                  FieldByName('Ac').AsInteger:= Str_ToInt( sAc, 0);
                  FieldByName('Ac2').AsInteger:= Str_ToInt( sAc2, 0);
                  FieldByName('Mac').AsInteger:= Str_ToInt( sMac, 0);
                  FieldByName('Mac2').AsInteger:= Str_ToInt( sMac2, 0);
                  FieldByName('Dc').AsInteger:= Str_ToInt( sDc, 0);
                  FieldByName('DC2').AsInteger:= Str_ToInt( sDC2, 0);
                  FieldByName('Mc').AsInteger:= Str_ToInt( sMc, 0);
                  FieldByName('Mc2').AsInteger:= Str_ToInt( sMc2, 0);
                  FieldByName('Sc').AsInteger:= Str_ToInt( sSc, 0);
                  FieldByName('Sc2').AsInteger:= Str_ToInt( sSc2, 0);
                  FieldByName('Need').AsInteger:= Str_ToInt( sNeed, 0);
                  FieldByName('NeedLevel').AsInteger:= Str_ToInt( sNeedLevel, 0);
                  FieldByName('Stock').AsInteger:= Str_ToInt( sStock, 0);
                  FieldByName('Price').AsInteger:= Str_ToInt( sPrice, 0);
                  post;
                  Inc(Idx);
                  Application.ProcessMessages;//���ÿ���Ȩ����windows��������
                end;
              end;
            end;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.bsSkinButton18Click(Sender: TObject);
var
  LoadList:TStringList;
  sLineText:String;
  sIdx, sName, sStdMode, sShape, sAniCount, sHours, sLooks: string;
  sDuraMax, sAc, sAc2, sMac, sMac2, sDc, sDC2, sMc, sMc2, sSc, sSc2, sNeed, sNeedLevel, sStock:string;
  I, Idx:integer;
begin
  OpenDialog1.Filter := 'Text�ļ�(*.txt)|*.txt';
  with OpenDialog1 do begin
    if Execute then begin
      if FileExists(FileName) then begin
        LoadList:=TStringList.Create;
        LoadList.LoadFromFile(FileName);
        try
          Idx:= FrmDM.TableFongHao.RecordCount;
          for I := 0 to LoadList.Count - 1 do begin
            sLineText:= Trim(LoadList.Strings[I]);
            if (sLineText <> '') and (sLineText[1] <> ';') then begin
              sLineText := GetValidStr3(sLineText, sIdx, [';']);
              sLineText := GetValidStr3(sLineText, sName, [';']);
              sLineText := GetValidStr3(sLineText, sStdMode, [';']);
              sLineText := GetValidStr3(sLineText, sShape, [';']);
              sLineText := GetValidStr3(sLineText, sAniCount, [';']);
              sLineText := GetValidStr3(sLineText, sHours, [';']);
              sLineText := GetValidStr3(sLineText, sLooks, [';']);
              sLineText := GetValidStr3(sLineText, sDuraMax, [';']);
              sLineText := GetValidStr3(sLineText, sAc, [';']);
              sLineText := GetValidStr3(sLineText, sAc2, [';']);
              sLineText := GetValidStr3(sLineText, sMac, [';']);
              sLineText := GetValidStr3(sLineText, sMac2, [';']);
              sLineText := GetValidStr3(sLineText, sDc, [';']);
              sLineText := GetValidStr3(sLineText, sDC2, [';']);
              sLineText := GetValidStr3(sLineText, sMc, [';']);
              sLineText := GetValidStr3(sLineText, sMc2, [';']);
              sLineText := GetValidStr3(sLineText, sSc, [';']);
              sLineText := GetValidStr3(sLineText, sSc2, [';']);
              sLineText := GetValidStr3(sLineText, sNeed, [';']);
              sLineText := GetValidStr3(sLineText, sNeedLevel, [';']);
              sLineText := GetValidStr3(sLineText, sStock, [';']);

              if sName <> '' then begin
                with FrmDM.TableFongHao do begin//д�����ݿ�
                  Append;
                  FieldByName('Idx').AsInteger:= Idx;
                  FieldByName('Name').AsString:= sName;
                  FieldByName('StdMode').AsInteger:=Str_ToInt( sStdMode, 0);
                  FieldByName('Shape').AsInteger:=Str_ToInt( sShape, 0);//װ�����
                  FieldByName('AniCount').AsInteger:= Str_ToInt( sAniCount, 0);
                  FieldByName('Hours').AsInteger:= Str_ToInt( sHours, 0);//ʹ����(Сʱ)
                  FieldByName('Looks').AsInteger:= Str_ToInt( sLooks, 0);//��Ʒ���
                  FieldByName('DuraMax').AsInteger:= Str_ToInt( sDuraMax, 0);
                  FieldByName('Ac').AsInteger:= Str_ToInt( sAc, 0);
                  FieldByName('Ac2').AsInteger:= Str_ToInt( sAc2, 0);
                  FieldByName('Mac').AsInteger:= Str_ToInt( sMac, 0);
                  FieldByName('Mac2').AsInteger:= Str_ToInt( sMac2, 0);
                  FieldByName('Dc').AsInteger:= Str_ToInt( sDc, 0);
                  FieldByName('DC2').AsInteger:= Str_ToInt( sDC2, 0);
                  FieldByName('Mc').AsInteger:= Str_ToInt( sMc, 0);
                  FieldByName('Mc2').AsInteger:= Str_ToInt( sMc2, 0);
                  FieldByName('Sc').AsInteger:= Str_ToInt( sSc, 0);
                  FieldByName('Sc2').AsInteger:= Str_ToInt( sSc2, 0);
                  FieldByName('Need').AsInteger:= Str_ToInt( sNeed, 0);
                  FieldByName('NeedLevel').AsInteger:= Str_ToInt( sNeedLevel, 0);
                  FieldByName('Stock').AsInteger:= Str_ToInt( sStock, 0);
                  post;
                  Inc(Idx);
                  Application.ProcessMessages;//���ÿ���Ȩ����windows��������
                end;
              end;
            end;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.bsSkinButton4Click(Sender: TObject);
var
  LoadList:TStringList;
  sLineText:String;
  sName, sRace, sRaceImg, sAppr, sLvl, sUndead, sCoolEye, sExp, sHP, sMP, sAC: string;
  sMAC, sDC, sDCMAX, sMC, sSC, sSPEED, sHIT, sWALK_SPD, sWalkStep, sWalkWait, sATTACK_SPD: string;
  I:integer;
begin
  OpenDialog1.Filter := 'Text�ļ�(*.txt)|*.txt';
  with OpenDialog1 do begin
    if Execute then begin
      if FileExists(FileName) then begin
        LoadList:=TStringList.Create;
        LoadList.LoadFromFile(FileName);
        try
          for I := 0 to LoadList.Count - 1 do begin
            sLineText:= Trim(LoadList.Strings[I]);
            if (sLineText <> '') and (sLineText[1] <> ';') then begin
              sLineText := GetValidStr3(sLineText, sName, [';']);
              sLineText := GetValidStr3(sLineText, sRace, [';']);
              sLineText := GetValidStr3(sLineText, sRaceImg, [';']);
              sLineText := GetValidStr3(sLineText, sAppr, [';']);
              sLineText := GetValidStr3(sLineText, sLvl, [';']);
              sLineText := GetValidStr3(sLineText, sUndead, [';']);
              sLineText := GetValidStr3(sLineText, sCoolEye, [';']);
              sLineText := GetValidStr3(sLineText, sExp, [';']);
              sLineText := GetValidStr3(sLineText, sHP, [';']);
              sLineText := GetValidStr3(sLineText, sMP, [';']);
              sLineText := GetValidStr3(sLineText, sAC, [';']);
              sLineText := GetValidStr3(sLineText, sMAC, [';']);
              sLineText := GetValidStr3(sLineText, sDC, [';']);
              sLineText := GetValidStr3(sLineText, sDCMAX, [';']);
              sLineText := GetValidStr3(sLineText, sMC, [';']);
              sLineText := GetValidStr3(sLineText, sSC, [';']);
              sLineText := GetValidStr3(sLineText, sSPEED, [';']);
              sLineText := GetValidStr3(sLineText, sHIT, [';']);
              sLineText := GetValidStr3(sLineText, sWALK_SPD, [';']);
              sLineText := GetValidStr3(sLineText, sWalkStep, [';']);
              sLineText := GetValidStr3(sLineText, sWalkWait, [';']);
              sLineText := GetValidStr3(sLineText, sATTACK_SPD, [';']);

              if sName <> '' then begin
                with FrmDM.TableMonster do begin//д�����ݿ�
                  Append;
                  FieldByName('Name').AsString:= sName;
                  FieldByName('Race').AsInteger:= Str_ToInt( sRace, 0);
                  FieldByName('RaceImg').AsInteger:= Str_ToInt( sRaceImg, 0);
                  FieldByName('Appr').AsInteger:= Str_ToInt( sAppr, 0);
                  FieldByName('Lvl').AsInteger:= Str_ToInt( sLvl, 0);
                  FieldByName('Undead').AsInteger:= Str_ToInt( sUndead, 0);
                  FieldByName('CoolEye').AsInteger:= Str_ToInt( sCoolEye, 0);
                  FieldByName('Exp').AsInteger:= Str_ToInt( sExp, 0);
                  FieldByName('HP').AsInteger:= Str_ToInt( sHP, 0);
                  FieldByName('MP').AsInteger:= Str_ToInt( sMP, 0);
                  FieldByName('AC').AsInteger:= Str_ToInt( sAC, 0);
                  FieldByName('MAC').AsInteger:= Str_ToInt( sMAC, 0);
                  FieldByName('DC').AsInteger:= Str_ToInt( sDC, 0);
                  FieldByName('DCMAX').AsInteger:= Str_ToInt( sDCMAX, 0);
                  FieldByName('MC').AsInteger:= Str_ToInt( sMC, 0);
                  FieldByName('SC').AsInteger:= Str_ToInt( sSC, 0);
                  FieldByName('SPEED').AsInteger:= Str_ToInt( sSPEED, 0);
                  FieldByName('HIT').AsInteger:= Str_ToInt( sHIT, 0);
                  FieldByName('WALK_SPD').AsInteger:= Str_ToInt( sWALK_SPD, 0);
                  FieldByName('WalkStep').AsInteger:= Str_ToInt( sWalkStep, 0);
                  FieldByName('WalkWait').AsInteger:= Str_ToInt( sWalkWait, 0);
                  FieldByName('ATTACK_SPD').AsInteger:= Str_ToInt( sATTACK_SPD, 0);
                  post;
                  Application.ProcessMessages;//���ÿ���Ȩ����windows��������
                end;
              end;
            end;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.bsSkinButton5Click(Sender: TObject);
var
  LoadList:TStringList;
  sLineText:String;
  sMagId,sMagName,sEffectType,sEffect,sSpell,sPower,sMaxPower,sJob: string;
  sNeedL1,sNeedL2,sNeedL3,sL1Train,sL2Train,sL3Train,sDelay,sDefSpell,sDefPower,sDefMaxPower,sDescr: string;
  I:integer;
begin
  OpenDialog1.Filter := 'Text�ļ�(*.txt)|*.txt';
  with OpenDialog1 do begin
    if Execute then begin
      if FileExists(FileName) then begin
        LoadList:=TStringList.Create;
        LoadList.LoadFromFile(FileName);
        try
          for I := 0 to LoadList.Count - 1 do begin
            sLineText:= Trim(LoadList.Strings[I]);
            if (sLineText <> '') and (sLineText[1] <> ';') then begin
              sLineText := GetValidStr3(sLineText, sMagId, [';']);
              sLineText := GetValidStr3(sLineText, sMagName, [';']);
              sLineText := GetValidStr3(sLineText, sEffectType, [';']);
              sLineText := GetValidStr3(sLineText, sEffect, [';']);
              sLineText := GetValidStr3(sLineText, sSpell, [';']);
              sLineText := GetValidStr3(sLineText, sPower, [';']);
              sLineText := GetValidStr3(sLineText, sMaxPower, [';']);
              sLineText := GetValidStr3(sLineText, sDefSpell, [';']);
              sLineText := GetValidStr3(sLineText, sDefPower, [';']);
              sLineText := GetValidStr3(sLineText, sDefMaxPower, [';']);
              sLineText := GetValidStr3(sLineText, sJob, [';']);
              sLineText := GetValidStr3(sLineText, sNeedL1, [';']);
              sLineText := GetValidStr3(sLineText, sL1Train, [';']);
              sLineText := GetValidStr3(sLineText, sNeedL2, [';']);
              sLineText := GetValidStr3(sLineText, sL2Train, [';']);
              sLineText := GetValidStr3(sLineText, sNeedL3, [';']);
              sLineText := GetValidStr3(sLineText, sL3Train, [';']);
              sLineText := GetValidStr3(sLineText, sDelay, [';']);
              sLineText := GetValidStr3(sLineText, sDescr, [';']);

              if sMagName <> '' then begin
                with FrmDM.TableMagic do begin//д�����ݿ�
                  Append;
                  FieldByName('MagId').AsInteger:= Str_ToInt( sMagId, 0);
                  FieldByName('MagName').AsString:= sMagName;
                  FieldByName('EffectType').AsInteger:= Str_ToInt( sEffectType, 0);
                  FieldByName('Effect').AsInteger:= Str_ToInt( sEffect, 0);
                  FieldByName('Spell').AsInteger:= Str_ToInt( sSpell, 0);
                  FieldByName('Power').AsInteger:= Str_ToInt( sPower, 0);
                  FieldByName('MaxPower').AsInteger:= Str_ToInt( sMaxPower, 0);


                  FieldByName('Job').AsInteger:= Str_ToInt( sJob, 0);
                  FieldByName('NeedL1').AsInteger:= Str_ToInt( sNeedL1, 0);
                  FieldByName('NeedL2').AsInteger:= Str_ToInt( sNeedL2, 0);
                  FieldByName('NeedL3').AsInteger:= Str_ToInt( sNeedL3, 0);
                  FieldByName('L1Train').AsInteger:= Str_ToInt( sL1Train, 0);
                  FieldByName('L2Train').AsInteger:= Str_ToInt( sL2Train, 0);
                  FieldByName('L3Train').AsInteger:= Str_ToInt( sL3Train, 0);
                  FieldByName('Delay').AsInteger:= Str_ToInt( sDelay, 0);
                  FieldByName('DefSpell').AsInteger:= Str_ToInt( sDefSpell, 0);
                  FieldByName('DefPower').AsInteger:= Str_ToInt( sDefPower, 0);
                  FieldByName('DefMaxPower').AsInteger:= Str_ToInt( sDefMaxPower, 0);
                  FieldByName('Descr').AsString:= sDescr;
                  post;
                  Application.ProcessMessages;//���ÿ���Ȩ����windows��������
                end;
              end;
            end;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.bsSkinButton6Click(Sender: TObject);
  function GetParadoxConnectionString(Path: string; Password: string): string;
  var
    s: string;
  begin
    s := 'Provider=Microsoft.Jet.OLEDB.4.0;';
    s := s + 'Data Source=' + Path + ';';
    s := s + 'Extended Properties=Paradox 7.x;Persist Security Info=False;';
    s := s + 'Mode=Share Deny None;';
    if Password <> '' then
      s := s + 'Jet OLEDB:Database Password=' + Password;
    Result := s;
  end;
var
  DestTable:TTable;
  KK: TFieldDef;
begin
  DestTable:= TTable.Create(Application);
  try
    FrmDM.TableMagic.Open;
    with DestTable do begin
      FieldDefs.Assign(FrmDM.TableMagic.FieldDefs);//���Ʊ�ṹ
      DataBaseName:= bsSkinFileEdit3.text;//����·��
      KK:= FieldDefs.Find('MagName');
      KK.DataType:= ftString;//�޸�MagNameΪstring����
      KK.Size:= 18;//��չ����
      TableName:='NewMagic';//���ݿ���
      TableType:=ttParadox;//���ݿ�����
      CreateTable;//�����µ����ݱ�
    end;

    DestTable.Open;
    FrmDM.Query1.DataBaseName:=DBEName;
    with FrmDM.Query1 do begin
      close;
      sql.Clear ;
      sql.add('select * from Magic order by Descr,MagId DESC');
      open;
      First;
      while not FrmDM.Query1.Eof do begin
        with DestTable do begin
          Insert;
          FieldByName('MagId').AsInteger := FrmDM.Query1.FieldByName('MagId').AsInteger;
          FieldByName('MagName').AsString := FrmDM.Query1.FieldByName('MagName').AsString;
          FieldByName('EffectType').AsInteger := FrmDM.Query1.FieldByName('EffectType').AsInteger;
          FieldByName('Effect').AsInteger := FrmDM.Query1.FieldByName('Effect').AsInteger;
          FieldByName('Spell').AsInteger := FrmDM.Query1.FieldByName('Spell').AsInteger;
          FieldByName('Power').AsInteger := FrmDM.Query1.FieldByName('Power').AsInteger;
          FieldByName('MaxPower').AsInteger := FrmDM.Query1.FieldByName('MaxPower').AsInteger;
          FieldByName('DefSpell').AsInteger := FrmDM.Query1.FieldByName('DefSpell').AsInteger;
          FieldByName('DefPower').AsInteger := FrmDM.Query1.FieldByName('DefPower').AsInteger;
          FieldByName('DefMaxPower').AsInteger := FrmDM.Query1.FieldByName('DefMaxPower').AsInteger;
          FieldByName('Job').AsInteger := FrmDM.Query1.FieldByName('Job').AsInteger;
          FieldByName('NeedL1').AsInteger := FrmDM.Query1.FieldByName('NeedL1').AsInteger;
          FieldByName('L1Train').AsInteger := FrmDM.Query1.FieldByName('L1Train').AsInteger;
          FieldByName('NeedL2').AsInteger := FrmDM.Query1.FieldByName('NeedL2').AsInteger;
          FieldByName('L2Train').AsInteger := FrmDM.Query1.FieldByName('L2Train').AsInteger;
          FieldByName('NeedL3').AsInteger := FrmDM.Query1.FieldByName('NeedL3').AsInteger;
          FieldByName('L3Train').AsInteger := FrmDM.Query1.FieldByName('L3Train').AsInteger;
          FieldByName('Delay').AsInteger := FrmDM.Query1.FieldByName('Delay').AsInteger;
          FieldByName('Descr').AsString := FrmDM.Query1.FieldByName('Descr').AsString;
          post;
        end;
        FrmDM.Query1.Next;
      end;
    end;
  finally
    DestTable.Free;
  end;
  bsSkinMessage1.MessageDlg('���ݿ���չ��ɣ�'+bsSkinFileEdit3.text+'\NewMagic.DB',mtInformation,[mbOK],0);
end;

procedure TFrmMain.bsSkinFileEdit3ButtonClick(Sender: TObject);
begin
  if bsSkinSelectDirectoryDialog1.Execute then begin
    bsSkinFileEdit3.Text:= bsSkinSelectDirectoryDialog1.Directory;
    if bsSkinFileEdit3.Text <> '' then bsSkinButton6.Enabled:= True;
  end;
end;

end.
