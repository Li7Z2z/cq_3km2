unit NewObjBase;

interface
uses
  Windows, Classes, SysUtils, Grobal2;
type
  //PTBaseObject = ^TNewBaseObject;
  TNewBaseObject = class
    m_ObjType: Byte;//��������
    m_dwAddTime: LongWord;//���ӵ�ͼʱ��
    m_nMapX: Integer;
    m_nMapY: Integer;
  public
    constructor Create(); virtual;
    destructor Destroy; override;
  end;

  TGateObject = class(TNewBaseObject)//��ͼ���ӵ����
    m_nSMapX: Integer;
    m_nSMapY: Integer;
    m_boFlag: Boolean;
    m_sName: string;
    m_DEnvir: TObject;
    m_sSMapNO: string;
    m_sDMapNO: string;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;

  TDoorObject = class(TNewBaseObject)//�����Ŷ���
    m_n08: Integer;
    m_Status: pTDoorStatus;//�ŵ�״̬
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
implementation

constructor TNewBaseObject.Create();
begin
  m_ObjType := OS_MOVINGOBJECT;
  m_dwAddTime := GetTickCount;
  m_nMapX := 0;
  m_nMapY := 0;
end;

destructor TNewBaseObject.Destroy;
begin
  inherited;
end;
//------------------------------------------------------------------------------
constructor TGateObject.Create();
begin
  inherited;
  m_ObjType := OS_GATEOBJECT;
  m_boFlag := False;
  m_nSMapX := -1;
  m_nSMapY := -1;
  m_sSMapNO := '';
  m_sDMapNO := '';
  m_DEnvir := nil;
  m_sName := IntToStr(Integer(Self));
end;

destructor TGateObject.Destroy;
begin
  inherited;
end;

constructor TDoorObject.Create();
begin
  inherited;
  m_ObjType := OS_DOOR;
  m_n08 := 0;
  m_Status := nil;
end;

destructor TDoorObject.Destroy;
begin
  inherited;
end;

end.

