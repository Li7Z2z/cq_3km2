unit SystemShare;

interface
const
  Mode1 = 1;//��ɱ��1
  Mode2 = 1;//��ɱ��2
  Mode3 = 1;//��ɱ��3
  Mode4 = 1;//��ɱ��4
  Mode5 = 1;//��ɱ��5
  Mode6 = 1;//��ɱ��6
  Mode7 = 1;//��ɱ��7
  Mode8 = 1;//��ɱ��8
  Mode42 = 1;//��ɱ��
  Mode43 = 1;//��ɱ�� ɾ��ע���-����
  sLoadPlug        = '���ء�3K�Ƽ� ϵͳģ�顿';
  sLoadPlugSucceed = '��3K�Ƽ� ϵͳģ�顿�����ɹ�';
  sLoadPlugFail    = '��3K�Ƽ� ϵͳģ�顿����ʧ��';
  sUnLoadPlug      = 'ж�ء�3K�Ƽ� ϵͳģ�顿�ɹ�';
  s108 ='0XPH84sD1QNHRNR7jViS3c9FvlE='; //2013-12-31 ����ʹ�õ�����(0627) \Plug\SystemModule\EDoceInfo.exe
  UserMode1 = 1;//�û�ģʽ 0-��� 1-����ʹ������(0627��176)  2-��IP(����) ��M2ģʽ��Ӧ
{$IF UserMode1 = 1}
  sPlugName        = '��3K�Ƽ� ϵͳģ��0627��(2012/12/18)';
{$ELSE}
  sPlugName        = '��3K�Ƽ� ϵͳģ�顿(2012/12/18)';
{$IFEND}
 TESTMODE = 0;//�Ƿ��ǲ���,1-���� 0-��ʽ
 //���� function Init, ͨ��MainOutMessasge('M2 CRC:'+inttostr(CalcFileCRC(Application.Exename)), 0); ȡ��CRCֵ
 nCode: Integer = -925969484;//////////M2����CRCA   0627(-98533354)  176(-1440222524)  ����(-379373253)
 procedure LaJiDaiMa(aint : Integer = 111; bint: Integer = 222; c : Single = 0.14);
implementation
procedure LaJiDaiMa(aint : Integer = 111; bint: Integer = 222; c : Single = 0.14);
begin
  if (aint > 0) then
    aint :=  bint + 1;
end;

end.
