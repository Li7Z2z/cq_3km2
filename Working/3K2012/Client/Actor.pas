unit Actor;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms,
  Grobal2, DxDraws, CliUtil, magiceff, Wil, SDK, ClFunc, Share;

const
   HUMANFRAME = 600; //hum.wil,,,һ��Race��ռ��ͼƬ��
   HUMANFRAME2 = 1200; //HUMANFRAME * 2
   NEWHUMANFRAME = 2000; //cbohum.wis ,һ��Race��ռ��ͼƬ��
   NEWHUMANFRAME2 = 4000; //NEWHUMANFRAME * 2
   MAXSAY = 5;
   RUN_MINHEALTH = 10;//�������Ѫ��ֻ���߶�
   DEFSPELLFRAME = 10; //ħ������
   CBODEFSPELLFRAME = 13;//����ħ������
   MAGBUBBLEBASE = 3890;    //ħ����Ч��ͼλ��
   MAGBUBBLESTRUCKBASE = 3900; //������ʱħ����Ч��ͼλ��
   MAXWPEFFECTFRAME = 5;
   WPEFFECTBASE = 3750;
   
type
//��������
  TActionInfo = packed record
    start   :Word;//0x14              // ��ʼ֡
    frame   :Word;//0x16              // ֡��
    skip    :Word;//0x18              // ������֡��
    ftime   :Word;//0x1A              // ÿ֡���ӳ�ʱ�䣨���룩
    usetick :Word;//0x1C              // ���ƽ, �̵� ���ۿ��� ����
  end;
  pTActionInfo = ^TActionInfo;

//��ҵĶ�������
  THumanAction = packed record
    ActStand:      TActionInfo;   //1
    ActWalk:       TActionInfo;   //8
    ActRun:        TActionInfo;   //8
    ActRushLeft:   TActionInfo;
    ActRushRight:  TActionInfo;
    ActWarMode:    TActionInfo;   //1
    ActHit:        TActionInfo;   //6
    ActHeavyHit:   TActionInfo;   //6
    ActBigHit:     TActionInfo;   //6
    ActFireHitReady: TActionInfo; //6
    ActSpell:      TActionInfo;   //6
    ActSitdown:    TActionInfo;   //1
    ActStruck:     TActionInfo;   //3
    ActDie:        TActionInfo;   //4
    ActCboSpell1:  TActionInfo; //˫����
    ActCboSpell2:  TActionInfo; //���ױ�  
    ActCboSpell3:  TActionInfo; //����ѩ��
    ActCboSpell4:  TActionInfo; //������
    ActCboSpell5:  TActionInfo; //������
    ActCboSpell6:  TActionInfo; //�����
    ActCboSpell7:  TActionInfo; //��Х��
    ActCboSpell8:  TActionInfo; //�򽣹���
    ActCboSpell9:  TActionInfo; //׷�Ĵ�
    ActCboSpell10: TActionInfo; //��ɨǧ��
    ActCboSpell11: TActionInfo; //����ɱ
    ActCboSpell12: TActionInfo;//����ն
    ActCboSpell13: TActionInfo;//����ٵ�
    ActCboSpell14: TActionInfo;//Ѫ��һ��(��)
  end;
  pTHumanAction = ^THumanAction;
  TMonsterAction = packed record
    ActStand:      TActionInfo;   //1
    ActWalk:       TActionInfo;   //8
    ActAttack:     TActionInfo;   //6 0x14 - 0x1C
    ActCritical:   TActionInfo;   //6 0x20 -
    ActStruck:     TActionInfo;   //3
    ActDie:        TActionInfo;   //4
    ActDeath:      TActionInfo;
  end;
  pTMonsterAction = ^TMonsterAction;
  {$IF M2Version <> 2}
  TMoveHMShow = packed record
    sMoveHpstr    :string;
    nMoveHpEnd     :Integer;
    boMoveHpShow   :Boolean;
    dwMoveHpTick   :LongWord;
  end;
  pTMoveHMShow= ^TMoveHMShow;
  {$IFEND}
const
   //���ද������
   //ÿ������ÿ������ÿ���Ա�600��ͼ
   //�輶��=L���Ա�=S����ʼ֡=L*600+600*S

   //Start:�ö�������������µĿ�ʼ֡
   //frame:�ö�����Ҫ��֡��
   //skip:������֡��
   HA: THumanAction = (//��ʼ֡       ��Ч֡     ����֡    ÿ֡�ӳ�
        ActStand:  (start: 0;      frame: 4;  skip: 4;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 64;     frame: 6;  skip: 2;  ftime: 90;   usetick: 2);
        ActRun:    (start: 128;    frame: 6;  skip: 2;  ftime: 120;  usetick: 3);
        ActRushLeft: (start: 128;    frame: 3;  skip: 5;  ftime: 120;  usetick: 3);
        ActRushRight:(start: 131;    frame: 3;  skip: 5;  ftime: 120;  usetick: 3);
        ActWarMode:(start: 192;    frame: 1;  skip: 0;  ftime: 200;  usetick: 0);
        //ActHit:    (start: 200;    frame: 5;  skip: 3;  ftime: 140;  usetick: 0);
        ActHit:    (start: 200;    frame: 6;  skip: 2;  ftime: 85;   usetick: 0);
        ActHeavyHit:(start: 264;   frame: 6;  skip: 2;  ftime: 90;   usetick: 0);
        ActBigHit: (start: 328;    frame: 8;  skip: 0;  ftime: 70;   usetick: 0);
        ActFireHitReady: (start: 192; frame: 6;  skip: 4;  ftime: 70;   usetick: 0);
        ActSpell:  (start: 392;    frame: 6;  skip: 2;  ftime: {46}60;   usetick: 0);
        ActSitdown:(start: 456;    frame: 2;  skip: 0;  ftime: 300;  usetick: 0);
        ActStruck: (start: 472;    frame: 3;  skip: 5;  ftime: 70;  usetick: 0);
        ActDie:    (start: 536;    frame: 4;  skip: 4;  ftime: 120;  usetick: 0);
        ActCboSpell1:(start: 1040; frame: 13;  skip: 7;  ftime: 60;   usetick: 0);//˫����
        ActCboSpell2:(start: 1360; frame: 9;  skip: 1;  ftime: 85;   usetick: 0); //���ױ�
        ActCboSpell3:(start: 800; frame: 8;  skip: 2;  ftime: 80;   usetick: 0); //����ѩ��
        ActCboSpell4:(start: 1600; frame: 12;  skip: 8;  ftime: 85;   usetick: 0); //������
        ActCboSpell5:(start: 1440; frame: 12;  skip: 8;  ftime: 60;   usetick: 0); //������
        ActCboSpell6:(start: 640; frame: 6;  skip: 4;  ftime: 80;   usetick: 0); //�����
        ActCboSpell7:(start: 1200; frame: 6;  skip: 4;  ftime: 80;   usetick: 0); //��Х��
        ActCboSpell8:(start: 1760; frame: 14;  skip: 6;  ftime: 65;   usetick: 0); //�򽣹���
        ActCboSpell9:(start: 80; frame: 8;  skip: 2;  ftime: 85;   usetick: 0); //׷�Ĵ�
        ActCboSpell10:(start: 560; frame: 10;  skip: 0;  ftime: 85;   usetick: 0); //��ɨǧ��
        ActCboSpell11:(start: 160; frame: 15;  skip: 5;  ftime: 60;   usetick: 0);//����ɱ
        ActCboSpell12:(start: 320; frame: 5;  skip: 5;  ftime: 60;   usetick: 0);//����ն
        ActCboSpell13:(start: 401; frame: 12;  skip: 8;  ftime: 80;   usetick: 0);//����ٵ�
        ActCboSpell14:(start: 720; frame: 6;  skip: 4;  ftime: 80;   usetick: 0);//Ѫ��һ��(��)
      );
  MA9: TMonsterAction = (//4C03D4
    ActStand:(Start:0;  frame:1;  skip:7;  ftime:200;  usetick:0);
    ActWalk:(Start:64;  frame:6;  skip:2;  ftime:120;  usetick:3);
    ActAttack:(Start:64;  frame:6;  skip:2;  ftime:150;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:64;  frame:6;  skip:2;  ftime:100;  usetick:0);
    ActDie:(Start:0;  frame:1;  skip:7;  ftime:140;  usetick:0);
    ActDeath:(Start:0;  frame:1;  skip:7;  ftime:0;  usetick:0);
    );
   MA10: TMonsterAction = (  //(8Frame) ������ʿ
           //ÿ������8֡    //����������Ʋ�������м��֣�//������280��
        ActStand:  (start: 0;      frame: 4;  skip: 4;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 64;     frame: 6;  skip: 2;  ftime: 120;  usetick: 3);
        ActAttack: (start: 128;    frame: 4;  skip: 4;  ftime: 150;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 192;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 208;    frame: 4;  skip: 4;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 272;    frame: 1;  skip: 0;  ftime: 0;    usetick: 0);
      );
   MA11: TMonsterAction = (  //�罿(10Frame¥��)  //ÿ������10֡ //280,(360��),440,430,,
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 120;  usetick: 3);
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 340;    frame: 1;  skip: 0;  ftime: 0;    usetick: 0);
      );
   MA12: TMonsterAction = (  //���, ������ �ӵ� ������.//ÿ������8֡��ÿ������8�����򣬹�7�ֶ��� (280),360,440,430,,
        ActStand:  (start: 0;      frame: 4;  skip: 4;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 64;     frame: 6;  skip: 2;  ftime: 120;  usetick: 3);
        ActAttack: (start: 128;    frame: 6;  skip: 2;  ftime: 150;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 192;    frame: 2;  skip: 0;  ftime: 150;  usetick: 0);
        ActDie:    (start: 208;    frame: 4;  skip: 4;  ftime: 160;  usetick: 0);
        ActDeath:  (start: 272;    frame: 1;  skip: 0;  ftime: 0;    usetick: 0);
      );
   MA13: TMonsterAction = (  //   mon2.wil�е�ʳ�˻�
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        //��mon2.wil���Կ���ʳ�˻�,actstand��ʳ�˻�վ��״̬
        ActWalk:   (start: 10;     frame: 8;  skip: 2;  ftime: 160;  usetick: 0); 
        //actwalkʵ������ʳ�˻�վ������������Ч��ע�⵽��β������ʵ��һЩobjects.wil����Ҳ������tiles
         //ʯĹʬ�������ʱ�ĵ�ͼЧ������ʳ�˻���Ч�����������ƣ���֪�������Ķ��������ǲ���Ҳ����ma13
        ActAttack: (start: 30;     frame: 6;  skip: 4;  ftime: 120;  usetick: 0);
        //actattack��30��ʼ�ǴӸ�����λ������Ч��
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        //actcritical���������ȥ
        ActStruck: (start: 110;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        //����110��ʼ����
        ActDie:    (start: 130;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        //130��ʼ����Ч��
        ActDeath:  (start: 20;     frame: 9;  skip: 0;  ftime: 150;  usetick: 0);
        //20��ʼ��ʳ�˻�������Ч��Ҳ��������Ч�������������ã���ֻ��9֡���һ֡��ȥ
      );
   MA14: TMonsterAction = (  //�ذ� ���� mon3���������սʿ,,��������ͬma13
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 340;    frame: 10; skip: 0;  ftime: 100;  usetick: 0); //����ΰ��(��ȯ)
      );
   MA15: TMonsterAction = (  //����ս��??�����⣺Դ�����жԹ���ķ����߼��ǲ��Ǿ���mon*.wil�ķ����߼�
        //��ע�⵽����սʿ������û��,�����Ŀ��Ǻ��꣬���ѵ���Ҳ��hum.wilһ��Ҫ��weapon.wil�ҹ����ܹ�������������?
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        //die��death��ʲô����???һ����������ʼ����һ�����ڵ����ϵĲк�??���ǰ�����˵������߼����԰�!!
        ActDeath:  (start: 1;      frame: 1;  skip: 0;  ftime: 100;  usetick: 0);
      );
   MA16: TMonsterAction = (  //������� ������  mon5����ĵ罩ʬ����������ƶ���ħ�����������Ĺ���һ��??
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 160;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 4;  skip: 6;  ftime: 160;  usetick: 0);
        ActDeath:  (start: 0;      frame: 1;  skip: 0;  ftime: 160;  usetick: 0);
      );
   MA17: TMonsterAction = (  //�ٵ������� ��  mon6�еĺ��н�������ʯĹʬ������һ����
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 60;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 100;  usetick: 0);
        ActDeath:  (start: 340;    frame: 1;  skip: 0;  ftime: 140;  usetick: 0); //
      );
   MA19: TMonsterAction = (
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 340;    frame: 1;  skip: 0;  ftime: 140;  usetick: 0); //
      );
   MA20: TMonsterAction = (
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 120;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 100;  usetick: 0);
        ActDeath:  (start: 340;    frame: 10; skip: 0;  ftime: 170;  usetick: 0);
      );
   MA21: TMonsterAction = (
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 0;      frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActAttack: (start: 10;     frame: 6;  skip: 4;  ftime: 120;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 20;     frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 30;     frame: 10; skip: 0;  ftime: 160;  usetick: 0);
        ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 0;    usetick: 0); 
      );
   MA22: TMonsterAction = (
        ActStand:  (start: 80;     frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 160;    frame: 6;  skip: 4;  ftime: 160;  usetick: 3); 
        ActAttack: (start: 240;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 320;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 340;    frame: 10; skip: 0;  ftime: 160;  usetick: 0);
        ActDeath:  (start: 0;      frame: 6;  skip: 4;  ftime: 170;  usetick: 0);
      );
   MA23: TMonsterAction = (
        ActStand:  (start: 20;     frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 100;    frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 180;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0); //
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 260;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 280;    frame: 10; skip: 0;  ftime: 160;  usetick: 0);
        ActDeath:  (start: 0;      frame: 20; skip: 0;  ftime: 100;  usetick: 0);
      );
   MA24: TMonsterAction = (  // (����) mon14�е�Ы��??ͨ�����µķ��������ֲ���?
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start:240;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActStruck: (start: 320;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 340;    frame: 10; skip: 0;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 420;    frame: 1;  skip: 0;  ftime: 140;  usetick: 0); //
      );
  MA25: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:70;  frame:10;  skip:0;  ftime:200;  usetick:3);
    ActAttack:(Start:20;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActCritical:(Start:10;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActStruck:(Start:50;  frame:2;  skip:0;  ftime:100;  usetick:0);
    ActDie:(Start:60;  frame:10;  skip:0;  ftime:200;  usetick:0);
    ActDeath:(Start:80;  frame:10;  skip:0;  ftime:200;  usetick:3);
    );

   MA26: TMonsterAction = (  
        ActStand:  (start: 0;      frame: 1;  skip: 7;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 0;      frame: 0;  skip: 0;  ftime: 160;  usetick: 0);
        ActAttack: (start: 56;     frame: 6;  skip: 2;  ftime: 500;  usetick: 0);
        ActCritical:(start: 64;    frame: 6;  skip: 2;  ftime: 500;  usetick: 0);
        ActStruck: (start: 0;      frame: 4;  skip: 4;  ftime: 100;  usetick: 0);
        ActDie:    (start: 24;     frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 150;  usetick: 0);
      );
   MA27: TMonsterAction = (
        ActStand:  (start: 0;     frame: 1;  skip: 7;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 0;     frame: 0;  skip: 0;  ftime: 160;  usetick: 0);
        ActAttack: (start: 0;     frame: 0;  skip: 0;  ftime: 250;  usetick: 0);
        ActCritical:(start: 0;    frame: 0;  skip: 0;  ftime: 250;  usetick: 0);
        ActStruck: (start: 0;     frame: 0;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 0;     frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;     frame: 0;  skip: 0;  ftime: 150;  usetick: 0);
      );
   MA28: TMonsterAction = (
        ActStand:  (start: 80;     frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 160;    frame: 6;  skip: 4;  ftime: 160;  usetick: 3);
        ActAttack: (start:  0;     frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start:  0;     frame: 10; skip: 0;  ftime: 100;  usetick: 0);
      );
   MA29: TMonsterAction = (
        ActStand:  (start: 80;     frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 160;    frame: 6;  skip: 4;  ftime: 160;  usetick: 3);
        ActAttack: (start: 240;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 10; skip: 0;  ftime: 100;  usetick: 0);
        ActStruck: (start: 320;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 340;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start:  0;     frame: 10; skip: 0;  ftime: 100;  usetick: 0);
      );
  MA30: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:10;  skip:0;  ftime:200;  usetick:3);
    ActAttack:(Start:10;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActCritical:(Start:10;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActStruck:(Start:20;  frame:2;  skip:0;  ftime:100;  usetick:0);
    ActDie:(Start:30;  frame:20;  skip:0;  ftime:150;  usetick:0);
    ActDeath:(Start:0;  frame:10;  skip:0;  ftime:200;  usetick:3);
    );
  MA31: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:10;  skip:0;  ftime:200;  usetick:3);
    ActAttack:(Start:10;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActCritical:(Start:0;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActStruck:(Start:0;  frame:2;  skip:8;  ftime:100;  usetick:0);
    ActDie:(Start:20;  frame:10;  skip:0;  ftime:200;  usetick:0);
    ActDeath:(Start:0;  frame:10;  skip:0;  ftime:200;  usetick:3);
    );
  MA32: TMonsterAction = (
    ActStand:(Start:0;  frame:1;  skip:9;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:6;  skip:4;  ftime:200;  usetick:3);
    ActAttack:(Start:0;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActCritical:(Start:0;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActStruck:(Start:0;  frame:2;  skip:8;  ftime:100;  usetick:0);
    ActDie:(Start:80;  frame:10;  skip:0;  ftime:80;  usetick:0);
    ActDeath:(Start:80;  frame:10;  skip:0;  ftime:200;  usetick:3);
    );
  MA33: TMonsterAction = (
             //��ʼ֡    ��Ч֡    ����֡   ÿ֡�ӳ�
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    //actstand��վ��״̬
    ActWalk:(Start:80;  frame:6;  skip:4;  ftime:200;  usetick:3);
    ActAttack:(Start:160;  frame:6;  skip:4;  ftime:120;  usetick:0);
    //actattack��30��ʼ�ǴӸ�����λ������Ч��
    ActCritical:(Start:340;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActStruck:(Start:240;  frame:2;  skip:0;  ftime:100;  usetick:0);
    ActDie:(Start:260;  frame:10;  skip:0;  ftime:200;  usetick:0);
    ActDeath:(Start:260;  frame:10;  skip:0;  ftime:200;  usetick:0);
    );
  MA34: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:80;  frame:6;  skip:4;  ftime:200;  usetick:3);
    ActAttack:(Start:160;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActCritical:(Start:320;  frame:6;  skip:4;  ftime:120;  usetick:0);
    ActStruck:(Start:400;  frame:2;  skip:0;  ftime:100;  usetick:0);
    ActDie:(Start:420;  frame:20;  skip:0;  ftime:200;  usetick:0);
    ActDeath:(Start:420;  frame:20;  skip:0;  ftime:200;  usetick:0);
    );
  MA35: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:30;  frame:10;  skip:0;  ftime:150;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:1;  skip:9;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA36: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:30;  frame:20;  skip:0;  ftime:150;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:1;  skip:9;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA37: TMonsterAction = (
    ActStand:(Start:30;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:30;  frame:4;  skip:6;  ftime:150;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:1;  skip:9;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA38: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:80;  frame:6;  skip:4;  ftime:150;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA39: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:300;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:10;  frame:6;  skip:4;  ftime:150;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:20;  frame:2;  skip:0;  ftime:150;  usetick:0);
    ActDie:(Start:30;  frame:10;  skip:0;  ftime:80;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA40: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:250;  usetick:0);
    ActWalk:(Start:80;  frame:6;  skip:4;  ftime:210;  usetick:3);
    ActAttack:(Start:160;  frame:6;  skip:4;  ftime:110;  usetick:0);
    ActCritical:(Start:580;  frame:20;  skip:0;  ftime:135;  usetick:0);
    ActStruck:(Start:240;  frame:2;  skip:0;  ftime:120;  usetick:0);
    ActDie:(Start:260;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActDeath:(Start:260;  frame:20;  skip:0;  ftime:130;  usetick:0);
    );
  MA41: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA42: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:10;  frame:8;  skip:2;  ftime:160;  usetick:0);
    ActAttack:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDie:(Start:30;  frame:10;  skip:0;  ftime:120;  usetick:0);
    ActDeath:(Start:30;  frame:10;  skip:0;  ftime:150;  usetick:0);
    );
  MA43: TMonsterAction = (
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:80;  frame:6;  skip:4;  ftime:160;  usetick:0);
    ActAttack:(Start:160;  frame:6;  skip:4;  ftime:160;  usetick:0);
    ActCritical:(Start:160;  frame:6;  skip:4;  ftime:160;  usetick:0);
    ActStruck:(Start:240;  frame:2;  skip:0;  ftime:150;  usetick:0);
    ActDie:(Start:260;  frame:10;  skip:0;  ftime:120;  usetick:0);
    ActDeath:(Start:340;  frame:10;  skip:0;  ftime:100;  usetick:0);
    );
  MA44: TMonsterAction = (
    ActStand:(Start:0;  frame:10;  skip:0;  ftime:300;  usetick:0);
    ActWalk:(Start:10;  frame:6;  skip:4;  ftime:150;  usetick:0);
    ActAttack:(Start:20;  frame:6;  skip:4;  ftime:150;  usetick:0);
    ActCritical:(Start:40;  frame:10;  skip:0;  ftime:150;  usetick:0);
    ActStruck:(Start:40;  frame:2;  skip:8;  ftime:150;  usetick:0);
    ActDie:(Start:{30}0;  frame:6;  skip:4;  ftime:150;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA45: TMonsterAction = (
    ActStand:(Start:0;  frame:10;  skip:0;  ftime:300;  usetick:0);
    ActWalk:(Start:0;  frame:10;  skip:0;  ftime:300;  usetick:0);
    ActAttack:(Start:10;  frame:10;  skip:0;  ftime:300;  usetick:0);
    ActCritical:(Start:10;  frame:10;  skip:0;  ftime:100;  usetick:0);
    ActStruck:(Start:0;  frame:1;  skip:9;  ftime:300;  usetick:0);
    ActDie:(Start:0;  frame:1;  skip:9;  ftime:300;  usetick:0);
    ActDeath:(Start:0;  frame:1;  skip:9;  ftime:300;  usetick:0);
    );
  MA46: TMonsterAction = (
    ActStand:(Start:0;  frame:20;  skip:0;  ftime:100;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA47: TMonsterAction = (//����
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:80;  frame:6;  skip:4;  ftime:200;  usetick:3);
    ActAttack:(Start:160;  frame:4;  skip:6;  ftime:160;  usetick:0);
    ActCritical:(Start:160;  frame:6;  skip:4;  ftime:160;  usetick:0);
    ActStruck:(Start:240;  frame:2;  skip:0;  ftime:100;  usetick:0);//�ܹ���
    ActDie:(Start:260;  frame:6;  skip:4;  ftime:130;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA48: TMonsterAction = (  //���
        ActStand:  (start: 0;      frame: 1;  skip: 0;  ftime: 0;  usetick: 0);
        ActWalk:   (start: 1;      frame: 6;  skip: 0;  ftime: 160;  usetick: 3);
        ActAttack: (start: 11;    frame: 10;  skip: 0;  ftime: 160;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 28;    frame: 6;  skip: 0;  ftime: 160;  usetick: 0);  //����С
        ActDie:    (start: 40;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0);
      );
  MA49: TMonsterAction = (
    ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
    ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3);
    ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 160;  usetick: 0);
    ActCritical:(start: 340;   frame: 6;  skip: 4;  ftime: 160;  usetick: 0);
    ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
    ActDie:    (start: 260;    frame: 10;  skip: 0;  ftime: 160;  usetick: 0);
    ActDeath:  (start: 420;   frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
    );
  MA50: TMonsterAction = ( //ѩ��
    ActStand:  (start: 0;      frame: 10;  skip: 0;  ftime: 60;  usetick: 0);
    ActWalk:   (start: 0;     frame: 10;  skip: 0;  ftime: 60;  usetick: 3);
    ActAttack: (start: 0;    frame: 10;  skip: 0;  ftime: 60;  usetick: 0);
    ActCritical:(start: 0;   frame: 10;  skip: 0;  ftime: 60;  usetick: 0);
    ActStruck: (start: 0;    frame: 10;  skip: 0;  ftime: 60;  usetick: 0);
    ActDie:    (start: 0;    frame: 10;  skip: 0;  ftime: 60;  usetick: 0);
    ActDeath:  (start: 0;   frame: 10;  skip: 0;  ftime: 60;  usetick: 0);
    );
  MA51: TMonsterAction = ( //ѩ��
    ActStand:  (start: 0;      frame: 1;  skip: 0;  ftime: 60;  usetick: 0);
    ActWalk:   (start: 0;     frame: 1;  skip: 0;  ftime: 60;  usetick: 3);
    ActAttack: (start: 0;    frame: 1;  skip: 0;  ftime: 60;  usetick: 0);
    ActCritical:(start: 0;   frame: 1;  skip: 0;  ftime: 60;  usetick: 0);
    ActStruck: (start: 0;    frame: 1;  skip: 0;  ftime: 60;  usetick: 0);
    ActDie:    (start: 0;    frame: 1;  skip: 0;  ftime: 60;  usetick: 0);
    ActDeath:  (start: 0;   frame: 1;  skip: 0;  ftime: 60;  usetick: 0);
    );
  MA70: TMonsterAction = (//�����ʼ�NPC
    ActStand:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    ActAttack:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    ActCritical:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    ActStruck:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    ActDie:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    ActDeath:(Start:0;  frame:4;  skip:0;  ftime:200;  usetick:0);
    );
  MA71: TMonsterAction = (//�ƹ�3������NPC 20080308
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActAttack:(Start:10;  frame:19;  skip:0;  ftime:200;  usetick:0);
    ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActStruck:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
    );
  MA72: TMonsterAction = (//ʥ����NPC
    ActStand:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActWalk:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActAttack:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActCritical:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActStruck:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActDie:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    ActDeath:(Start:0;  frame:20;  skip:0;  ftime:130;  usetick:0);
    );
  MA93: TMonsterAction = ( //�������� 200808012
      ActStand:  (start: 0;     frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
      ActWalk:   (start: 80;    frame: 6;  skip: 4;  ftime: 160;  usetick: 3);
      ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
      ActCritical:(start: 340;     frame: 10;  skip: 0;  ftime: 160;    usetick: 0);
      ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
      ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 160;  usetick: 0);
      ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 0;  usetick: 0);
    );
  MA94: TMonsterAction = ( //ѩ�򺮱�ħ��ѩ������ħ��ѩ���嶾ħ
      ActStand:  (start: 0;     frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
      ActWalk:   (start: 80;    frame: 6;  skip: 4;  ftime: 160;  usetick: 3);
      ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
      ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
      ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
      ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 160;  usetick: 0);
      ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 0;  usetick: 0);
    );
  MA95: TMonsterAction = ( //�����ػ���
      ActStand:  (start: 3;     frame: 1;  skip: 0;  ftime: 0;  usetick: 0);
      ActWalk:   (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 3);
      ActAttack: (start: 8;    frame: 10;  skip: 2;  ftime: 160;  usetick: 0);
      ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
      ActStruck: (start: 0;    frame: 0;  skip: 0;  ftime: 0;  usetick: 0);
      ActDie:    (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0);
      ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 0;  usetick: 0);
    );
  MA100: TMonsterAction = (//����
    ActStand:(Start:360;  frame:4;  skip:6;  ftime:200;  usetick:0);
    ActWalk:(Start:440;  frame:6;  skip:4;  ftime:200;  usetick:3);
    ActAttack:(Start:520;  frame:4;  skip:6;  ftime:160;  usetick:0);

    ActCritical:(Start:520;  frame:6;  skip:4;  ftime:160;  usetick:0);
    ActStruck:(Start:600;  frame:2;  skip:0;  ftime:100;  usetick:0);//�ܹ���
    ActDie:(Start:620;  frame:6;  skip:4;  ftime:130;  usetick:0);
    ActDeath:(Start:340;  frame:10;  skip:0;  ftime:100;  usetick:0);
    );
  MA101: TMonsterAction = (
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 340;    frame: 8;  skip: 2;  ftime: 140;  usetick: 0); //
      );
  MA102: TMonsterAction = (  //ѩ������
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 340;     frame: 6;  skip: 4;  ftime: 100;    usetick: 0);  //����Ч��
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 9;  skip: 1;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0); //����ΰ��(��ȯ)
      );
  MA103: TMonsterAction = (  //ѩ��ħ��
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 340;    frame: 8; skip: 2;  ftime: 100;  usetick: 0); //����ΰ��(��ȯ)
      );
  MA104: TMonsterAction = (  //ѩ����ʿ
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 340;     frame: 6;  skip: 4;  ftime: 100;    usetick: 0);  //����Ч��
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 820;    frame: 10; skip: 0;  ftime: 100;  usetick: 0); //����ΰ��(��ȯ)
      );
  MA105: TMonsterAction = (  //ѩ���콫
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 420;     frame: 7;  skip: 3;  ftime: 100;    usetick: 0);  //����Ч��
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0); //����ΰ��(��ȯ)
      );
  MA106: TMonsterAction = (  //����֮��
        ActStand:  (start: 0;      frame: 1;  skip: 0;  ftime: 0;  usetick: 0);
        ActWalk:   (start: 1;      frame: 6;  skip: 0;  ftime: 160;  usetick: 3);
        ActAttack: (start: 20;    frame: 10;  skip: 0;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 30;    frame: 4;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 40;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0);
      );
  MA107: TMonsterAction = (  //��β��ʯ
        ActStand:  (start: 70;      frame: 4;  skip: 0;  ftime: 0;  usetick: 0);
        ActWalk:   (start: 0;      frame: 0;  skip: 0;  ftime: 0;  usetick: 3);
        ActAttack: (start: 0;    frame: 0;  skip: 0;  ftime: 0;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 0;    frame: 0;  skip: 0;  ftime: 0;  usetick: 0);
        ActDie:    (start: 40;    frame: 10; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0);
      );
  MA108: TMonsterAction = (  //��������
        ActStand:  (start: 0;      frame: 1;  skip: 0;  ftime: 0;  usetick: 0);
        ActWalk:   (start: 1;      frame: 6;  skip: 0;  ftime: 160;  usetick: 3);
        ActAttack: (start: 20;    frame: 10;  skip: 0;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 30;    frame: 4;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 400;    frame: 18; skip: 0;  ftime: 120;  usetick: 0);
        ActDeath:  (start: 0;    frame: 0; skip: 0;  ftime: 0;  usetick: 0);
      );
  MA109: TMonsterAction = (  //�ò���
        ActStand:(Start:0;  frame:4;  skip:6;  ftime:200;  usetick:0);
        ActWalk:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
        ActAttack:(Start:30;  frame:23;  skip:0;  ftime:150;  usetick:0);
        ActCritical:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
        ActStruck:(Start:0;  frame:1;  skip:9;  ftime:0;  usetick:0);
        ActDie:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
        ActDeath:(Start:0;  frame:0;  skip:0;  ftime:0;  usetick:0);
        );
  MA110: TMonsterAction = (  //�ϻ�
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 340;   frame: 6;  skip: 4;  ftime: 100;  usetick: 0); //���⹥��
        ActStruck: (start: 240;    frame: 2;  skip: 0;  ftime: 100;  usetick: 0); //�ܹ���
        ActDie:    (start: 260;    frame: 10; skip: 0;  ftime: 140;  usetick: 0); //����
        ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 0;    usetick: 0); //
        );
  //�Ѿ�ϵ��By TasNat at: 2012-10-18 11:05:39
  MA120: TMonsterAction = (
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 400;   frame: 10;  skip: 0;  ftime: 100;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 8;  ftime: 100;  usetick: 0);
        ActDie:    (start: 320;    frame: 10; skip: 0;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 329;    frame: 1;  skip: 0;  ftime: 140;  usetick: 0); //
      );
  MA121: TMonsterAction = (
        ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 6;  skip: 4;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 2;  skip: 8;  ftime: 100;  usetick: 0);
        ActDie:    (start: 320;    frame: 7; skip: 3;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 326;    frame: 1;  skip: 0;  ftime: 140;  usetick: 0); //
      );

  MA122: TMonsterAction = ( //��è
        ActStand:  (start: 0;      frame: 6;  skip: 4;  ftime: 200;  usetick: 0);
        ActWalk:   (start: 80;     frame: 6;  skip: 4;  ftime: 160;  usetick: 3); //
        ActAttack: (start: 160;    frame: 10;  skip: 0;  ftime: 100;  usetick: 0);
        ActCritical:(start: 0;     frame: 0;  skip: 0;  ftime: 0;    usetick: 0);
        ActStruck: (start: 240;    frame: 10;  skip: 0;  ftime: 100;  usetick: 0);
        ActDie:    (start: 320;    frame: 7; skip: 3;  ftime: 140;  usetick: 0);
        ActDeath:  (start: 326;    frame: 1;  skip: 0;  ftime: 140;  usetick: 0); //
      );
{------------------------------------------------------------------------------}
// ��������˳�� (�Ƿ������������: 0��/1��)
// WEAPONORDERS: array [Sex, FrameIndex] of Byte
{------------------------------------------------------------------------------}
   WORDER: Array[0..1, 0..599] of byte = (  //1: Ů,  0: ��
                                            //��һά���Ա𣬵ڶ�ά�Ƕ���ͼƬ����
      (       //��
      //վ
      0,0,0,0,0,0,0,0,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,0,0,0,0,0,    0,0,0,0,1,1,1,1,
      0,0,0,0,1,1,1,1,    0,0,0,0,1,1,1,1,
      //��
      0,0,0,0,0,0,0,0,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,0,0,0,0,0,    0,0,0,0,0,0,0,1,
      0,0,0,0,0,0,0,1,    0,0,0,0,0,0,0,1,
      //��
      0,0,0,0,0,0,0,0,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,1,1,1,1,1,1,    0,0,1,1,1,0,0,1,
      0,0,0,0,0,0,0,1,    0,0,0,0,0,0,0,1,
      //war���
      0,1,1,1,0,0,0,0,
      //��
      1,1,1,0,0,0,1,1,    1,1,1,0,0,0,0,0,    1,1,1,0,0,0,0,0,
      1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,    1,1,1,0,0,0,0,0,
      0,0,0,0,0,0,0,0,    1,1,1,1,0,0,1,1,
      //�� 2
      0,1,1,0,0,0,1,1,    0,1,1,0,0,0,1,1,    1,1,1,0,0,0,0,0,
      1,1,1,0,0,1,1,1,    1,1,1,1,1,1,1,1,    0,1,1,1,1,1,1,1,
      0,0,0,1,1,1,0,0,    0,1,1,1,1,0,1,1,
      //��3
      1,1,0,1,0,0,0,0,    1,1,0,0,0,0,0,0,    1,1,1,1,1,0,0,0,
      1,1,0,0,1,0,0,0,    1,1,1,0,0,0,0,1,    0,1,1,0,0,0,0,0,
      0,0,0,0,1,1,1,0,    1,1,1,1,1,0,0,0,
      //����
      0,0,0,0,0,0,1,1,    0,0,0,0,0,0,1,1,    0,0,0,0,0,0,1,1,
      1,0,0,0,0,1,1,1,    1,1,1,1,1,1,1,1,    0,1,1,1,1,1,1,1,
      0,0,1,1,0,0,1,1,    0,0,0,1,0,0,1,1,
      //�ر�
      0,0,1,0,1,1,1,1,    1,1,0,0,0,1,0,0,
      //�±�
      0,0,0,1,1,1,1,1,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1,
      0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1,
      //������
      0,0,1,1,1,1,1,1,    0,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1,
      0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1
      ),

      (
      //����
      0,0,0,0,0,0,0,0,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,0,0,0,0,0,    0,0,0,0,1,1,1,1,
      0,0,0,0,1,1,1,1,    0,0,0,0,1,1,1,1,
      //�ȱ�
      0,0,0,0,0,0,0,0,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,0,0,0,0,0,    0,0,0,0,0,0,0,1,
      0,0,0,0,0,0,0,1,    0,0,0,0,0,0,0,1,
      //�ٱ�
      0,0,0,0,0,0,0,0,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,1,1,1,1,1,1,    0,0,1,1,1,0,0,1,
      0,0,0,0,0,0,0,1,    0,0,0,0,0,0,0,1,
      //war���
      1,1,1,1,0,0,0,0,
      //����
      1,1,1,0,0,0,1,1,    1,1,1,0,0,0,0,0,    1,1,1,0,0,0,0,0,
      1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,    1,1,1,0,0,0,0,0,
      0,0,0,0,0,0,0,0,    1,1,1,1,0,0,1,1,
      //���� 2
      0,1,1,0,0,0,1,1,    0,1,1,0,0,0,1,1,    1,1,1,0,0,0,0,0,
      1,1,1,0,0,1,1,1,    1,1,1,1,1,1,1,1,    0,1,1,1,1,1,1,1,
      0,0,0,1,1,1,0,0,    0,1,1,1,1,0,1,1,
      //����3
      1,1,0,1,0,0,0,0,    1,1,0,0,0,0,0,0,    1,1,1,1,1,0,0,0,
      1,1,0,0,1,0,0,0,    1,1,1,0,0,0,0,1,    0,1,1,0,0,0,0,0,
      0,0,0,0,1,1,1,0,    1,1,1,1,1,0,0,0,
      //����
      0,0,0,0,0,0,1,1,    0,0,0,0,0,0,1,1,    0,0,0,0,0,0,1,1,
      1,0,0,0,0,1,1,1,    1,1,1,1,1,1,1,1,    0,1,1,1,1,1,1,1,
      0,0,1,1,0,0,1,1,    0,0,0,1,0,0,1,1,
      //�ر�
      0,0,1,0,1,1,1,1,    1,1,0,0,0,1,0,0,
      //�±�
      0,0,0,1,1,1,1,1,    1,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1,
      0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1,
      //������
      0,0,1,1,1,1,1,1,    0,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,    0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1,
      0,0,0,1,1,1,1,1,    0,0,0,1,1,1,1,1
      )
   );


type

   TActor = class
     m_nRecogId                :Integer;    //��ɫ��ʶ 0x4
     m_nCurrX                  :Integer;    //��ǰ���ڵ�ͼ����X 0x08
     m_nCurrY                  :Integer;    //��ǰ���ڵ�ͼ����Y 0x0A
     m_btDir                   :Byte;       //��ǰվ������ 0x0C
     m_btSex                   :Byte;       //�Ա� 0x0D
     m_btRace                  :Byte;       //0x0E
     m_btHair                  :Byte;       //ͷ������ 0x0F
     m_btDress                 :Byte;       //�·����� 0x10
     m_btWeapon                :Byte;       //��������
     m_boMagicShield           :Boolean;    //�����ָBy TasNat at:2012-12-12 10:25:01
     //m_btHorse                 :Byte;       //������   20080721 ע������
     m_btEffect                :Byte;       //��ʹ����
     m_btJob                   :Byte;       //ְҵ 0:��ʿ  1:��ʦ  2:��ʿ
     m_wAppearance             :Word;       //0x14 DIV 10=���壨��ò���� Mod 10=��òͼƬ��ͼƬ���е�λ�ã��ڼ��֣�
     m_nLoyal                  :Integer;    //Ӣ���ҳ϶�
     m_nFeature                :TFeatures;    //0x18
     m_nFeatureEx              :Integer;    //0x18
     m_nState                  :Integer;    //0x1C
     m_boDeath                 :Boolean;    //0x20
     m_boSkeleton              :Boolean;    //0x21
     m_boDelActor              :Boolean;    //0x22
     m_boDelActionAfterFinished :Boolean;   //0x23
     m_sDescUserName           :String;     //�������ƣ���׺
     m_sUserName               :String;     //����
     m_nNameColor              :Integer;    //������ɫ
     m_btMiniMapHeroColor      :byte;       //Ӣ��С��ͼ������ɫ

     m_nGold                   :Integer;    //�������0x58
     m_nGameGold               :Integer;    //��Ϸ������
     m_nGamePoint              :Integer;    //��Ϸ������
     m_nGameDiaMond            :Integer;    //���ʯ����  2008.02.11
     m_nGameGird               :Integer;    //�������  2008.02.11
     //m_nGameGlory              :Integer; //�������� 20080511

     m_nHitSpeed               :ShortInt;   //�����ٶ� 0: �⺻, (-)���� (+)����
     m_boVisible               :Boolean;    //0x5D
     m_boHoldPlace             :Boolean;    //0x5E

     m_SayingArr               :array[0..MAXSAY-1] of String;  //���˵�Ļ�
     m_SayWidthsArr            :array[0..MAXSAY-1] of Integer; //ÿ�仰�Ŀ��
     m_dwSayTime               :LongWord;
     m_nSayX                   :Integer;
     m_nSayY                   :Integer;
     m_nSayLineCount           :Integer;

     m_nShiftX                 :Integer;    //0x98
     m_nShiftY                 :Integer;    //0x9C

     //m_nLightX                 :Integer;  //����ͼƬ���� �� 2007.12.12
     m_nPx                     :Integer;  //0xA0
     m_nHpx                    :Integer;  //0xA4
     m_nWpx                    :Integer;  //0xA8
     m_nEpx                    :Integer;
     m_nSpx                    :Integer;  //0xAC

     //m_nLightY                 :Integer;  //����ͼƬ���� �� 2007.12.12
     m_nPy                     :Integer;
     m_nHpy                    :Integer;
     m_nWpy                    :Integer;
     m_nEpy                    :Integer;
     m_nSpy                    :Integer;  //0xB0 0xB4 0xB8 0xBC

     m_nRx                     :Integer;
     m_nRy                     :Integer;//0xC0 0xC4
     m_nDownDrawLevel          :Integer;    //0xC8
     m_nTargetX                :Integer;
     m_nTargetY                :Integer; //0xCC 0xD0
     m_nTargetRecog            :Integer;      //0xD4
     m_nHiterCode              :Integer;        //0xD8
     m_nMagicNum               :Integer;         //0xDC
     m_nCurrentEvent           :Integer; //������ �̺�Ʈ ���̵�
     m_boDigFragment           :Boolean; //�ڿ�Ч��
     //m_boThrow                 :Boolean;  20080803ע��
     m_Abil                    :TAbility;   //��������
     m_nBodyOffset             :Integer;     //0x0E8   //0x0D0 // ����ͼƬ��������ƫ��
     m_nHairOffset             :Integer;     //0x0EC           // ͷ��ͼƬ��������ƫ��
     m_nCboHairOffset          :Integer;     //0x0EC           // WISͷ��ͼƬ��������ƫ��
     m_nHumWinOffset           :Integer;   //0x0F0
     m_nCboHumWinOffset        :Integer;   //0x0F0        // WIS���ͼƬ��������ƫ��
     m_nWeaponOffset           :Integer;   //0x0F4             // ����ͼƬ��������ƫ��
     m_nWeaponEffOffset        :Integer;
     m_nCboWeaponEffOffset     :Integer;
     m_boUseMagic              :Boolean;    //0x0F8   //0xE0
     m_boHitEffect             :Boolean;   //0x0F9    //0xE1
     m_boUseEffect             :Boolean;   //0x0FA    //0xE2
     m_nHitEffectNumber        :Integer;              //0xE4
     m_dwWaitMagicRequest      :LongWord;
     m_nWaitForRecogId         :Integer;  //�ڽ��� ������� WaitFor�� actor�� visible ��Ų��.
     m_nWaitForFeature         :TFeatures;
     m_nWaitForStatus          :Integer;
     m_nCurEffFrame            :Integer;       //0x110
     m_nSpellFrame             :Integer;        //0x114
     m_CurMagic                :TUseMagicInfo;    //0x118  //m_CurMagic.EffectNumber 0x110

     m_nGenAniCount            :Integer;                   //0x124
     m_boOpenHealth            :Boolean;        //0x140
     m_noInstanceOpenHealth    :Boolean;//0x141
     m_dwOpenHealthStart       :LongWord;
     m_dwOpenHealthTime        :LongWord;//Integer;jacky
      //SRc: TRect;  //Screen Rect ȭ���� ������ǥ(���콺 ����)
     m_BodySurface             :TDirectDrawSurface;    //0x14C   //0x134
    // m_LightSurface             :TDirectDrawSurface;    //0x14C   //0x134
     m_boGrouped               :Boolean;    // �Ƿ����
     m_nCurrentAction          :Integer;    //0x154         //0x13C
     m_boReverseFrame          :Boolean;    //0x158
     m_boWarMode               :Boolean;    //0x159
     m_boCboMode               :Boolean;    //WIS��ʽ 20090625
     m_dwWarModeTime           :LongWord;   //0x15C
     m_nChrLight               :Integer;    //0x160
     m_nMagLight               :Integer;    //0x164
     m_nRushDir                :Integer;  //0, 1
     //m_nXxI                    :Integer; //0x16C   20080521 ע��û�õ�����
     m_boLockEndFrame          :Boolean;
     m_dwLastStruckTime        :LongWord;
     m_dwSendQueryUserNameTime :LongWord;
     m_dwDeleteTime            :LongWord;

     m_nMagicStruckSound       :Integer;  //0x180 ��ħ��������������������
     m_boRunSound              :Boolean;  //0x184 �ܲ�����������
     m_nFootStepSound          :Integer;  //CM_WALK, CM_RUN //0x188  �߲���
     m_nStruckSound            :Integer;  //SM_STRUCK         //0x18C  ��������
     m_nStruckWeaponSound      :Integer;                //0x190  ��ָ������������������

     m_nAppearSound            :Integer;  //����Ҹ� 0    //0x194
     m_nNormalSound            :Integer;  //�ϹݼҸ� 1    //0x198
     m_nAttackSound            :Integer;  //         2    //0x19C
     m_nWeaponSound            :Integer; //          3    //0x1A0
     m_nScreamSound            :Integer;  //         4    //0x1A4
     m_nDieSound               :Integer;     //������   5 SM_DEATHNOW //0x1A8
     m_nDie2Sound              :Integer;                    //0x1AC

     m_nMagicStartSound        :Integer;     //0x1B0
     m_nMagicFireSound         :Integer;      //0x1B4
     m_nMagicExplosionSound    :Integer; //0x1B8
     m_Action                  :pTMonsterAction;
{******************************************************************************}
     //��������ʾ���� begin   2008.01.13
     m_nMyShowStartFrame        :Integer; //��������ʼ֡
     m_nMyShowExplosionFrame    :Integer; //���������󲥷ŵ�֡��
     m_nMyShowNextFrameTime     :LongWord; //������ʱ����
     m_nMyShowTime              :LongWord; //��ǰʱ��
     m_nMyShowFrame             :Integer; //��ǰ֡
     g_boIsMyShow               :Boolean; //�Ƿ���ʾ����{�ӵ���ϢΪTrue}
     g_MagicBase                :TWMImages; //ͼ��
     m_boNoChangeIsMyShow       :Boolean; //�Ƿ񷢳��Ķ������겻�������ﶯ�����仯  20080306
     m_nNoChangeX, m_nNoChangeY :Integer; //���ı䶯��������X��Y  20080306
{******************************************************************************}
    m_Skill69NH: Integer;//��ǰ����ֵ 20110226
    m_Skill69MaxNH: Integer;//�������ֵ 20110226
    m_SayColor: Integer; //����ͷ��˵�� ������ɫ��
    m_dwKill79Time: LongWord;
    m_boIsShop: Boolean; //��̯
    m_sShopMsg: string[28];
    {$IF M2Version <> 2}
    m_nMoveHpList: TList;
    {$IFEND}
    m_nMoveTimeStep: Word; //�ƶ����ټ��
   private
     function GetMessage(ChrMsg:pTChrMsg):Boolean;
     function GetKill79Message(ChrMsg:pTChrMsg):Boolean;
     function GetEffectWil(idx: Byte): TWMImages;
   protected
     m_nStartFrame             :Integer;      //0x1BC        //0x1A8  // ��ǰ�����Ŀ�ʼ֡����
     m_nEndFrame               :Integer;        //0x1C0      //0x1AC  // ��ǰ�����Ľ���֡����
     m_nCurrentFrame           :Integer;    //0x1C4          //0x1B0
     m_nEffectStart            :Integer;     //0x1C8         //0x1B4
     m_nEffectFrame            :Integer;     //0x1CC         //0x1B8
     m_nEffectEnd              :Integer;       //0x1D0       //0x1BC
     m_dwEffectStartTime       :LongWord;//0x1D4             //0x1C0
     m_dwEffectFrameTime       :LongWord;//0x1D8             //0x1C4
     m_dwFrameTime             :LongWord;      //0x1DC       //0x1C8
     m_dwStartTime             :LongWord;      //0x1E0       //0x1CC
     m_nMaxTick                :Integer;         //0x1E4
     m_nCurTick                :Integer;         //0x1E8
     m_nMoveStep               :Integer;        //0x1EC
     m_boMsgMuch               :Boolean;            //0x1F0
     m_dwStruckFrameTime       :LongWord;   //0x1F4
     m_nCurrentDefFrame        :Integer;    //0x1F8          //0x1E4
     m_dwDefFrameTime          :LongWord;      //0x1FC       //0x1E8
     m_nDefFrameCount          :Integer;      //0x200        //0x1EC
     //m_nSkipTick               :Integer;           //20080816ע�͵��𲽸���
     m_dwSmoothMoveTime        :LongWord;    //0x208
     m_dwGenAnicountTime       :LongWord;   //0x20C
     m_dwLoadSurfaceTime       :LongWord;   //0x210  //0x200

     m_nOldx                   :Integer;
     m_nOldy                   :Integer;
     m_nOldDir                 :Integer; //0x214 0x218 0x21C
     m_nActBeforeX             :Integer;
     m_nActBeforeY             :Integer;  //0x220 0x224
     m_nWpord                  :Integer;                   //0x228

      procedure CalcActorFrame; dynamic;
      procedure DefaultMotion; dynamic;
      function  GetDefaultFrame (wmode: Boolean): integer; dynamic;
      procedure DrawEffSurface (dsurface, source: TDirectDrawSurface; ddx, ddy: integer; blend: Boolean; ceff: TColorEffect);
      procedure DrawWeaponGlimmer (dsurface: TDirectDrawSurface; ddx, ddy: integer);
   public
      m_MsgList: TGList;       //list of PTChrMsg 0x22C  //0x21C
      m_Kill79MsgList: TGList;  //׷�Ĵ̸ı�������Ϣ�б�
      RealActionMsg: TChrMsg; //FrmMain    0x230
      constructor Create; dynamic;
      destructor Destroy; override;
      function FindMsg(wIdent: Word): Boolean;
      procedure  SendMsg (wIdent:Word; nX,nY, ndir,nFeature,nState:Integer;sStr:String;nSound:Integer; NewFeature: TFeatures);
      procedure  Kill79SendMsg(wIdent:Word; nX,nY, ndir,nFeature,nState:Integer;sStr:String;nSound:Integer);
      procedure  UpdateMsg(wIdent:Word; nX,nY, ndir,nFeature,nState:Integer;sStr:String;nSound:Integer; NewFeature: TFeatures);
      procedure  CleanUserMsgs;
      procedure  ProcMsg;
      procedure  ProcHurryMsg;
      function   IsIdle: Boolean;
      function   ActionFinished: Boolean;
      function   CanWalk: Integer;
      function   CanRun: Integer;
      procedure  Shift (dir, step, cur, max: integer);
      procedure  ReadyAction (msg: TChrMsg);
      function   CharWidth: Integer;
      function   CharHeight: Integer;
      function   CheckSelect (dx, dy: integer): Boolean;
      procedure  CleanCharMapSetting (x, y: integer);
      procedure  Say (str: string);
      procedure  SetSound; dynamic;
      procedure  Run; dynamic;
      procedure  RunSound; dynamic;
      procedure  RunActSound (frame: integer); dynamic;
      procedure  RunFrameAction (frame: integer); dynamic;  //�����Ӹ��� ��Ư�ϰ� �ؾ�����
      procedure  ActionEnded; dynamic;
      function   Move (step: integer): Boolean;
      procedure  MoveFail;
      function   CanCancelAction: Boolean;
      procedure  CancelAction;
      procedure  FeatureChanged; dynamic;
      function   Light: integer; dynamic;
      procedure  LoadSurface; dynamic;
      function   GetDrawEffectValue: TColorEffect;
      procedure  DrawMyShow(dsurface: TDirectDrawSurface;dx,dy:integer); //ͨ������������ʾ 20080113
      procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); dynamic;
      procedure  DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); dynamic;
      procedure  DrawStall (dsurface: TDirectDrawSurface; dx, dy: integer); dynamic;   //��̯λ
   end;

   TNpcActor = class (TActor)
   private
     m_nEffX      :Integer; //0x240
     m_nEffY      :Integer; //0x244
     m_bo248      :Boolean; //0x248
     m_dwUseEffectTick    :LongWord; //0x24C
     m_EffSurface       :TDirectDrawSurface; //��NPC ħ������Ч��

     m_boUseEffect1: Boolean;
     m_nEffX1      :Integer; //0x240
     m_nEffY1      :Integer; //0x244
     m_EffSurface1       :TDirectDrawSurface; //��NPC ħ������Ч��

     //�ƹ�2���ϰ����߶�  20080621
     m_boNpcWalkEffect  :Boolean;  //�Ƿ��߶��йֶ���Ч��
     m_boNpcWalkEffectSurface :TDirectDrawSurface;
     m_nNpcWalkEffectPx :Integer;
     m_nNpcWalkEffectPy :Integer;
   public
     g_boNpcWalk  :Boolean; //NPC�߶� 20080621
     constructor Create; override;
     destructor Destroy; override;
     procedure  Run; override;
     procedure  CalcActorFrame; override;
     function   GetDefaultFrame (wmode: Boolean): integer; override;
     procedure  LoadSurface; override;
     procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
     procedure  DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer); override;
   end;

   THumActor = class (TActor)//Size: 0x27C Address: 0x00475BB8
   private
     m_HairSurface         :TDirectDrawSurface; //0x250  //0x240  //ͷ����� 2007.10.21
     m_WeaponSurface       :TDirectDrawSurface; //0x254  //0x244  //������� 2007.10.21
     m_WeaponEffSurface    :TDirectDrawSurface;  ///��������
     m_HumWinSurface       :TDirectDrawSurface; //0x258  //0x248  //������� 2007.10.21
     m_boWeaponEffect      :Boolean;            //0x25C  //0x24C
     m_nCurWeaponEffect    :Integer;            //0x260  //0x250
     m_nCurBubbleStruck    :Integer;            //0x264  //0x254
     m_nCurProtEctionStruck :Integer;
     m_dwProtEctionStruckTime :Longword;

     m_dwWeaponpEffectTime :LongWord;           //0x268
     //m_boHideWeapon        :Boolean;            20080803ע��
     m_nFrame              :Integer;
     m_dwFrameTick         :LongWord;
     m_dwFrameTime         :LongWord;
     m_Hit4Meff            :TMagicEff; //����Ч��
     m_boHit4              :Boolean;
     m_boHit41             :Boolean;
     m_HumEffSurface: TDirectDrawSurface;
     m_HumPx: Integer;
     m_HumPy: Integer;

     m_nEffFrame              :Integer;
     m_dwEffFrameTick         :LongWord;
     m_dwEffFrameTime         :LongWord;
   protected
      procedure CalcActorFrame; override;
      procedure DefaultMotion; override;
      function  GetDefaultFrame (wmode: Boolean): integer; override;
   public
      {$IF M2Version <> 2}
      m_wTitleIcon: Word;
      m_sTitleName: string;
      {$IFEND}
      //m_boMagbubble4  :Boolean; //�Ƿ���4��ħ����״̬
      constructor Create; override;
      destructor Destroy; override;
      procedure  Run; override;
      procedure  RunFrameAction (frame: integer); override;
      function   Light: integer; override;
      procedure  LoadSurface; override;
      procedure  DoWeaponBreakEffect;
      procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean); override;
      procedure  DrawStall (dsurface: TDirectDrawSurface; dx, dy: integer); override;
   end;

   function GetRaceByPM (race: integer;Appr:word): PTMonsterAction;
   function GetOffset (appr: integer): integer;
   function GetNpcOffset(nAppr:Integer):Integer;
implementation

uses
   ClMain, SoundUtil, clEvent, MShare;
constructor TActor.Create;
begin
  inherited Create;
  FillChar(m_Abil,Sizeof(TAbility), 0);
  FillChar(m_Action,SizeOf(m_Action),0);
  {$IF M2Version <> 2}
  m_nMoveHpList       := TList.Create;
  {$IFEND}
  m_MsgList           := TGList.Create;
  m_Kill79MsgList     := TGList.Create;
  m_nRecogId          := 0;
  m_BodySurface       := nil;
  m_nGold             := 0;
  m_boVisible         := TRUE;
  m_boHoldPlace       := TRUE;
  m_nCurrentAction    := 0;
  m_boReverseFrame    := FALSE;
  m_nShiftX           := 0;
  m_nShiftY           := 0;
  m_nDownDrawLevel    := 0;
  m_nCurrentFrame     := -1;
  m_nEffectFrame      := -1;

  RealActionMsg.Ident := 0;
  m_sUserName         := '';
  m_nNameColor        := clWhite;
  m_dwSendQueryUserNameTime  := 0; //GetTickCount;
  m_boWarMode                := FALSE;
  m_boCboMode                := False;
  m_dwWarModeTime            := 0;    //War mode
  m_boDeath                  := FALSE;
  m_boSkeleton               := FALSE;
  m_boDelActor               := FALSE;
  m_boDelActionAfterFinished := FALSE;

  m_nChrLight                := 0;
  m_nMagLight                := 0;
  m_boLockEndFrame           := FALSE;
  m_dwSmoothMoveTime         := 0; //GetTickCount;
  m_dwGenAnicountTime        := 0;
  m_dwDefFrameTime           := 0;
  m_dwLoadSurfaceTime        := GetTickCount;
  m_boGrouped                := FALSE;
  m_boOpenHealth             := FALSE;
  m_noInstanceOpenHealth     := FALSE;
  m_CurMagic.ServerMagicCode := 0;

  m_nSpellFrame              := DEFSPELLFRAME;

  m_nNormalSound             := -1;
  m_nFootStepSound           := -1; //����  //���ΰ��ΰ��, CM_WALK, CM_RUN
  m_nAttackSound             := -1;
  m_nWeaponSound             := -1;
  m_nStruckSound             := s_struck_body_longstick;  //������ ���� �Ҹ�    SM_STRUCK
  m_nStruckWeaponSound       := -1;
  m_nScreamSound             := -1;
  m_nDieSound                := -1;    //����    //������ ���� �Ҹ�    SM_DEATHNOW
  m_nDie2Sound               := -1;

  m_nWeaponEffOffset        := 0;
  m_nCboWeaponEffOffset     := 0;

  m_Skill69NH:=0;//��ǰ����ֵ 20080930
  m_Skill69MaxNH:=0;//�������ֵ 20080930
  m_SayColor := 0; //����ͷ��������ɫ��
  m_boIsShop := False;
  m_nMoveTimeStep := 0;
end;


function GetRaceByPM (race: integer; Appr:word): pTMonsterAction;
begin
   Result := nil;
  case Race of
    9{01}: Result:=@MA9; //δ֪
    10{02}: Result:=@MA10; //δ֪
    11{03}: Result:=@MA11; //����¹
    12{04}: Result:=@MA12; //����ʿ
    13{05}: Result:=@MA13; //ʳ�˻�
    14{06}: Result:=@MA14; //����ϵ�й�
    15{07}: Result:=@MA15; //��������
    16{08}: Result:=@MA16; //����
    17{06}: Result:=@MA14; //�๳è
    18{06}: Result:=@MA14; //������
    19{0A}: Result:=@MA19; //�����ˡ���󡡢��֩��֮���
    20{0A}: Result:=@MA19; //��������
    21{0A}: Result:=@MA19; //�������
    22{07}: Result:=@MA15; //����սʿ������֩��
    23{06}: Result:=@MA14; //��������
    24{04}: Result:=@MA12; //��������
    30{09}: Result:=@MA17; //δ֪
    31{09}: Result:=@MA17; //�۷�
    32{0F}: Result:=@MA24; //Ы��
    33{10}: Result:=@MA25; //������
    34{11}: Result:=@MA30; //���¶�ħ�����䡢ǧ������
    35{12}: Result:=@MA31; //δ֪
    36{13}: Result:=@MA32; //475E48
    37{0A}: Result:=@MA19; //475DDC
    40{0A}: Result:=@MA19; //475DDC
    41{0B}: Result:=@MA20; //475DE8
    42{0B}: Result:=@MA20; //475DE8
    43{0C}: Result:=@MA21; //475DF4
    45{0A}: Result:=@MA19; //475DDC
    47{0D}: Result:=@MA22; //�������
    48{0E}: Result:=@MA23; //475E0C
    49{0E}: Result:=@MA23; //�������
    50{27}: begin//NPC
      case Appr of
        23{01}: Result:=@MA36; //475F77
        24{02}: Result:=@MA37; //475F80
        25{02}: Result:=@MA37; //475F80
        26{00}: Result:=@MA35; //475F9B
        27{02}: Result:=@MA37; //475F80
        28{00}: Result:=@MA35; //475F9B
        29{00}: Result:=@MA35; //475F9B
        30{00}: Result:=@MA35; //475F9B
        31{00}: Result:=@MA35; //475F9B
        32{02}: Result:=@MA37; //475F80
        33{00}: Result:=@MA35; //475F9B
        34{00}: Result:=@MA35; //475F9B
        35{03}: Result:=@MA41; //475F89
        36{03}: Result:=@MA41; //475F89
        37{03}: Result:=@MA41; //475F89
        38{03}: Result:=@MA41; //475F89
        39{03}: Result:=@MA41; //475F89
        40{03}: Result:=@MA41; //475F89
        41{03}: Result:=@MA41; //475F89
        42{04}: Result:=@MA46; //475F92
        43{04}: Result:=@MA46; //475F92
        44{04}: Result:=@MA46; //475F92
        45{04}: Result:=@MA46; //475F92
        46{04}: Result:=@MA46; //475F92
        47{04}: Result:=@MA46; //475F92
        48{03}: Result:=@MA41; //4777B3
        49{03}: Result:=@MA41; //4777B3
        50{03}: Result:=@MA41; //4777B3
        51{00}: Result:=@MA35; //4777C5
        52{03}: Result:=@MA41; //4777B3
        53{03}: Result:=@MA35; //������� 20081024
        54..58: Result:=@MA50; //ѩ��
        59,64{03}: Result:=@MA51; //ѩ�� ����¯
        60,62: Result:=@MA70; //����, ���ر���  20080301
        63{03}: Result:=@MA41; //ʥ������
        61{03}: Result:=@MA72; //ʥ����NPC
        65..66: Result:=@MA70;  //��������  20080301
        70..75: Result:=@MA70;  //����NPC
        90..93: Result:=@MA70; //������Ŀձ���NPC,93Ϊ9���걦��
        82..84: Result:=@MA71; //�ƹ�3������NPC 20080308
        99..101: Result:=@MA37; //NPC2
        103: Result := @MA51; //���籭
        107..112: Result := @MA51; //ɳ����NPC
        113..118: Result := @MA51;
        else Result:=@MA35;
      end;
    end;

    52{0A}: Result:=@MA19; //475DDC
    53{0A}: Result:=@MA19; //475DDC
    54{14}: Result:=@MA28; //475E54
    55{15}: Result:=@MA29; //475E60
    60{16}: Result:=@MA33; //475E6C
    61{16}: Result:=@MA33; //475E6C
    62{16}: Result:=@MA33; //475E6C
    63{17}: Result:=@MA34; //475E78
    64{18}: Result:=@MA19; //475E84
    65{18}: Result:=@MA19; //475E84
    66{18}: Result:=@MA19; //475E84
    67{18}: Result:=@MA19; //475E84
    68{18}: Result:=@MA19; //475E84
    69{18}: Result:=@MA19; //475E84
    70{19}: Result:=@MA33; //475E90
    71{19}: Result:=@MA33; //475E90
    72{19}: Result:=@MA33; //475E90
    73{1A}: Result:=@MA19; //475E9C
    74{1B}: Result:=@MA19; //475EA8
    75{1C}: Result:=@MA39; //475EB4
    76{1D}: Result:=@MA38; //475EC0
    77{1E}: Result:=@MA39; //475ECC
    78{1F}: Result:=@MA40; //475ED8
    79{20}: Result:=@MA19; //475EE4
    80{21}: Result:=@MA42; //475EF0
    81{22}: Result:=@MA43; //475EFC
    83{23}: Result:=@MA44; //��������  20080305
    84{24}: Result:=@MA45; //475F14
    85{24}: Result:=@MA45; //475F14
    86{24}: Result:=@MA45; //475F14
    87{24}: Result:=@MA45; //475F14
    88{24}: Result:=@MA45; //475F14
    89{24}: Result:=@MA45; //475F14
    90{11}: Result:=@MA30; //475E30
    98{25}: Result:=@MA27; //475F20
    99{26}: Result:=@MA26; //475F29
    91{27}: Result:=@MA49;
    92: Result := @MA19;   //����֩��
    93: Result := @MA93;  //��������
    94: Result := @MA94;  //ѩ�򺮱�ħ��ѩ������ħ��ѩ���嶾ħ
    95: Result := @MA95;  //�����ػ���
    96: Result := @MA19;
    97: Result := @MA19;
    100{28}: Result:=@MA100;//����
    101: Result := @MA101;  //������
    102: Result:=@MA102; //ѩ������
    103: Result:=@MA14; //ѩ����ʿ
    104: Result:=@MA104; //ѩ����ʿ
    105: Result:=@MA102; //ѩ��ս��
    106: Result:=@MA105;  //ѩ���콫
    107: Result:=@MA103;  //ѩ��ħ��
    108: Result:=@MA14;
    109: Result:=@MA14;
    110: Result:=@MA14;
    111: Result:=@MA106; //
    112: Result:=@MA107;
    113: Result:=@MA108;
    114: Result:=@MA47;
    115: Result:=@MA48;
    116: Result:=@MA14;
    117: Result:=@MA44;
    118: Result:=@MA19;
    119: Result:=@MA110; //�ϻ�
    120,123: Result:=@MA120;
    121: Result:=@MA121;
    122: Result:=@MA122;
  end

end;

//�����������òȷ����ͼƬ���еĿ�ʼλ��
function GetOffset (appr: integer): integer;
var
  nrace, npos: integer;
begin
  Result := 0;
  if (appr > 9999) then Exit;
  
  if appr > 999 then begin
    nrace := appr div 100;         //ͼƬ��
    npos := appr mod 100;          //ͼƬ���е��������
  end else begin
    nrace := appr div 10;         //ͼƬ��
    npos := appr mod 10;          //ͼƬ���е��������
  end;
  case nrace of
    0:    Result := npos * 280;
    1:    Result := npos * 230;
    2,3,7..12:Result := npos * 360;
    4: begin
      Result := npos * 360;        //
      if npos = 1 then Result := 600;
    end;
    5: Result := npos * 430;   //
    6: Result := npos * 440;   //
//      13:   Result := npos * 360;
    13: begin
      case npos of
        0: Result:= 0;
        1: Result:= 360;
        2: Result:= 440;
        3: Result:= 550;
        else Result:= npos * 360;
      end;
    end;
    14: Result := npos * 360;
    15: Result := npos * 360;
    16: Result := npos * 360;
    17: case npos of
          2: Result := 920;
          else Result := npos * 350;
        end;
    18: case npos of  //20080508�޸�    ħ��ϵ�й�
        { 0: Result := 0;   //����
          1: Result := 520;
          2: Result := 950;   }
          0: Result := 0;
          1: Result := 520;
          2: Result := 950;
          3: Result := 1574;
          4: Result := 1934;
          5: Result := 2294;
          6: Result := 2654;
          7: Result := 3014;
        end;
      19:   case npos of
               0: Result := 0;   //����
               1: Result := 370;
               2: Result := 810;
               3: Result := 1250;
               4: Result := 1630;
               5: Result := 2010;
               6: Result := 2390;
            end;
      20:   case npos of
               0: Result := 0;   //����
               1: Result := 360;
               2: Result := 720;
               3: Result := 1080;
               4: Result := 1440;
               5: Result := 1800;
               6: Result := 2350;
               7: Result := 3060;
            end;
      21:   case npos of
               0: Result := 0;   //����
               1: Result := 460;
               2: Result := 820;
               3: Result := 1180;
               4: Result := 1540;
               5: Result := 1900;
//               6: Result := 2260;
               6: Result := 2440;
               7: Result := 2570;
               8: Result := 2700;
            end;
      22:   case npos of
               0: Result := 0;
               1: Result := 430;
               2: Result := 1290;
               3: Result := 1810;
            end;
      23:   case npos of    //20080328 24.wil ��չ
               0: Result := 0;
               1: Result := 340;
               2: Result := 680;
               3: Result := 1180;
               4: Result := 1770;
               5: Result := 2610;
               6: Result := 2950;
               7: Result := 3290;
               8: Result := 3750;
               9: Result := 4100;
              10: Result := 4460;
              11: Result := 4810;
            end;
      24:   case npos of    //20081213 25.wil��չ
               0: Result := 0;
               1: Result := 510;
               2: Result := 1090; 
            end;
      25:   case npos of   //20081213 26.wil��չ
               0: Result := 0;
               1: Result := 510;
               2: Result := 1020;
               3: Result := 1370;
               4: Result := 1720;
               5: Result := 2070;
               6: Result := 2740;
               7: Result := 3780;
               8: Result := 3820;
               9: Result := 4170;
            end;
      26:   case npos of  //20081213 27.wil��չ
               0: Result := 0;
               1: Result := 340;
               2: Result := 680;
               3: Result := 1190;
               4: Result := 1930;
               5: Result := 2100;
               6: Result := 2440;
               7: Result := 2540;
               8: Result := 3570;
            end;
      27:   case npos of  //20091217 28.wil��չ
               0: Result := 0;
               1: Result := 350;
               2: Result := 1560;
               3: Result := 1910;
            end;
      28: case npos of
          	0: Result := 0;
            1: Result := 600;
          end;
      29:   Result := npos * 360; //30.wil��չ
      32: case npos of //33.wil
            0: Result := 0;
            1: Result := 440;
            2: Result := 820;
            3: Result := 1360;
            4: Result := 2590;
            5: Result := 2680;
            6: Result := 2790;
            7: Result := 2900;
            8: Result := 3500;
            9: Result := 3930;
           10: Result := 4370;
           11: Result := 4440;
          end;
      33: case npos of //34.wil
      			0: Result := 20;
            1: Result := 720;
            2: Result := 1160;
            else Result := npos * 360;
		      end;
      34: case npos of //35.wil
            0: Result := 0; //�ϻ�
            1: Result := 680; //��
          end;
      35: case npos of //36.wil By TasNat at: 2012-10-18 10:00:27
            0: Result := 0;
            1: Result := 810;
            2: Result := 1780;
            3: Result := 1800;
            4: Result := 2610;
            5: Result := 3420;
            6: Result := 4390;
            7: Result := 5200;
            8: Result := 6170;
            9: Result := 6980;
          end;

      36: case npos of //36.wil By TasNat at: 2012-10-18 10:18:19
            0: Result := 7790;
            1: Result := 8760; 
            2: Result := 9570; 
            3: Result := 10380;
            4: Result := 11030;
            5: Result := 12000;
            6: Result := 13800;
            7: Result := 14770;
            8: Result := 15580;
            9: Result := 16390;
          end;

      37: case npos of //36.wil By TasNat at: 2012-10-18 10:18:19
            0: Result := 17360;
            1: Result := 18330;
            2: Result := 19300;
            3: Result := 20270;
            4: Result := 21240; 
            5: Result := 22050; 
            6: Result := 22860;
            7: Result := 23990; 
            8: Result := 24800;
            9: Result := 25930; 
          end;
      38: case npos of //37.wil By TasNat at: 2012-10-18 10:18:19
            0: Result := 0;
            1: Result := 400;
            2: Result := 960; 
            3: Result := 1440;
            4: Result := 1840;
            5: Result := 2240;
            6: Result := 2840;
          end;

      80:   case npos of
               0: Result := 0;   //����
               1: Result := 80;
               2: Result := 300;
               3: Result := 301;
               4: Result := 302;
               5: Result := 320;
               6: Result := 321;
               7: Result := 322;
               8: Result := 321;
            end;
      90:   case npos of
               0: Result := 80;   //����
               1: Result := 168;
               2: Result := 184;
               3: Result := 200;
               4: Result := 1770;
               5: Result := 1790;
               6: Result := 1780;
              10..12: Result := (npos-10)*360; //ǿ������
              13..15: Result := 1910; //28WIL���ǿ��ʥ��
            end
      else Result := npos * 360;
   end;
end;

// liuzhigang �� NPC ����ط��ӣ�����ƫ����
function GetNpcOffset(nAppr:Integer):Integer;
var
  Idx: Integer;
begin
  Result:=0;
  case nAppr of
    //npc.wil
    24,25: Result:=(nAppr - 24) * 60 + 1470;
    0..22: Result:=nAppr * 60;
    23: Result:=1380;
    27,32: Result:=(nAppr - 26) * 60 + 1620 - 30;
    26,28,29,30,31,33..41: Result:=(nAppr - 26) * 60 + 1620;
    42,43: Result:=2580;
    44..47: Result:=2640;
    48..50: Result:=(nAppr - 48) * 60 + 2700;
    51: Result:=2880;
    52: Result:=2960;
    53: Result:=4180;
    //ѩ��NPC
    54: Result:=4490;
    55: Result:=4500;
    56: Result:=4510;
    57: Result:=4520;
    58: Result:=4530;
    59: Result:=4540;
    60: Result:=4240; //����NPC
    61: Result:=4770; //ʥ����
    62: Result:=3180; //���ر��� NPC 20080301
    63: Result:=4810; //ʥ������
    64: Result:=4560; //����¯
    //����
    70: Result:=3780;
    71: Result:=3790;
    72: Result:=3800;
    73: Result:=3810;
    74: Result:=3820;
    75: Result:=3830;
    90: Result:=3750; //������Ŀձ���NPC  20080301
    91: Result:=3760; //������Ŀձ���NPC  20080301
    92: Result:=3770; //������Ŀձ���NPC  20080301
    93: Result:=3600; //9���걦��
    65: Result:=3360; //�������� NPC 20080301 ��λ1
    66: Result:=3380; //�������� NPC 20080301 ��λ2
    67: Result:=4060; //�귨����
    68: Result:=4120; //ǧ��ů�����ʦ
    80: Result:=3840; //�ƹݵĵ�С�� 20080308
    81: Result:=3900; //�ƹ��ϰ���  20080308
    82: Result:=3960; //�ƹ�Ӱ�� 20080308
    83: Result:=3980; //�ƹݳ��� 20080308
    84: Result:=4000; //�ƹ����� 20080308
    //npc2.wil
    95..98,102,104,105: Result:= (nAppr-95) * 70;
    99..101: Result := (nAppr - 99) * 70 + 250;
    103: Result := 560;
    106: Result := 740;
    107..112: Result := (nAppr - 99) * 10 + 730;
    113..115: Result := (nAppr - 99) * 30 + 450;
    116..118: Result := (nAppr - 99) * 10 + 800;
  end;
end;

destructor TActor.Destroy;
var
  I: Integer;
begin
  if m_MsgList.Count > 0 then //20080629
  for I := 0 to m_MsgList.Count - 1 do begin
    if pTChrMsg(m_MsgList.Items[I]) <> nil then Dispose(pTChrMsg(m_MsgList.Items[I]));
  end;
  m_MsgList.Clear;
  FreeAndNil(m_MsgList);
  if m_Kill79MsgList.Count > 0 then
  for I:=0 to m_Kill79MsgList.Count - 1 do begin
    if pTChrMsg(m_Kill79MsgList[I]) <> nil then Dispose(pTChrMsg(m_Kill79MsgList[I]));
  end;
  m_Kill79MsgList.Clear;
  FreeAndNil(m_Kill79MsgList);
  {$IF M2Version <> 2}
  for I:=0 to m_nMoveHpList.Count-1 do begin
    Dispose(pTMoveHMShow(m_nMoveHpList.Items[I]));
  end;
  FreeAndNil(m_nMoveHpList);
  {$IFEND}
  inherited Destroy;
end;


//��ɫ���յ�����Ϣ
procedure  TActor.SendMsg(wIdent:Word; nX,nY, ndir,nFeature,nState:Integer;sStr:String;nSound:Integer; NewFeature: TFeatures);
var
  Msg:pTChrMsg;
begin
  m_MsgList.Lock;
  try
    New(Msg);
    Msg.ident   := wIdent;
    Msg.x       := nX;
    Msg.y       := nY;
    Msg.dir     := ndir;
    Msg.feature := nFeature;
    Msg.state   := nState;
    Msg.saying  := sStr;
    Msg.Sound   := nSound;
    Msg.NewFeature := NewFeature;
    m_MsgList.Add(Msg);
  finally
    m_MsgList.UnLock;
  end;
end;

//׷�Ĵ̸ı��������Ϣ�б�
procedure  TActor.Kill79SendMsg(wIdent:Word; nX,nY, ndir,nFeature,nState:Integer;sStr:String;nSound:Integer);
var
  Msg:pTChrMsg;
begin
  m_Kill79MsgList.Lock;
  try
    New(Msg);
    Msg.ident   := wIdent;
    Msg.x       := nX;
    Msg.y       := nY;
    Msg.dir     := ndir;
    Msg.feature := nFeature;
    Msg.state   := nState;
    Msg.saying  := sStr;
    Msg.Sound   := nSound;
    m_Kill79MsgList.Add(Msg);
  finally
    m_Kill79MsgList.UnLock;
  end;
end;
//������Ϣ���£����Ѿ����ڣ���Ϣ�б�
procedure TActor.UpdateMsg(wIdent:Word; nX,nY, ndir,nFeature,nState:Integer;sStr:String;nSound:Integer; NewFeature: TFeatures);
var
  I: integer;
  Msg:pTChrMsg;
begin
  m_MsgList.Lock;
  try
    I:= 0;
    while TRUE do begin
      //�ӵ�ǰ��Ϣ�б���Ѱ��,���ҵ�,��ɾ��,ͬʱ�����ǰ��ҿ��ƵĽ�ɫ���ߡ��ܵ���Ϣ����Ϊ��Щ��Ϣ�Ѿ������ˡ�
      if I >= m_MsgList.Count then break;
      Msg:=m_MsgList.Items[I]; //ԭ����
      if ((Self = g_MySelf) and (Msg.Ident >= 3000) and (Msg.Ident <= 3099)) or (Msg.Ident = wIdent) then begin
        Dispose(Msg);       //ɾ���Ѿ����ڵ���ͬ��Ϣ
        m_MsgList.Delete(I);
        Continue;
      end;
      Inc(I);
    end;
  finally
    m_MsgList.UnLock;
  end;
  SendMsg (wIdent,nX,nY,nDir,nFeature,nState,sStr,nSound, NewFeature);   //�����Ϣ
end;

//�����Ϣ����[3000,3099]֮�����Ϣ
procedure TActor.CleanUserMsgs;
var
  I:Integer;
  Msg:pTChrMsg;
begin
  m_MsgList.Lock;
  try
    I:= 0;
    while TRUE do begin
      if I >= m_MsgList.Count then break;
      Msg:=m_MsgList.Items[I];
      {if (Msg.Ident >= 3000) and //�����˶���Ϣ���ߡ��ܵ�
         (Msg.Ident <= 3099) then begin }
       if (Msg.Ident > 2999) and //�����˶���Ϣ���ߡ��ܵ�
         (Msg.Ident < 3100) then begin
        Dispose(Msg); 
        m_MsgList.Delete (I);
        Continue;
      end;
      Inc(I);
    end;
  finally
    m_MsgList.UnLock;
  end;
end;

//��ɫ��������
procedure TActor.CalcActorFrame;
begin
  m_boUseMagic    := FALSE;
  m_nCurrentFrame := -1;
  //����appr���㱾��ɫ��ͼƬ���еĿ�ʼͼƬ����
  m_nBodyOffset   := GetOffset (m_wAppearance);
  //������Ӧ��ͼƬ���ж���
  m_Action := GetRaceByPM(m_btRace,m_wAppearance);
  if m_Action = nil then exit;
   case m_nCurrentAction of
      SM_TURN://ת��=վ�������Ŀ�ʼ֡ + ���� X վ��������ͼƬ��
         begin
            m_nStartFrame := m_Action.ActStand.start + m_btDir * (m_Action.ActStand.frame + m_Action.ActStand.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
            m_dwFrameTime := m_Action.ActStand.ftime;
            m_dwStartTime := GetTickCount;
            m_nDefFrameCount := m_Action.ActStand.frame;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_WALK{��}, SM_RUSH, SM_RUSHKUNG, SM_BACKSTEP:  //�߶�=�߶������Ŀ�ʼ֡ + ���� X ÿ�����߶�������ͼƬ��
         begin
            m_nStartFrame := m_Action.ActWalk.start + m_btDir * (m_Action.ActWalk.frame + m_Action.ActWalk.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActWalk.frame - 1;
            m_dwFrameTime := m_Action.ActWalk.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := m_Action.ActWalk.UseTick;
            m_nCurTick := 0;
            m_nMoveStep := 1;
            if m_nCurrentAction = SM_BACKSTEP then    //����
               Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1)
            else
               Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
         end;
      {SM_BACKSTEP:
         begin
            startframe := pm.ActWalk.start + (pm.ActWalk.frame - 1) + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
            m_nEndFrame := startframe - (pm.ActWalk.frame - 1);
            m_dwFrameTime := pm.ActWalk.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := pm.ActWalk.UseTick;
            m_nCurTick := 0;
            m_nMoveStep := 1;
            Shift (GetBack(Dir), m_nMoveStep, 0, m_nEndFrame-startframe+1);
         end;}
      SM_HIT{��ͨ����}:
         begin
            m_nStartFrame := m_Action.ActAttack.start + m_btDir * (m_Action.ActAttack.frame + m_Action.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
            m_dwFrameTime := m_Action.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            //WarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_STRUCK:{�ܹ���}
         begin
            m_nStartFrame := m_Action.ActStruck.start + m_btDir * (m_Action.ActStruck.frame + m_Action.ActStruck.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActStruck.frame - 1;
            m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
            m_dwStartTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_DEATH:   //������
         begin
            m_nStartFrame := m_Action.ActDie.start + m_btDir * (m_Action.ActDie.frame + m_Action.ActDie.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
            m_nStartFrame := m_nEndFrame; //
            m_dwFrameTime := m_Action.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_NOWDEATH: //����
         begin
            m_nStartFrame := m_Action.ActDie.start + m_btDir * (m_Action.ActDie.frame + m_Action.ActDie.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
            m_dwFrameTime := m_Action.ActDie.ftime;
            m_dwStartTime := GetTickCount;
         end;
      SM_SKELETON:  //�������ˣ����ٶ�����
         begin
            m_nStartFrame := m_Action.ActDeath.start + m_btDir;
            m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
            m_dwFrameTime := m_Action.ActDeath.ftime;
            m_dwStartTime := GetTickCount;
         end;
   end;
end;

procedure TActor.ReadyAction (msg: TChrMsg);
var
   n: integer;
   UseMagic: PTUseMagicInfo;
begin
   m_nActBeforeX := m_nCurrX;        //����֮ǰ��λ�ã������������Ͽ�ʱ���Ի�ȥ)
   m_nActBeforeY := m_nCurrY;

   if msg.Ident = SM_ALIVE then begin      //����
      m_boDeath := FALSE;
      m_boSkeleton := FALSE;
   end;
   if not m_boDeath then begin
      case msg.Ident of
         SM_TURN, SM_WALK, SM_NPCWALK, SM_BACKSTEP, SM_RUSH, SM_RUSHKUNG, SM_RUN, {SM_HORSERUN,20080803ע��������Ϣ} SM_DIGUP, SM_ALIVE:
            begin
               m_nFeature := msg.NewFeature;
               m_nState := msg.state;
               //�Ƿ���Բ鿴��ɫ����ֵ
               if m_nState and STATE_OPENHEATH <> 0 then m_boOpenHealth := TRUE
               else m_boOpenHealth := FALSE;
            end;
      end;
      if msg.ident = SM_LIGHTING then n := 0;
      if (g_MySelf = self) then begin
         if (msg.Ident = CM_WALK) then
            if not PlayScene.CanWalk (msg.x, msg.y) then exit;  //��������
         if (msg.Ident = CM_RUN) then
            if not PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, msg.x, msg.y) then exit; //������
         {if (msg.Ident = CM_HORSERUN) then  20080803ע��������Ϣ
            if not PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, msg.x, msg.y) then
               exit;   }
         //msg
         case msg.Ident of
            CM_TURN,
            CM_WALK,
            CM_SITDOWN,
            CM_RUN,
            CM_HIT,
            CM_HEAVYHIT,
            CM_BIGHIT,
            CM_WIDEHIT:
               begin
                  RealActionMsg := msg; //���浱ǰ����
                  msg.Ident := msg.Ident - 3000;  //SM_?? ���� ��ȯ ��
               end;
            CM_POWERHIT: begin
              RealActionMsg := msg; //���浱ǰ����
              case msg.feature of
                1..3: msg.Ident := SM_POWERHITEX1;
                4..6: msg.Ident := SM_POWERHITEX2;
                7..9: msg.Ident := SM_POWERHITEX3;
                else msg.Ident := msg.Ident - 3000; 
              end;
            end;
            CM_HIT_107: begin
              RealActionMsg := msg;
              msg.Ident := SM_HIT_107;
            end;
            {CM_HORSERUN: begin  20080803ע��������Ϣ
              RealActionMsg:=msg;
              msg.Ident:=SM_HORSERUN;
            end; }
            {CM_THROW: begin
              if m_nFeature <> 0 then begin
                m_nTargetX := TActor(msg.feature).m_nCurrX;  //x ������ ��ǥ
                m_nTargetY := TActor(msg.feature).m_nCurrY;    //y
                m_nTargetRecog := TActor(msg.feature).m_nRecogId;
              end;
              RealActionMsg := msg;
              msg.Ident := SM_THROW;
            end;    }
            {$IF M2Version <> 2}
            CM_LONGHITFORFENGHAO: begin //��ɫ��ɱ����
              RealActionMsg := msg;
              msg.Ident := SM_LONGHITFORFENGHAO;
            end;
            CM_FIREHITFORFENGHAO: begin //��ɫ�һ���
              RealActionMsg := msg;
              msg.Ident := SM_FIREHITFORFENGHAO;
            end;
            CM_DAILYFORFENGHAO: begin //��ɫ���ս���
              RealActionMsg := msg;
              msg.Ident := SM_DAILYFORFENGHAO;
            end;
            {$IFEND}
            CM_FIREHIT: begin  //�һ�
              RealActionMsg := msg;
              case msg.feature of
                1..3: msg.Ident := SM_FIREHITEX1;
                4..6: msg.Ident := SM_FIREHITEX2;
                7..9: msg.Ident := SM_FIREHITEX3;
                else msg.Ident := SM_FIREHIT;
              end;
            end;
            {CM_69HIT: begin  //����ٵ�
              RealActionMsg := msg;
              msg.Ident := SM_69HIT;
            end; }
            CM_BATTERHIT1: begin //׷�Ĵ�
              RealActionMsg := msg;
              msg.Ident := SM_BATTERHIT1;
            end;
            CM_LONGHIT: begin //��ɱ
              RealActionMsg := msg; //���浱ǰ����
              case msg.feature of
                1..3: msg.Ident := SM_LONGHITEX1;
                4..6: msg.Ident := SM_LONGHITEX2;
                7..9: msg.Ident := SM_LONGHITEX3;
                else msg.Ident := msg.Ident - 3000; 
              end;
            end;
            CM_LONGHIT4: begin //4����ɱ
              RealActionMsg := msg;
              case msg.feature of
                1..3: msg.Ident := SM_LONGHITEX1;
                4..6: msg.Ident := SM_LONGHITEX2;
                7..9: msg.Ident := SM_LONGHITEX3;
                else msg.Ident := SM_LONGHIT4; 
              end;
            end;
            CM_WIDEHIT4: begin   //Բ���䵶
              RealActionMsg := msg;
              case msg.feature of
                1..3: msg.Ident := SM_WIDEHIT4EX1;
                4..6: msg.Ident := SM_WIDEHIT4EX2;
                7..9: msg.Ident := SM_WIDEHIT4EX3;
                else msg.Ident := SM_WIDEHIT4;
              end;
            end;
            CM_BATTERHIT2: begin //����ɱ
              RealActionMsg := msg;
              msg.Ident := SM_BATTERHIT2;
            end;
            CM_BATTERHIT3: begin //��ɨǧ��
              RealActionMsg := msg;
              msg.Ident := SM_BATTERHIT3;
            end;
            CM_BATTERHIT4: begin //����ն
              RealActionMsg := msg;
              msg.Ident := SM_BATTERHIT4;
            end;
            CM_4FIREHIT: begin  //4���һ�
              RealActionMsg := msg;
              case msg.feature of
                1..3: msg.Ident := SM_FIREHITEX1;
                4..6: msg.Ident := SM_FIREHITEX2;
                7..9: msg.Ident := SM_FIREHITEX3;
                else msg.Ident := SM_4FIREHIT;
              end;
            end;
            CM_DAILY: begin //���ս��� 20080511
              RealActionMsg := msg;
              case msg.feature of
                1..3: msg.Ident := SM_DAILYEX1;
                4..6: msg.Ident := SM_DAILYEX2;
                7..9: msg.Ident := SM_DAILYEX3;
                else msg.Ident := SM_DAILY;
              end;
            end;
            CM_BLOODSOUL: begin //Ѫ��һ��(ս)
              RealActionMsg := msg;
              msg.Ident := SM_BLOODSOUL;
            end;
            CM_CRSHIT: begin
              RealActionMsg := msg;
              msg.Ident := SM_CRSHIT;
            end;
            CM_TWINHIT: begin
              RealActionMsg := msg;
              msg.Ident := SM_TWINHIT;
            end;
            CM_QTWINHIT: begin   //����ն��� 2008.02.12
              RealActionMsg := msg;
              msg.Ident := SM_QTWINHIT;
            end;
            CM_CIDHIT: begin {��Ӱ����}
              RealActionMsg := msg;
              msg.Ident := SM_CIDHIT;
            end;
            CM_3037: begin
              RealActionMsg := msg;
              msg.Ident := SM_41;
            end;
            CM_SELFSHOPITEMS: begin   //��̯
              frmMain.SendShopMsg(msg.Ident, msg.saying);
              Exit;
            end;
            CM_SPELL: begin
                  RealActionMsg := msg;
                  UseMagic := PTUseMagicInfo (msg.feature);   //����msg.feature���pmagָ��
                  RealActionMsg.Dir := UseMagic.MagicSerial;
                  msg.Ident := msg.Ident - 3000;  //SM_?? ���� ��ȯ ��
            end;
         end;
         m_nOldx := m_nCurrX;
         m_nOldy := m_nCurrY;     
         m_nOldDir := m_btDir;
      end;
      case msg.Ident of
         SM_STRUCK:
            begin
               //Abil.HP := msg.x; {HP}
               //Abil.MaxHP := msg.y; {maxHP}
               //msg.dir {damage}
               m_nMagicStruckSound := msg.x; 
               n := Round (200 - m_Abil.Level * 5);
               if n > 80 then m_dwStruckFrameTime := n
               else m_dwStruckFrameTime := 80;
               //m_dwLastStruckTime := GetTickCount;  20080521 ע��û�õ�����
            end;
         SM_SPELL:
            begin
               m_btDir := msg.dir;
               //msg.x  :targetx
               //msg.y  :targety
               UseMagic := PTUseMagicInfo (msg.feature);
               if UseMagic <> nil then begin
                  m_CurMagic := UseMagic^;
                  m_CurMagic.ServerMagicCode := -1; //FIRE ���
                  //CurMagic.MagicSerial := 0;
                  m_CurMagic.TargX := msg.x;
                  m_CurMagic.TargY := msg.y;
                  Dispose (UseMagic);
               end;
            end;
         SM_RUSHKUNG: begin  //20080409  ��ֹӢ����Ұ����ʧ
               m_nFeature := msg.NewFeature;
               m_nState := msg.state;
               //�Ƿ���Բ鿴��ɫ����ֵ
               if m_nState and STATE_OPENHEATH <> 0 then m_boOpenHealth := TRUE
               else m_boOpenHealth := FALSE;
         end;
         SM_FLYAXE: begin
           if m_btRace <> 116 then begin
             m_nCurrX := msg.x;
             m_nCurrY := msg.y;
           end;
           m_btDir := msg.dir;
         end;
         else begin  //�˾����ü���ʧ�� �����ܵ���Ϣ����ȥ  20080409
               m_nCurrX := msg.x;
               m_nCurrY := msg.y;
               m_btDir := msg.dir;
            end;
      end;

      m_nCurrentAction := msg.Ident;
      CalcActorFrame;
      //DScreen.AddSysMsg (IntToStr(msg.Ident) + ' ' + IntToStr(XX) + ' ' + IntToStr(YY) + ' : ' + IntToStr(msg.x) + ' ' + IntToStr(msg.y));
   end else begin
      if msg.Ident = SM_SKELETON then begin
         m_nCurrentAction := msg.Ident;
         CalcActorFrame;
         m_boSkeleton := TRUE;
      end;
   end;
   if (msg.Ident = SM_DEATH) or (msg.Ident = SM_NOWDEATH) then begin
      m_boDeath := TRUE;
      //m_dwDeathTime := GetTickCount;
      PlayScene.ActorDied (self);
   end;
   RunSound;
end;

function TActor.GetKill79Message(ChrMsg:pTChrMsg): Boolean;
var
  Msg:pTChrMsg;
begin
  Result:=False;
  m_Kill79MsgList.Lock;
  try
    if m_Kill79MsgList.Count > 0 then begin
      Msg:=pTChrMsg(m_Kill79MsgList.Items[0]);
      if GetTickCount - m_dwKill79Time > 100 then begin
        ChrMsg.Ident:=Msg.Ident;
        ChrMsg.X:=Msg.X;
        ChrMsg.Y:=Msg.Y;
        ChrMsg.Dir:=Msg.Dir;
        ChrMsg.State:=Msg.State;
        ChrMsg.feature:=Msg.feature;
        ChrMsg.saying:=Msg.saying;
        ChrMsg.Sound:=Msg.Sound;
        Dispose(Msg);
        m_Kill79MsgList.Delete(0);
        m_dwKill79Time := GetTickCount;
        Result:=True;
      end;
    end;
  finally
    m_Kill79MsgList.UnLock;
  end;
end;

function TActor.GetMessage(ChrMsg:pTChrMsg): Boolean;
var
  Msg:pTChrMsg;
begin
  Result:=False;
  m_MsgList.Lock;
  try
    if m_MsgList.Count > 0 then begin
      Msg:=pTChrMsg(m_MsgList.Items[0]);
      ChrMsg.Ident:=Msg.Ident;
      ChrMsg.X:=Msg.X;
      ChrMsg.Y:=Msg.Y;
      ChrMsg.Dir:=Msg.Dir;
      ChrMsg.State:=Msg.State;
      ChrMsg.feature:=Msg.feature;
      ChrMsg.saying:=Msg.saying;
      ChrMsg.Sound:=Msg.Sound;
      ChrMsg.NewFeature := Msg.NewFeature;
      Dispose(Msg);
      m_MsgList.Delete(0);
      Result:=True;
    end;
  finally
    m_MsgList.UnLock;
  end;
end;

procedure TActor.ProcMsg;
var
  Msg:TChrMsg;
  Meff:TMagicEff;
  ErrCode: Integer;
begin
  ErrCode := 0;
  try
    ErrCode := 1;
    while GetKill79Message(@Msg) do begin
      case Msg.ident of
        SM_RUSH79: begin
          m_nCurrX := msg.x;
          m_nCurrY := msg.y;
          m_nRx := m_nCurrX;
          m_nRy := m_nCurrY;
          m_btDir := msg.dir;
        end;
      end;
    end;
    ErrCode := 2;
    while (m_nCurrentAction = 0) and GetMessage(@Msg) do begin
      case Msg.ident of
         SM_STRUCK: begin
           m_nHiterCode := msg.Sound;
           ReadyAction (msg);
         end;
         SM_DEATH,  //27
         SM_NOWDEATH,
         SM_SKELETON,
         SM_ALIVE,
         SM_ACTION_MIN..SM_ACTION_MAX,  //26
         SM_ACTION2_MIN..SM_ACTION2_MAX,//35   2293    293
         SM_NPCWALK,
         CM_SELFSHOPITEMS, //��̯
         {$IF M2Version <> 2}
         CM_LONGHITFORFENGHAO,
         CM_FIREHITFORFENGHAO,
         CM_DAILYFORFENGHAO,
         {$IFEND}
         3000..3099: ReadyAction (msg);

         SM_SPACEMOVE_HIDE: begin  //�޸Ĵ��͵�ͼ����ʾ���� 20080521
           meff := TScrollHideEffect.Create (250, 10, m_nCurrX, m_nCurrY, self);
           PlayScene.m_EffectList.Add (meff);
           PlaySound (s_spacemove_out);
          {if g_TargetCret <> nil then
            PlayScene.DeleteActor (g_TargetCret.m_nRecogId);  }
         end;
         SM_SPACEMOVE_HIDE2: begin
           meff := TScrollHideEffect.Create (1590, 10, m_nCurrX, m_nCurrY, self);
           PlayScene.m_EffectList.Add (meff);
           PlaySound (s_spacemove_out);
         end;
         SM_SPACEMOVE_SHOW: begin  //�޸Ĵ��͵�ͼ����ʾ���� 20080521
           meff := TCharEffect.Create (260, 10, self);
           PlayScene.m_EffectList.Add (meff);
           msg.ident := SM_TURN;
           ReadyAction (msg);
           PlaySound (s_spacemove_in);
         end;
         SM_SPACEMOVE_SHOW2: begin
           meff := TCharEffect.Create (1600, 10, self);
           PlayScene.m_EffectList.Add (meff);
           msg.ident := SM_TURN;
           ReadyAction (msg);
           PlaySound (s_spacemove_in);
         end;
         SM_SPACEMOVE_SHOW3: begin
           msg.ident := SM_TURN;
           ReadyAction (msg);
         end;
         SM_CRSHIT,SM_TWINHIT,SM_QTWINHIT,SM_CIDHIT, SM_4FIREHIT,
         SM_FAIRYATTACKRATE,SM_BLOODSOUL{Ѫ��һ��(ս)},SM_DAILY{���ս���},
         SM_LEITINGHIT{����һ��սʿЧ�� 20080611},SM_BATTERHIT1,
         SM_BATTERHIT2,SM_BATTERHIT3,SM_BATTERHIT4,
         {$IF M2Version <> 2}SM_LONGHITFORFENGHAO,SM_FIREHITFORFENGHAO,SM_DAILYFORFENGHAO,{$IFEND}
         SM_LONGHIT4, SM_WIDEHIT4, SM_DAILYEX1..SM_DAILYEX3, SM_FIREHITEX1..SM_FIREHITEX3,
         SM_WIDEHIT4EX1..SM_WIDEHIT4EX3, SM_LONGHITEX1..SM_LONGHITEX3: ReadyAction (msg); //���Ӣ�۷ſ�����Ӱ ����������
         else
            begin
              // ReadyAction (msg); //�������ı��ͼ�������� 20080410
            end;
      end;
    end;                            
  except
    DebugOutStr(format('TActor.ProcMsg Code: %d',[ErrCode]));
  end;
end;

procedure TActor.ProcHurryMsg; //������Ϣ����ʹ��ħ����ħ��ʧ��
var
   n: integer;
   msg: TChrMsg;
   fin: Boolean;
begin
   n := 0;
   while TRUE do begin    
      if m_MsgList.Count <= n then break;
      msg := PTChrMsg (m_MsgList[n])^;   //ȡ����Ϣ
      fin := FALSE;
      case msg.Ident of
         SM_MAGICFIRE: begin
            if m_CurMagic.ServerMagicCode <> 0 then begin
               m_CurMagic.ServerMagicCode := 111;
               m_CurMagic.Target := msg.x;
               if msg.y in [0..MAXMAGICTYPE-1] then
               m_CurMagic.EffectType := TMagicType(msg.y); //EffectType
               m_CurMagic.EffectNumber := msg.dir; //Effect
               m_CurMagic.TargX := msg.feature;
               m_CurMagic.TargY := msg.state;
               m_CurMagic.EffectLevelEx := msg.sound; //����
               m_CurMagic.Recusion := TRUE;
               fin := TRUE;
               //���������ʾʹ��ħ�������ƣ����ǿͻ��˲�֪��ħ�������ƣ�
               //Ӧ���ڱ��ر���һ��ħ�������б�����ServerMaigicCode�������
            end;
         end;
         SM_MAGICFIRE_FAIL: begin
            if m_CurMagic.ServerMagicCode <> 0 then begin
               m_CurMagic.ServerMagicCode := 0;
               fin := TRUE;
            end;
         end;
      end;
      if fin then begin
         Dispose (PTChrMsg (m_MsgList[n]));
         m_MsgList.Delete (n);
      end else
         Inc (n);
   end;
end;

//��ǰ�Ƿ�û�п�ִ�еĶ���
function  TActor.IsIdle: Boolean;
begin
   if (m_nCurrentAction = 0) and (m_MsgList.Count = 0) then
      Result := TRUE
   else Result := FALSE;
end;
//��ǰ�����Ƿ��Ѿ����
function  TActor.ActionFinished: Boolean;
begin
   if (m_nCurrentAction = 0) or (m_nCurrentFrame >= m_nEndFrame) then
      Result := TRUE
   else Result := FALSE;
end;
//�ɷ�����
function  TActor.CanWalk: Integer;
begin
   if {(GetTickCount - LastStruckTime < 1300) or}(GetTickCount - g_dwLatestSpellTick < g_dwMagicPKDelayTime) then
      Result := -1   
   else
   if GetTickCount - g_dwLastMoveTick < m_nMoveTimeStep then
     Result := -2
   else
      Result := 1;
end;
//�ɷ���
function  TActor.CanRun: Integer;
begin
   Result := 1;
   //��������HPֵ�Ƿ����ָ��ֵ������ָ��ֵ����������
   if m_Abil.HP < RUN_MINHEALTH then begin
      Result := -1;
   end else
   if GetTickCount - g_dwLastMoveTick < m_nMoveTimeStep then
     Result := -2;
   
   //��������Ƿ񱻹�����������������������ܣ�ȡ����⽫�����ܲ�����
//   if (GetTickCount - LastStruckTime < 3*1000) or (GetTickCount - LatestSpellTime < MagicPKDelayTime) then
//      Result := -2;

end;


//dir : ����
//step : ����  (����1������2��
//cur : ��ǰ֡(ȫ��֡�еĵڼ�֡��
//max : ȫ��֡
procedure TActor.Shift (dir, step, cur, max: integer);
var
   unx, uny, ss, v: integer;
begin
   unx := UNITX * step;
   uny := UNITY * step;
   if cur > max then cur := max;
   m_nRx := m_nCurrX;
   m_nRy := m_nCurrY;
//   ss := Round((max-cur-1) / max) * step;
   case dir of
      DR_UP: begin
        ss := Round((max-cur) / max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY + ss;
        if ss = step then m_nShiftY := -Round(uny / max * cur)
        else m_nShiftY := Round(uny / max * (max-cur));
      end;
      DR_UPRIGHT:
         begin
            if max >= 6 then v := 2
            else v := 0;
            ss := Round((max-cur+v) / max) * step;
            m_nRx := m_nCurrX - ss;
            m_nRy := m_nCurrY + ss;
            if ss = step then begin
               m_nShiftX:=  Round(unx / max * cur);
               m_nShiftY:= -Round(uny / max * cur);
            end else begin
               m_nShiftX:= -Round(unx / max * (max-cur));
               m_nShiftY:=  Round(uny / max * (max-cur));
            end;
         end;
      DR_RIGHT:
         begin
            ss := Round((max-cur) / max) * step;
            m_nRx := m_nCurrX - ss;
            if ss = step then m_nShiftX := Round(unx / max * cur)
            else m_nShiftX := -Round(unx / max * (max-cur));
            m_nShiftY := 0;
         end;
      DR_DOWNRIGHT:
         begin
            if max >= 6 then v := 2
            else v := 0;
            ss := Round((max-cur-v) / max) * step;
            m_nRx := m_nCurrX - ss;
            m_nRy := m_nCurrY - ss;
            if ss = step then begin
               m_nShiftX:= Round(unx / max * cur);
               m_nShiftY:= Round(uny / max * cur);
            end else begin
               m_nShiftX:= -Round(unx / max * (max-cur));
               m_nShiftY:= -Round(uny / max * (max-cur));
            end;
         end;
      DR_DOWN:
         begin
            if max >= 6 then v := 1
            else v := 0;
            ss := Round((max-cur-v) / max) * step;
            m_nShiftX := 0;
            m_nRy := m_nCurrY - ss;
            if ss = step then m_nShiftY := Round(uny / max * cur)
            else m_nShiftY := -Round(uny / max * (max-cur));
         end;
      DR_DOWNLEFT:
         begin
            if max >= 6 then v := 2
            else v := 0;
            ss := Round((max-cur-v) / max) * step;
            m_nRx := m_nCurrX + ss;
            m_nRy := m_nCurrY - ss;
            if ss = step then begin
               m_nShiftX := -Round(unx / max * cur);
               m_nShiftY :=  Round(uny / max * cur);
            end else begin
               m_nShiftX :=  Round(unx / max * (max-cur));
               m_nShiftY := -Round(uny / max * (max-cur));
            end;
         end;
      DR_LEFT:
         begin
            ss := Round((max-cur) / max) * step;
            m_nRx := m_nCurrX + ss;
            if ss = step then m_nShiftX := -Round(unx / max * cur)
            else m_nShiftX := Round(unx / max * (max-cur));
            m_nShiftY := 0;
         end;
      DR_UPLEFT:
         begin
            if max >= 6 then v := 2
            else v := 0;
            ss := Round((max-cur+v) / max) * step;
            m_nRx := m_nCurrX + ss;
            m_nRy := m_nCurrY + ss;
            if ss = step then begin
               m_nShiftX := -Round(unx / max * cur);
               m_nShiftY := -Round(uny / max * cur);
            end else begin
               m_nShiftX := Round(unx / max * (max-cur));
               m_nShiftY := Round(uny / max * (max-cur));
            end;
         end;
   end;
end;

function TActor.GetEffectWil(idx: Byte): TWMImages;
begin
  case idx of
    0: Result := g_WHumWingImages;
    1: Result := g_WHumWing2Images;
    2: Result := g_WWeaponEffectImages;
    3: Result := g_WHumWing3Images;
    4: Result := g_WHumWing4Images;
    5: Result := g_WWeaponEffectImages4;
    else Result := nil;
  end;
end;

//������ò�����ı�
procedure  TActor.FeatureChanged;
begin
   case m_btRace of
      0,1,150: begin //����,Ӣ��,���� 20080629
         m_btHair   := m_nFeature.btHair; //HAIRfeature (m_nFeature);// �õ�M2������Ӧ�ķ��� , Ů=7 ��=6 ����,Ӣ�� Ů=3 ��=4
         m_btDress  := m_nFeature.nDress; //DRESSfeature (m_nFeature);
         m_btWeapon := m_nFeature.nWeapon; //WEAPONfeature (m_nFeature);
         //m_btHorse  := Horsefeature(m_nFeatureEx); 20080721 ע������
         m_btEffect := Effectfeature(m_nFeatureEx);
         m_nBodyOffset := HUMANFRAME * m_btDress; //��0, Ů1
        // haircount := g_WHairImgImages.ImageCount div {HUMANFRAME}1200 div 2; //ÿ�Ա�����=3600 /600 /2 =3
         m_boMagicShield := m_nFeature.btStatus = 1;
        case m_btHair of
          255: begin
            m_nHairOffset := HUMANFRAME * (m_btSex + 6);  //��ͨ����
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 6);  //��ͨ����
          end;
          254: begin
            m_nHairOffset := HUMANFRAME * (m_btSex + 8); //��ɫ����
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 8);  //��ɫ����
          end;
          253: begin
            m_nHairOffset := HUMANFRAME * (m_btSex + 12); //��ɱ����
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 12);  //��ɱ����
          end;
          252: begin
            m_nHairOffset := HUMANFRAME * ({m_btSex +} 10); //��ţ����   Ů�Ķ�������������
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 10);  //��ţ����
          end;
          251: begin //���׶���
            m_nHairOffset := HUMANFRAME * (m_btSex + 14); //��ţ����   Ů�Ķ�������������
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 14);  //��ţ����
          end;
          250: begin //���涷��
            m_nHairOffset := HUMANFRAME * (m_btSex + 16);
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 16);
          end;
          249: begin //��¶���
            m_nHairOffset := HUMANFRAME * (m_btSex + 18);
            m_nCboHairOffset := NEWHUMANFRAME * (m_btSex + 18);
          end
          else begin
            if m_btSex = 1 then begin //Ů
              if m_btHair = 1 then begin
                m_nCboHairOffset := 2000;
                m_nHairOffset := 600;
              end else begin
                 if m_btHair > 1{haircount-1} then m_btHair := 1{haircount-1};
                 m_btHair := m_btHair * 2;
                 if m_btHair > 1 then begin
                   m_nCboHairOffset := NEWHUMANFRAME * (m_btHair + m_btSex);
                   m_nHairOffset := HUMANFRAME * (m_btHair + m_btSex);
                 end else begin
                   m_nCboHairOffset := -1;
                   m_nHairOffset := -1;
                 end;
              end;
            end else begin                 //��
              if m_btHair = 0 then begin
                m_nCboHairOffset := -1;
                m_nHairOffset := -1;
              end else begin
                 if m_btHair > 1{haircount-1} then m_btHair := 1{haircount-1};
                 m_btHair := m_btHair * 2;
                 if m_btHair > 1 then begin
                    m_nCboHairOffset := NEWHUMANFRAME * (m_btHair + m_btSex);
                    m_nHairOffset := HUMANFRAME * (m_btHair + m_btSex);
                 end else begin
                   m_nHairOffset := -1;
                   m_nCboHairOffset := -1;
                 end;
              end;
            end;
          end;
        end;
        
        m_nWeaponOffset := HUMANFRAME * m_btWeapon;
        if m_nFeature.nWeaponLook <> High(m_nFeature.nWeaponLook) then begin
          if (m_nFeature.nWeaponLook > 2399) and (m_nFeature.nWeaponLookWil = 1) then begin
            m_nWeaponEffOffset := m_nFeature.nWeaponLook + m_btSex * HUMANFRAME;
            m_nCboWeaponEffOffset := (m_nWeaponEffOffset div HUMANFRAME2) * NEWHUMANFRAME2 - 16000 + m_btSex * NEWHUMANFRAME;
          end else begin
            m_nWeaponEffOffset := m_nFeature.nWeaponLook + m_btSex * HUMANFRAME;
            if m_nFeature.nWeaponLookWil <> 2 then
              m_nCboWeaponEffOffset := (m_nWeaponEffOffset div HUMANFRAME2) * NEWHUMANFRAME2 + 40000 + m_btSex * NEWHUMANFRAME;
          end;
        end;
        if m_btEffect = 50 then
          m_nHumWinOffset:=352
        else if m_nFeature.nDressLook <> High(m_nFeature.nDressLook) then begin
          if (m_nFeature.nDressLook > 4799) and (m_nFeature.nDressLookWil = 1) then begin
            m_nHumWinOffset := m_nFeature.nDressLook;
            m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME - 8) * NEWHUMANFRAME;
          end else begin
            m_nHumWinOffset := m_nFeature.nDressLook;
            case m_nFeature.nDressLookWil of
              0,3: m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME;
              1,2: m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME + 40000;
            end;
            {if m_nFeature.nDressLookWil = 0 then
              m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME
            else m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME + 40000; }
          end;
        end;
      end;    
      50: ;  //npc
      else begin
         m_wAppearance := m_nFeature.nDress; //APPRfeature (m_nFeature);
         m_nBodyOffset := GetOffset (m_wAppearance);
      end;
   end;
end;

function   TActor.Light: integer;
begin
   Result := m_nChrLight;
end;

//װ�ص�ǰ������Ӧ��ͼƬ
procedure  TActor.LoadSurface;
var
   mimg: TWMImages;
   nErrCode: Byte;
begin
  nErrCode := 0;
  try
    nErrCode := 1;
     mimg := GetMonImg (m_wAppearance);
     nErrCode := 2;
     if mimg <> nil then begin
        if (not m_boReverseFrame) then begin
          nErrCode := 3;
           m_BodySurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy);
        end else begin
          nErrCode := 4;
           m_BodySurface := mimg.GetCachedImage (
                              GetOffset (m_wAppearance) + m_nEndFrame - (m_nCurrentFrame-m_nStartFrame),
                              m_nPx, m_nPy);

        end;
     end;
  except
    DebugOutStr(ForMat('TActor.LoadSurface Code: %d',[nErrCode]));
  end;
end;
//ȡ��ɫ�Ŀ��
function  TActor.CharWidth: Integer;
begin
   if m_BodySurface <> nil then
      Result := m_BodySurface.Width
   else Result := 48;
end;
//ȡ��ɫ�ĸ߶�
function  TActor.CharHeight: Integer;
begin
   if m_BodySurface <> nil then
      Result := m_BodySurface.Height
   else Result := 70;
end;
//�ж�ĳһ���Ƿ��ǽ�ɫ������
function  TActor.CheckSelect (dx, dy: integer): Boolean;
var
  c:Integer;
begin
  Result := FALSE;
  if m_BodySurface <> nil then begin
    c := m_BodySurface.Pixels[dx, dy];
    if (c <> 0) and
       ((m_BodySurface.Pixels[dx-1, dy] <> 0) and
       (m_BodySurface.Pixels[dx+1, dy] <> 0) and
       (m_BodySurface.Pixels[dx, dy-1] <> 0) and
       (m_BodySurface.Pixels[dx, dy+1] <> 0)) then
     Result := TRUE;
  end;
end;

procedure TActor.DrawEffSurface (dsurface, source: TDirectDrawSurface; ddx, ddy: integer; blend: Boolean; ceff: TColorEffect);
var
  ErrorCode: Integer;
begin
  try
    //����
     ErrorCode := 0;
     if m_nState and $00800000 <> 0 then blend := TRUE;  //�����ʾ
     ErrorCode := 1;
     {if source.Height >= 350 then begin  //20080608 ����������������ĳ������
       drawex(dsurface, ddx, ddy, source, 0, 0, source.Width, source.Height, 0);
       Exit; ////thedeath
     end;}
     ErrorCode := 2;
     if source <> nil then begin
       if not Blend then begin
          if ceff = ceNone then begin    //ɫ����Ч������͸��Ч��ֱ����ʾ
                ErrorCode := 3;
                dsurface.Draw (ddx, ddy, source.ClientRect, source, TRUE);
                ErrorCode := 4;
          end else begin
                //������ɫ���Ч�����ٻ���
                ErrorCode := 5;
                g_ImgMixSurface.SetSize(source.Width, source.Height);
                g_ImgMixSurface.Draw (0, 0, source.ClientRect, source, FALSE);
                ErrorCode := 6;
                DrawEffect (0, 0, g_ImgMixSurface, source, ceff);
                ErrorCode := 7;
                dsurface.Draw (ddx, ddy, source.ClientRect, g_ImgMixSurface, TRUE);
                ErrorCode := 8;
          end;
       end else begin
          if ceff = ceNone then begin
                ErrorCode := 9;
                //DrawBlend (dsurface, ddx, ddy, source, 0,120);
                dsurface.FastDrawAlpha(Bounds(ddx, ddy, Source.Width, Source.Height), Source.ClientRect, Source);
          end else begin
                ErrorCode := 10;
                g_ImgMixSurface.SetSize(source.Width, source.Height);
                g_ImgMixSurface.Fill(0);
                ErrorCode := 11;
                g_ImgMixSurface.Draw (0, 0, source.ClientRect, source, FALSE);
                ErrorCode := 12;
                DrawEffect (0, 0, g_ImgMixSurface, source, ceff);
                ErrorCode := 13;
                //DrawBlend (dsurface, ddx, ddy, g_ImgMixSurface, 0, 120);
                dsurface.FastDrawAlpha(Bounds(ddx, ddy, g_ImgMixSurface.Width, g_ImgMixSurface.Height), g_ImgMixSurface.ClientRect, g_ImgMixSurface);
                ErrorCode := 14;
          end;
       end;
     end;
  except
     on e: Exception do begin
       DebugOutStr('TActor.DrawEffSurface'+IntToStr(ErrorCode)+'    '+e.Message);
     end;
  end;
end;
//��������˸��
procedure TActor.DrawWeaponGlimmer (dsurface: TDirectDrawSurface; ddx, ddy: integer);
//var
//   idx, ax, ay: integer;
//   d: TDirectDrawSurface;
begin
   //������..(��ȭ��) �׷��� ����...
   (*if BoNextTimeFireHit and WarMode and GlimmingMode then begin
      if GetTickCount - GlimmerTime > 200 then begin
         GlimmerTime := GetTickCount;
         Inc (CurGlimmer);
         if CurGlimmer >= MaxGlimmer then CurGlimmer := 0;
      end;
      idx := GetEffectBase (5-1{��ȭ���¦��}, 1) + Dir*10 + CurGlimmer;
      d := FrmMain.WMagic.GetCachedImage (idx, ax, ay);
      if d <> nil then
         DrawBlend (dsurface, ddx + ax, ddy + ay, d, 1);
                          //dx + ax + ShiftX,
                          //dy + ay + ShiftY,
                          //d, 1);
   end;*)
end;
//���ݵ�ǰ״̬state�����ɫЧ���������ж�״̬�ȣ�������ʾ����ɫ�Ϳ��ܲ�ͬ��
function TActor.GetDrawEffectValue: TColorEffect;
var
   ceff: TColorEffect;
begin
   ceff := ceNone;

   //����
   if (g_FocusCret = self) or (g_MagicTarget = self) then begin
     if m_wAppearance <> 242 then   //������
      ceff := ceBright;
   end;
   if m_nState and $1000000 <> 0 then begin //����Ч��
     ceff := ceWhite;
   end;
   //�����̶�
   if m_nState and $80000000 <> 0 then begin
      ceff := ceGreen;
   end;
   if m_nState and $40000000 <> 0 then begin
      ceff := ceRed;
   end;
   if (m_nState and $20000000 <> 0) or (m_nState and $00010000 <> 0) then begin
      ceff := ceBlue;
   end;
   { //��״̬���� �������� С��״̬����  20080812
   if m_nState and $10000000 <> 0 then begin
      ceff := ceYellow;
   end;}
   //�����
   if m_nState and $08000000 <> 0 then begin
      ceff := ceFuchsia;
   end;
   if m_nState and $04000000 <> 0 then begin //���
      ceff := ceGrayScale;
   end;
   if m_nState and $00080000 <> 0 then begin //Ψ�Ҷ���
      ceff := ceGrayScale;
   end;
   Result := ceff;
end;
(*******************************************************************************
  ���� : ��ʾ��������  [ͨ����]      ���ڣ�2008.01.13
  ���� : DrawMyShow(dsurface: TDirectDrawSurface;dx,dy:integer);
  ���� : dsurfaceΪ������DXΪX���ꣻ DYΪY���ꣻ
*******************************************************************************)
procedure TActor.DrawMyShow(dsurface: TDirectDrawSurface;dx,dy:integer);
var
  d:TDirectDrawSurface;
  img,ax,ay: integer;
  FlyX, FlyY: Integer;
begin
  if g_boIsMyShow then begin
    if GetTickCount - m_nMyShowTime >  m_nMyShowNextFrameTime{140} then begin
      m_nMyShowTime := GetTickCount;
      Inc(m_nMyShowFrame);
    end;
    //if g_boIsMyShow then begin
    if m_nMyShowFrame > m_nMyShowExplosionFrame then g_boIsMyShow := FALSE;
      img:= m_nMyShowStartFrame + m_nMyShowFrame;
      d := g_MagicBase.GetCachedImage(img,ax,ay);
      if not m_boNoChangeIsMyShow then begin//�Ƿ�������ﶯ���仯���仯     20080306
        if d <> nil then
          DrawBlend (dsurface,dx+ ax + m_nShiftX,
                                 dy + ay + m_nShiftY,
                                 d, 120)
      end else begin
          PlayScene.ScreenXYfromMCXY (m_nNoChangeX, m_nNoChangeY, FlyX, FlyY);
          if d <> nil then
              DrawBlend (dsurface,FlyX+ ax  - UNITX div 2,
                                 FlyY + ay - UNITY div 2,
                                 d, 120);
      end;
  end;
    //end;
end;

{//ƮѪ��ʾ
procedure TActor.DrawAddBlood(dsurface: TDirectDrawSurface;dx, dy: Integer);
var
   BooldNum,jj,BooldIndex: Integer;
   d: TDirectDrawSurface;
   p,w:integer;
 function GetIndex(var Index:Integer):Integer;
 var
    s:String;
 begin
    s:=Inttostr(Index);
    Result:=StrToInt(S[1])+5;
    Delete(s,1,1);
    if s<>'' then
     Index:=Strtoint(s)
    else
     Index:=-1;
 end;
begin
  if g_boShowMoveRedHp then begin
    if IsAddBlood then begin
      if GetTickCount - AddBloodTime >  1000 then IsAddBlood := False;
      if GetTickCount - AddBloodStartTime > 40 then begin
        Inc(AddBloodFram);
        AddBloodStartTime := GetTickCount;
      end;
    end;
      //�Ӽ�Ѫ��ʾ

      if IsAddBlood then begin
         BooldNum := abs(AddBloodNum);//BooldNum�������ٵ�Ѫ
         jj:=1;
         if Self=g_Myself then w := 12 else w := 8;
         if AddBloodnum > 0 then
           d := g_qingqingImages.Images[16]
         else
           d := g_qingqingImages.Images[15];

           if d <> nil then
            dsurface.Draw(m_nSayX - d.Width div 2+AddBloodFram*(2), dy + m_nhpy + m_nShiftY - 10-AddBloodFram*(2), d.ClientRect, d, True);
         while BooldNum >= 0 do begin
           BooldIndex := GetIndex(BooldNum);//ȡ��ͼƬ
           d := g_qingqingImages.Images[BooldIndex];
           if d <> nil then
            dsurface.Draw(m_nSayX - d.Width div 2 + AddBloodFram * (2) + jj * w, dy + m_nhpy + m_nShiftY - 10 - AddBloodFram * (2), d.ClientRect, d, True);
           Inc(jj);
         end;
      end;
  end;
end;  }
//��ʾ��ɫ
procedure TActor.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
var
   idx, ax, ay: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
   wimg: TWMImages;
   ErrorCode: Integer;
begin
  try
    ErrorCode := 0;
    d:=nil;
    //if not (m_btDir in [0..7]) then Exit;
    if m_btDir > 7 then Exit;
    ErrorCode := 1;
    if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
       m_dwLoadSurfaceTime := GetTickCount;
       LoadSurface; //����ͼƬÿ60����ͷ�һ�Σ�60����δʹ�õĻ���������ÿ60��Ҫ���һ���Ƿ��Ѿ����ͷ���.
    end;
    ErrorCode := 2;
    ceff := GetDrawEffectValue;
    ErrorCode := 3;
    if m_BodySurface <> nil then begin
       DrawEffSurface (dsurface,
                      m_BodySurface,
                      dx + m_nPx + m_nShiftX,
                      dy + m_nPy + m_nShiftY,
                      blend,
                      ceff);
    end;
    ErrorCode := 5;
    DrawMyShow(dsurface,dx,dy); //��ʾ������
    ErrorCode := 6;
    if not m_boDeath then begin  //��������ʾ
      if m_nState and $02000000 <> 0 then begin //�򽣹��ڻ���״̬
          idx := 4010 + (m_nGenAniCount mod 8);
          d := g_WCboEffectImages.GetCachedImage(idx, ax, ay);
          if d <> nil then
            DrawBlend (dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 150);
      end;
      if m_nState and $00004000 <> 0 then begin //����״̬
          idx := 1080 + (m_nGenAniCount mod 8);
          d := g_WMagic10Images.GetCachedImage(idx, ax, ay);
          if d <> nil then
            DrawBlend (dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 150);
      end;
    end;
    if m_boUseMagic and (m_CurMagic.EffectNumber > 0) then begin
       if m_nCurEffFrame in [0..m_nSpellFrame-1] then begin
          GetEffectBase (m_CurMagic.EffectNumber-1, 0, wimg, idx, m_btDir, m_CurMagic.EffectLevelEx);
          idx := idx + m_nCurEffFrame;
          if wimg <> nil then
             d := wimg.GetCachedImage (idx, ax, ay);
          if d <> nil then
             DrawBlend (dsurface,
                             dx + ax + m_nShiftX,
                             dy + ay + m_nShiftY,
                             d, 120);
       end;
    end;
    ErrorCode := 7;
   except
    DebugOutStr('TActor.DrawChr:'+IntToStr(ErrorCode));
   end;
end; 

procedure  TActor.DrawEff (dsurface: TDirectDrawSurface; dx, dy: integer);
begin
end;

procedure  TActor.DrawStall (dsurface: TDirectDrawSurface; dx, dy: integer);
begin
end;

//ȱʡ֡
function  TActor.GetDefaultFrame (wmode: Boolean): integer;
var
   cf: integer;
   pm: PTMonsterAction;
begin
   Result:=0;
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   if m_boDeath then begin            //����
      if m_boSkeleton then            //����ʬ������
         Result := pm.ActDeath.start
      else Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
   end else begin
      m_nDefFrameCount := pm.ActStand.frame;
      if m_nCurrentDefFrame < 0 then cf := 0
        else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
        else cf := m_nCurrentDefFrame;
      Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
   end;
end;
//Ĭ���˶�
procedure TActor.DefaultMotion;   //ȱʡ����
begin
   m_boReverseFrame := FALSE;
   m_boCboMode := False;
   if m_boWarMode then begin
      if (GetTickCount - m_dwWarModeTime > 4000) then //and not BoNextTimeFireHit then
         m_boWarMode := FALSE;
   end;
   m_nCurrentFrame := GetDefaultFrame (m_boWarMode);
   Shift (m_btDir, 0, 1, 1);
end;

//���ﶯ������(�Ų���������������)
procedure TActor.SetSound;
var
   cx, cy, bidx, wunit, attackweapon: integer;
   hiter: TActor;
begin
   if (m_btRace = 0) or (m_btRace = 1) or (m_btRace = 150){����,Ӣ��,����20080629} then begin              //�������
      if (self = g_MySelf) and             //��������
         ((m_nCurrentAction=SM_WALK) or
          (m_nCurrentAction=SM_BACKSTEP) or
          (m_nCurrentAction=SM_RUN) or
          //(m_nCurrentAction=SM_HORSERUN) or  20080803ע��������Ϣ
          (m_nCurrentAction=SM_RUSH) or
          (m_nCurrentAction=SM_RUSHKUNG)
         )
      then begin
         cx := g_MySelf.m_nCurrX - Map.m_nBlockLeft;
         cy := g_MySelf.m_nCurrY - Map.m_nBlockTop;
         cx := cx div 2 * 2;
         cy := cy div 2 * 2;
         bidx := Map.m_MArr[cx, cy].wBkImg and $7FFF;
         wunit := Map.m_MArr[cx, cy].btArea;
         bidx := wunit * 10000 + bidx - 1;
         case bidx of
            330..349, 450..454, 550..554, 750..754,
            950..954, 1250..1254, 1400..1424, 1455..1474,
            1500..1524, 1550..1574:
               m_nFootStepSound := s_walk_lawn_l;  //�ݵ�������
               
            250..254, 1005..1009, 1050..1054, 1060..1064, 1450..1454,
            1650..1654:
               m_nFootStepSound := s_walk_rough_l; //�ֲڵĵ���

            605..609, 650..654, 660..664, 2000..2049,
            3025..3049, 2400..2424, 4625..4649, 4675..4678:
               m_nFootStepSound := s_walk_stone_l;  //ʯͷ����������

            1825..1924, 2150..2174, 3075..3099, 3325..3349,
            3375..3399:
               m_nFootStepSound := s_walk_cave_l;  //��Ѩ������

           3230, 3231, 3246, 3277:
               m_nFootStepSound := s_walk_wood_l;  //ľͷ��������

           //����..
           3780..3799:
               m_nFootStepSound := s_walk_wood_l;

           3825..4434:
               if (bidx-3825) mod 25 = 0 then m_nFootStepSound := s_walk_wood_l
               else m_nFootStepSound := s_walk_ground_l;

             2075..2099, 2125..2149:
               m_nFootStepSound := s_walk_room_l;   //������

            1800..1824:
               m_nFootStepSound := s_walk_water_l;  //ˮ��

            else
               m_nFootStepSound := s_walk_ground_l;
         end;
         //��������
         if (bidx >= 825) and (bidx <= 1349) then begin
            if ((bidx-825) div 25) mod 2 = 0 then
               m_nFootStepSound := s_walk_stone_l;
         end;
         //��������
         if (bidx >= 1375) and (bidx <= 1799) then begin
            if ((bidx-1375) div 25) mod 2 = 0 then
               m_nFootStepSound := s_walk_cave_l;
         end;
         case bidx of
            1385, 1386, 1391, 1392:
               m_nFootStepSound := s_walk_wood_l;
         end;

         bidx := Map.m_MArr[cx, cy].wMidImg and $7FFF;   //����ͼ����
         bidx := bidx - 1;
         case bidx of
            0..115:
               m_nFootStepSound := s_walk_ground_l;
            120..124:
               m_nFootStepSound := s_walk_lawn_l;
         end;

         bidx := Map.m_MArr[cx, cy].wFrImg and $7FFF;
         bidx := bidx - 1;
         case bidx of
            221..289, 583..658, 1183..1206, 7163..7295,
            7404..7414:
               m_nFootStepSound := s_walk_stone_l;
            3125..3267, {3319..3345, 3376..3433,} 3757..3948,
            6030..6999:
               m_nFootStepSound := s_walk_wood_l;
            3316..3589:
               m_nFootStepSound := s_walk_room_l;
         end;
         if (m_nCurrentAction = SM_RUN){ or (m_nCurrentAction = SM_HORSERUN)20080803ע��������Ϣ }then
            m_nFootStepSound := m_nFootStepSound + 2;
      end;

      if m_btSex = 0 then begin //��
         m_nScreamSound := s_man_struck;
         m_nDieSound := s_man_die;
      end else begin //Ů
         m_nScreamSound := s_wom_struck;
         m_nDieSound := s_wom_die;
      end;

      case m_nCurrentAction of      //��������
         SM_THROW, SM_HIT, SM_HIT+1, SM_HIT+2, SM_POWERHIT, SM_HIT_107,
         {$IF M2Version <> 2}SM_LONGHITFORFENGHAO,SM_FIREHITFORFENGHAO,SM_DAILYFORFENGHAO,{$IFEND}
         SM_LONGHIT, SM_LONGHIT4, SM_WIDEHIT, CM_WIDEHIT4, SM_FIREHIT{�һ�},
         SM_BLOODSOUL{Ѫ��һ��(ս)}, SM_DAILY{���ս���}, SM_4FIREHIT{4���һ�},
         SM_CRSHIT, SM_TWINHIT{����ն�ػ�}, SM_QTWINHIT{����ն���}, SM_CIDHIT{��Ӱ����},
         SM_LEITINGHIT{����һ��սʿЧ�� 20080611}, SM_BATTERHIT1,SM_BATTERHIT2,SM_BATTERHIT3,SM_BATTERHIT4,
         SM_DAILYEX1..SM_DAILYEX3, SM_FIREHITEX1..SM_FIREHITEX3,
         SM_WIDEHIT4EX1..SM_WIDEHIT4EX3, SM_POWERHITEX1..SM_POWERHITEX3,
         SM_LONGHITEX1..SM_LONGHITEX3:
            begin
               case (m_btWeapon div 2) of
                  6, 20:  m_nWeaponSound := s_hit_short;
                  1:  m_nWeaponSound := s_hit_wooden;
                  2, 13, 9, 5, 14, 22:  m_nWeaponSound := s_hit_sword;
                  4, 17, 10, 15, 16, 23:  m_nWeaponSound := s_hit_do;
                  3, 7, 11:  m_nWeaponSound := s_hit_axe;
                  24:  m_nWeaponSound := s_hit_club;
                  8, 12, 18, 21:  m_nWeaponSound := s_hit_long;
                  else m_nWeaponSound := s_hit_fist;
               end;
            end;
         SM_STRUCK: //�ܹ���
            begin
               if m_nMagicStruckSound >= 1 then begin
                  //strucksound := s_struck_magic;
               end else begin
                  hiter := PlayScene.FindActor (m_nHiterCode);
                  //attackweapon := 0;
                  if hiter <> nil then begin
                     attackweapon := hiter.m_btWeapon div 2;
                     if (hiter.m_btRace = 0) or (hiter.m_btRace = 1) or (hiter.m_btRace = 150) then //����,Ӣ��,����20080629
                        case (m_btDress div 2) of
                           3:
                              case attackweapon of
                                 6:  m_nStruckSound := s_struck_armor_sword;
                                 1,2,4,5,9,10,13,14,15,16,17: m_nStruckSound := s_struck_armor_sword;
                                 3,7,11: m_nStruckSound := s_struck_armor_axe;
                                 8,12,18: m_nStruckSound := s_struck_armor_longstick;
                                 else m_nStruckSound := s_struck_armor_fist;
                              end;
                           else
                              case attackweapon of
                                 6: m_nStruckSound := s_struck_body_sword;
                                 1,2,4,5,9,10,13,14,15,16,17: m_nStruckSound := s_struck_body_sword;
                                 3,7,11: m_nStruckSound := s_struck_body_axe;
                                 8,12,18: m_nStruckSound := s_struck_body_longstick;
                                 else m_nStruckSound := s_struck_body_fist;
                              end;
                        end;
                  end;
               end;
            end;
      end;


      if m_boUseMagic and (m_CurMagic.MagicSerial > 0) then begin
        case m_CurMagic.MagicSerial of  //MagicSerialΪħ��ID 20080302
          41: m_nMagicStartSound := 10430;//ʨ�Ӻ�  20080314
          44: begin //������
            m_nMagicStartSound := 10000 + (m_CurMagic.MagicSerial-5) * 10;
            m_nMagicFireSound := 10000 + (m_CurMagic.MagicSerial-5) + 1;
            m_nMagicExplosionSound := 10000 + (m_CurMagic.MagicSerial-5) * 10 + 2;
          end;
          45: begin //�����
            m_nMagicStartSound := 10000 + (m_CurMagic.MagicSerial-10) * 10;
            m_nMagicExplosionSound := 10000 + (m_CurMagic.MagicSerial-10) + 2;
          end;
          48: begin
            m_nMagicStartSound := 10370;  //������ 20080321
            m_nMagicExplosionSound := 0;
          end;
          50: begin
            m_nMagicStartSound := 10360;//�޼�����  20080314
            m_nMagicExplosionSound := 0;
          end;
          59,94: begin //��Ѫ��,4����Ѫ�� 20080511
            m_nMagicStartSound := 10480;
            m_nMagicExplosionSound := 10482;
          end;
          62: begin//����һ�� 20080405
              m_nMagicStartSound := 10520;
              m_nMagicExplosionSound := 10522;
          end;
          63: begin  //�ɻ����� 20080405
              m_nMagicStartSound := 10530;
              m_nMagicExplosionSound := 10532;
          end;
          64: begin  //ĩ������ 20080405
              m_nMagicStartSound := 10540;
              m_nMagicExplosionSound := 10542;
          end;
          65: begin  //�������� 20080405
              m_nMagicStartSound := 10550;
              m_nMagicExplosionSound := 10552;
          end;
          66: begin //4��ħ����
            m_nMagicStartSound := 10310;
            m_nMagicFireSound := 10311;
            m_nMagicExplosionSound := 10312;
          end;
          71: begin //�ٻ�ʥ��
            m_nMagicStartSound := 10300;
            m_nMagicFireSound := 10301;
            m_nMagicExplosionSound := 10302;
          end;
          72: begin //�ٻ�����
            m_nMagicStartSound := 10410;
            m_nMagicFireSound := 0;
            m_nMagicExplosionSound := 0;
          end;
          91: begin //4���׵���
            m_nMagicStartSound := 10110;
            m_nMagicFireSound := 10111;
            m_nMagicExplosionSound := 10112;
          end;
          93: begin //4��ʩ����
            m_nMagicStartSound := 10060;
            m_nMagicFireSound := 10061;
            m_nMagicExplosionSound := 10062;
          end;
          97: begin  //Ѫ��һ��(��)
            m_nMagicStartSound := 10550;
            m_nMagicFireSound := 0;
            m_nMagicExplosionSound := 8207;
          end;
          98: begin  //Ѫ��һ��(��)
            m_nMagicStartSound := 10540;
            m_nMagicFireSound := 0;
            m_nMagicExplosionSound := 8206;
          end;
          113: begin //��������
            m_nMagicStartSound := 10110;
            m_nMagicFireSound := 10111;
            m_nMagicExplosionSound := 10112;
          end;
        else begin
           m_nMagicStartSound := 10000 + m_CurMagic.MagicSerial * 10;
           m_nMagicFireSound := 10000 + m_CurMagic.MagicSerial * 10 + 1;
           m_nMagicExplosionSound := 10000 + m_CurMagic.MagicSerial * 10 + 2;
          end;
        end;
      end;

   end else begin
      if m_nCurrentAction = SM_STRUCK then begin //�ܹ���
         if m_nMagicStruckSound >= 1 then begin
            //strucksound := s_struck_magic;
         end else begin
            hiter := PlayScene.FindActor (m_nHiterCode);
            if hiter <> nil then begin
               attackweapon := hiter.m_btWeapon div 2;
               case attackweapon of
                  6: m_nStruckSound := s_struck_body_sword;
                  1,2,4,5,9,10,13,14,15,16,17: m_nStruckSound := s_struck_body_sword;
                  3,11: m_nStruckSound := s_struck_body_axe;
                  8,12,18: m_nStruckSound := s_struck_body_longstick;
                  101: m_nStruckSound := 492; //������
                  else m_nStruckSound := s_struck_body_fist;
               end;
            end;
         end;
      end;

      if m_btRace <> 50 then begin
        case m_wAppearance of
          242: begin //������
            m_nAppearSound := 0;
            m_nNormalSound := 0;
            m_nAttackSound := 211;
            m_nWeaponSound := 0;
            m_nScreamSound := 215;
            m_nDieSound := 200 + (m_wAppearance) * 10 + 5;
            m_nDie2Sound := 200 + (m_wAppearance) * 10 + 6;
          end;
          250: begin //ѩ��ս��
            m_nAttackSound := -1;
            m_nWeaponSound := 10512;
          end;
          251: begin //ѩ������
            m_nAttackSound := -1;
          end;
          255: begin //ѩ���콫
            m_nAttackSound := -1;
            m_nWeaponSound := 10192;
          end;
          256: begin //ѩ��ħ��
            m_nAttackSound := -1;
          end;
          263: begin //ѩ����ʿ
            m_nAttackSound := -1;
            m_nWeaponSound := 2833;
            m_nScreamSound := 2834;
            m_nDieSound := 2835;
            m_nDie2Sound := 2836;
          end;
          272,273: begin //ʥ��
            m_nAppearSound := 1910;
            m_nNormalSound := 1911;
            m_nAttackSound := 1912;
            m_nWeaponSound := 1913;
            m_nScreamSound := 1914;
            m_nDieSound := 1915;
            m_nDie2Sound := 1916;
          end;
          else begin
            m_nAppearSound := 200 + (m_wAppearance) * 10;
            m_nNormalSound := 200 + (m_wAppearance) * 10 + 1;
            m_nAttackSound := 200 + (m_wAppearance) * 10 + 2;
            m_nWeaponSound := 200 + (m_wAppearance) * 10 + 3;
            m_nScreamSound := 200 + (m_wAppearance) * 10 + 4;
            if m_btRace = 108 then
              m_nDieSound := 1925 //������������  20080302
            else m_nDieSound := 200 + (m_wAppearance) * 10 + 5;
            m_nDie2Sound := 200 + (m_wAppearance) * 10 + 6;
          end;
        end;
      end;
   end;


   if m_nCurrentAction = SM_STRUCK then begin  //�ܹ���
      hiter := PlayScene.FindActor (m_nHiterCode);
      //attackweapon := 0;
      if hiter <> nil then begin
         attackweapon := hiter.m_btWeapon div 2;
         if hiter.m_btRace in [0,1,150] then //����,Ӣ��,����20080629
            case (attackweapon div 2) of
               6, 20:  m_nStruckWeaponSound := s_struck_short;
               1:  m_nStruckWeaponSound := s_struck_wooden;
               2, 13, 9, 5, 14, 22:  m_nStruckWeaponSound := s_struck_sword;
               4, 17, 10, 15, 16, 23:  m_nStruckWeaponSound := s_struck_do;
               3, 7, 11:  m_nStruckWeaponSound := s_struck_axe;
               24:  m_nStruckWeaponSound := s_struck_club;
               8, 12, 18, 21:  m_nStruckWeaponSound := s_struck_wooden; //long;
               //else struckweaponsound := s_struck_fist;
            end;
            if m_btRace = 101 then m_nStruckSound := 492;  //������
      end;
   end;

end;

//���Ŷ�����Ч
procedure  TActor.RunSound;
begin
   m_boRunSound := TRUE;
   SetSound;
   case m_nCurrentAction of
      SM_STRUCK:  //������
         begin
            if (m_nStruckWeaponSound >= 0) then PlaySound (m_nStruckWeaponSound); //��������������Ч
            if (m_nStruckSound >= 0) then PlaySound (m_nStruckSound);             //����������Ч
            case m_wAppearance of
              250: MyPlaySound (sbz_injured_ground);//ѩ��ս��
              251: MyPlaySound (cqsbz_injured_ground); //ѩ������
              255: MyplaySound (xsls_injured_ground); //ѩ���콫
              256: MyPlaySound (bq_injured_ground);  //ѩ��ħ��
              263: MyPlaySound (xsws_injured_ground); //ѩ����ʿ
              else if (m_nScreamSound >= 0) then PlaySound (m_nScreamSound);              //���
            end;
         end;
      SM_NOWDEATH:
         begin
            case m_wAppearance of
              250: MyPlaySound (byjm_injured_ground); //ѩ��ս��
              255: MyPlaySound (xsls_death_ground); //ѩ���콫
              256: MyPlaySound (bq_death_ground); //ѩ��ħ��
              263: MyPlaySound (xsws_death_ground); //ѩ����ʿ
              else if (m_nDieSound >= 0) then PlaySound (m_nDieSound);
            end;
         end;
      SM_THROW, SM_HIT, SM_FLYAXE, SM_LIGHTING, SM_DIGDOWN, SM_HIT_107:
         begin
           case m_wAppearance of
             250: begin //ѩ��ս��
               if m_nCurrentAction = SM_HIT then MyPlaySound(sbz_tsgj_ground)
               else if m_nWeaponSound >= 0 then PlaySound(m_nWeaponSound);
             end;
             251: MyPlaySound(cqsbz_tsgj_ground); //ѩ������
             255: begin  //ѩ���콫
               if m_nCurrentAction = SM_HIT then MyPlaySound(cqsbz_tsgj_ground)
               else if m_nWeaponSound >= 0 then PlaySound(m_nWeaponSound);
             end;
             256: MyPlaySound(x60182_ground); //ѩ��ħ��
             263: MyPlaySound(xsws_tsgj_ground); //ѩ����ʿ
           else if m_nAttackSound >= 0 then PlaySound (m_nAttackSound);
           end;
         end;
      SM_ALIVE, SM_DIGUP{����,������}:
         begin
           case m_wAppearance of
             263: MyPlaySound (xsws_pbec_ground); //ѩ����ʿ
           else PlaySound (m_nAppearSound);
           end;
         end;
      SM_SPELL:
         begin
            case m_CurMagic.MagicSerial of
              58, 70, 92, 108: MyPlaySound ('wav\M58-0.wav'); //����������� 20080511
              60: PHHitSound(1); //�ƻ�ϻ�����
              61: PHHitSound(2); //����ն����
              75: MyPlaySound (heroshield_ground); //�����������
              77: MyPlaySound ('wav\cboFs1_start.wav'); //˫����
              78: MyPlaySound ('wav\cboDs1_start.wav'); //��Х��
              80: MyPlaySound ('wav\cboFs2_start.wav'); //�����
              81: MyPlaySound ('wav\cboDs2_start.wav'); //������
              83: MyPlaySound ('wav\cboFs3_start.wav'); //���ױ�
              84: MyPlaySound ('wav\cboDs3_start.wav'); //������
              86: MyPlaySound ('wav\cboFs4_start.wav'); //����ѩ��
              87: MyPlaySound ('wav\cboDs4_start.wav'); //�򽣹���
              else PlaySound (m_nMagicStartSound);
            end;
         end;
   end;
end;

procedure  TActor.RunActSound (frame: integer);
begin
   if m_boRunSound then begin     //��Ҫ������Ч
      if (m_btRace = 0) or (m_btRace = 1) or (m_btRace = 150) then begin  //����,Ӣ��,����20080629
         case m_nCurrentAction of
            SM_THROW, SM_HIT, SM_HIT_107, SM_HIT+1, SM_HIT+2:    //�ӡ���
               if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  m_boRunSound := FALSE; //��Ч�Ѿ�����
               end;
            SM_POWERHIT, SM_POWERHITEX1..SM_POWERHITEX3:
               if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  //�������������
                  if m_btSex = 0 then PlaySound (s_yedo_man)
                  else PlaySound (s_yedo_woman);
                  m_boRunSound := FALSE; //�ѹ��� �Ҹ���
               end;
            SM_LONGHIT, {$IF M2Version <> 2}SM_LONGHITFORFENGHAO,{$IFEND}SM_LONGHIT4,
            SM_LONGHITEX1..SM_LONGHITEX3:
               if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  PlaySound (s_longhit);
                  m_boRunSound := FALSE; //�ѹ��� �Ҹ���
               end;
            SM_WIDEHIT, SM_WIDEHIT4, SM_WIDEHIT4EX1..SM_WIDEHIT4EX3:
               if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  PlaySound (s_widehit);
                  m_boRunSound := FALSE; //�ѹ��� �Ҹ���
               end;
            {$IF M2Version <> 2}SM_FIREHITFORFENGHAO, {$IFEND}SM_FIREHIT{�һ�}, SM_4FIREHIT{4���һ�}, SM_FIREHITEX1..SM_FIREHITEX3:
               if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  PlaySound (s_firehit);
                  m_boRunSound := FALSE; //�ѹ��� �Ҹ���
               end;
            SM_CRSHIT:
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  PlaySound (s_firehit); //Damian
                  m_boRunSound := FALSE; //�ѹ��� �Ҹ���
              end;
            SM_TWINHIT: //����ն �ػ�
              if frame = 2 then begin
                PlaySound (m_nWeaponSound);
                MyPlaySound (longswordhit_ground);
                m_boRunSound := FALSE;
              end;
            SM_QTWINHIT: //����ն ���
              if frame = 2 then begin
                PlaySound (m_nWeaponSound);
                MyPlaySound (longswordhit_ground);
                m_boRunSound := FALSE;
              end;
            {$IF M2Version <> 2}SM_DAILYFORFENGHAO,{$IFEND}SM_DAILY,
            SM_DAILYEX1..SM_DAILYEX3: //���ս��� 20080511
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  if m_btSex = 0 then MyPlaySound ('wav\M56-0.wav')
                  else MyPlaySound ('wav\M56-3.wav'); //Ů
                  m_boRunSound := FALSE;
              end;
            SM_BLOODSOUL: //Ѫ��һ��(ս)  ��ʱ������û����ʢ����ʲô����
              if frame = 2 then begin
                PlaySound (m_nWeaponSound);
                MyPlaySound('wav\8220-2.wav');
                m_boRunSound := False;
              end;
            SM_CIDHIT://��Ӱ����
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  PlaySound (142); //20080403
                  m_boRunSound := False;
              end;
           SM_BATTERHIT1://׷�Ĵ�
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  MyPlaySound(cboZs2_start);
                  m_boRunSound := False;
              end;
           SM_BATTERHIT2://����ɱ
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  if m_btSex = 0 then MyPlaySound (cboZs1_start_m)
                  else MyPlaySound (cboZs1_start_w); //Ů
                  m_boRunSound := False;
              end;
           SM_BATTERHIT3://��ɨǧ��
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  MyPlaySound(cboZs4_start);
                  m_boRunSound := False;
              end;
           SM_BATTERHIT4://����ն
              if frame = 2 then begin
                  //PlaySound (m_nWeaponSound);
                  {if m_btSex = 0 then MyPlaySound (cboZs3_start_m)
                  else MyPlaySound (cboZs3_start_w); //Ů  }
                  MyPlaySound (cboZs7_start);
                  m_boRunSound := False;
              end;
           {SM_69HIT:   //��������
              if frame = 2 then begin
                  PlaySound (m_nWeaponSound);
                  if m_btSex = 0 then MyPlaySound (cboZs3_start_m)
                  else MyPlaySound (cboZs3_start_w); //Ů  
                  m_boRunSound := False;
              end; }
         end;
      end else begin
         {if m_btRace = 50 then begin  //20080803�޸�
         end else begin}
          if m_btRace <> 50 then begin
            if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_TURN) then begin
               if (frame = 1) and (Random(8) = 1) then begin
                  PlaySound (m_nNormalSound);
                  m_boRunSound := FALSE;
               end;
            end;
            if (m_nCurrentAction = SM_HIT) or (m_nCurrentAction = SM_HIT_107) then begin
               if (frame = 3) and (m_nAttackSound >= 0) then begin
                  PlaySound (m_nWeaponSound);
                  m_boRunSound := FALSE;
               end;
            end;
            { //20080803�޸�
            case m_wAppearance of
               80: begin
                  if m_nCurrentAction = SM_NOWDEATH then begin
                     if (frame = 2) then begin
                        PlaySound (m_nDie2Sound);
                        m_boRunSound := FALSE;
                     end;
                  end;
               end;
            end; }
            if m_wAppearance = 80 then begin
               if (m_nCurrentAction = SM_NOWDEATH) and (frame = 2) then begin
                 PlaySound (m_nDie2Sound);
                 m_boRunSound := FALSE;
               end;
            end;
         end;
      end;
   end;
end;

procedure  TActor.RunFrameAction (frame: integer);
begin
end;

procedure  TActor.ActionEnded;
begin
end;

procedure TActor.Run;
   function MagicTimeOut: Boolean;
   begin
      if self = g_MySelf then begin
         Result := GetTickCount - m_dwWaitMagicRequest > 3000;
      end else
         Result := GetTickCount - m_dwWaitMagicRequest > 2000;
      if Result then m_CurMagic.ServerMagicCode := 0;
   end;
var
   prv: integer;
   m_dwFrameTimetime: longword;
   bofly: Boolean;
   nCode: Byte;
begin
  nCode:= 0;
  try
   if GetTickCount - m_dwGenAnicountTime > 120 then begin //�ּ��Ǹ� ��... �ִϸ��̼� ȿ��
      m_dwGenAnicountTime := GetTickCount;
      Inc (m_nGenAniCount);
      if m_nGenAniCount > 100000 then m_nGenAniCount := 0;
   end;
   nCode:= 1;
   if (m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_BACKSTEP) or
      (m_nCurrentAction = SM_RUN) or
      //(m_nCurrentAction = SM_HORSERUN) or 20080803ע��������Ϣ
      (m_nCurrentAction = SM_RUSH) or
      (m_nCurrentAction = SM_RUSHKUNG)
   then Exit;
   nCode:= 2;
   m_boMsgMuch := FALSE;
   if self <> g_MySelf then begin
      if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
   end;
   nCode:= 3;
   //����Ч��
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   nCode:= 4;
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);

   nCode:= 5;
   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin  //������Ϊ��
      nCode:= 6;
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;
      nCode:= 7;
      if (self <> g_MySelf) and (m_boUseMagic) then begin
         m_dwFrameTimetime := Round(m_dwFrameTime / 1.8);
      end else begin
         if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
         else m_dwFrameTimetime := m_dwFrameTime;
      end;
      nCode:= 8;
      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
           nCode:= 9;
            if m_boUseMagic then begin
               if (m_nCurEffFrame = m_nSpellFrame-2) or (MagicTimeOut) then begin
                  if (m_CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then begin
                     Inc (m_nCurrentFrame);
                     Inc(m_nCurEffFrame);
                     m_dwStartTime := GetTickCount;
                  end;
               end else begin
                  if m_nCurrentFrame < m_nEndFrame - 1 then Inc (m_nCurrentFrame);
                  Inc (m_nCurEffFrame);
                  m_dwStartTime := GetTickCount;
               end;
            end else begin
               Inc (m_nCurrentFrame);
               m_dwStartTime := GetTickCount;
            end;
         end else begin
           nCode:= 10;
            if m_boDelActionAfterFinished then begin
               m_boDelActor := TRUE;
            end;
            nCode:= 11;
            if self = g_MySelf then begin  
               if FrmMain.ServerAcceptNextAction then begin
                  nCode:= 12;
                  ActionEnded;
                  m_nCurrentAction := 0;
                  m_boUseMagic := FALSE;
               end;
            end else begin
               nCode:= 13;
               ActionEnded;
               m_nCurrentAction := 0;
               m_boUseMagic := FALSE;
            end;
         end;
         nCode:= 14;
         if m_boUseMagic then begin
            if m_nCurEffFrame = m_nSpellFrame-1 then begin
               nCode:= 15;
               if m_CurMagic.ServerMagicCode > 0 then begin
                  with m_CurMagic do
                     PlayScene.NewMagic (self,
                                      ServerMagicCode,
                                      EffectNumber, //Effect
                                      m_nCurrX,
                                      m_nCurrY,
                                      TargX,
                                      TargY,
                                      Target,
                                      EffectType, //EffectType
                                      Recusion,
                                      AniTime,
                                      EffectLevelEx,
                                      bofly);
                  nCode:= 16;
                  if bofly then
                    case m_CurMagic.EffectNumber of
                      42: MyPlaySound ('wav\splitshadow.wav'); //������
                      else PlaySound (m_nMagicFireSound);
                    end
                  else begin
                    case m_CurMagic.EffectNumber of
                      51, 130: MyPlaySound ('wav\M58-3.wav'); //����������� 20080511
                      55: begin
                        PlaySound (m_nWeaponSound);
                        if m_btSex = 0 then MyPlaySound (cboZs3_start_m)
                        else MyPlaySound (cboZs3_start_w); //Ů
                        m_boRunSound := False;
                      end;
                      else PlaySound (m_nMagicExplosionSound);
                    end;
                  end;
               end;
               //LatestSpellTime := GetTickCount;
               m_CurMagic.ServerMagicCode := 0;
            end;
         end;
      end;
      nCode:= 17;
      if (m_wAppearance = 0) or (m_wAppearance = 1) or (m_wAppearance = 43) then m_nCurrentDefFrame := -10
      else m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
   end else begin    //����Ϊ��
      nCode:= 18;
      if (m_btRace = 50) and (m_wAppearance in [54..58]) then begin   //ѩ��NPC 20081229
         if GetTickCount - m_dwDefFrameTime > m_dwFrameTime then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then m_nCurrentDefFrame := 0;
         end;
         nCode:= 19;
         DefaultMotion;
      end else begin
        nCode:= 20;
        if GetTickCount - m_dwSmoothMoveTime > 200 then begin
           if GetTickCount - m_dwDefFrameTime > 500 then begin
              m_dwDefFrameTime := GetTickCount;
              Inc (m_nCurrentDefFrame);
              if m_nCurrentDefFrame >= m_nDefFrameCount then m_nCurrentDefFrame := 0;
           end;
           nCode:= 21;
           DefaultMotion;
        end;
      end;
   end;
   nCode:= 22;
   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      nCode:= 23;
      LoadSurface;
   end;
  except
    DebugOutStr(Format('TActor.Run m_btRace:%d Code:%d',[m_btRace, nCode]));
  end;
end;

//���ݵ�ǰ������״̬������һ��������Ӧ��֡
function  TActor.Move (step: integer): Boolean;
var
   prv, curstep, maxstep: integer;
   Fastmove, normmove: Boolean;
   ErrCode: Integer;
begin
  ErrCode := 0;
  try
    Result := FALSE;
    fastmove := FALSE;
    normmove := FALSE;
    if (m_nCurrentAction = SM_BACKSTEP) then //or (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then
      Fastmove := TRUE;
    if (m_nCurrentAction = SM_RUSH) {or (m_nCurrentAction = SM_RUSH79)} or (m_nCurrentAction = SM_RUSHKUNG) then
      normmove := TRUE;
    ErrCode := 1;
    if (self = g_MySelf) and (not fastmove) and (not normmove) then begin
      //g_boMoveSlow := FALSE;  20080816ע�͵��𲽸���
      //g_boAttackSlow := FALSE; //20080816 ע�� ��������
      //20080816ע�͵��𲽸���
      //g_nMoveSlowLevel := 0;
      {//�����ܲ�
      if m_Abil.Weight > m_Abil.MaxWeight then begin
         g_nMoveSlowLevel := m_Abil.Weight div m_Abil.MaxWeight;
         g_boMoveSlow := TRUE;
      end;
      if m_Abil.WearWeight > m_Abil.MaxWearWeight then begin
         g_nMoveSlowLevel := g_nMoveSlowLevel + m_Abil.WearWeight div m_Abil.MaxWearWeight;
         g_boMoveSlow := TRUE;
      end;
      if m_Abil.HandWeight > m_Abil.MaxHandWeight then begin
         g_boAttackSlow := TRUE
      end;
      //�⸺��
      if g_boMoveSlow and (m_nSkipTick < g_nMoveSlowLevel) and (not g_boMoveSlow1) then begin

         Inc (m_nSkipTick);
         exit;
      end else begin }
         //m_nSkipTick := 0;
      //end;
      //�߶�������
      if (m_nCurrentAction = SM_WALK) or
         (m_nCurrentAction = SM_BACKSTEP) or
         (m_nCurrentAction = SM_RUN) or
         //(m_nCurrentAction = SM_HORSERUN) or  20080803ע��������Ϣ
         (m_nCurrentAction = SM_RUSH) or
         (m_nCurrentAction = SM_RUSHKUNG)
      then begin
         ErrCode := 2;
         case (m_nCurrentFrame - m_nStartFrame) of
            1: PlaySound (m_nFootStepSound);
            4: PlaySound (m_nFootStepSound + 1);
         end;
      end;
    end;

    Result := FALSE;
    m_boMsgMuch := FALSE;
    ErrCode := 3;
    if (self <> g_MySelf) and (m_MsgList <> nil) then begin
      if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
    end;
    prv := m_nCurrentFrame;
    //�ƶ�
    if (m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_RUN) or
      //(m_nCurrentAction = SM_HORSERUN) or 20080803ע��������Ϣ
      (m_nCurrentAction = SM_RUSH) or
      (m_nCurrentAction = SM_RUSHKUNG)
    then begin
     //������ǰ֡
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then begin
         m_nCurrentFrame := m_nStartFrame - 1;
      end;
      if m_nCurrentFrame < m_nEndFrame then begin
         Inc (m_nCurrentFrame);

         if m_boMsgMuch and not normmove then //�ӿ첽��
            if m_nCurrentFrame < m_nEndFrame then
               Inc (m_nCurrentFrame);

         curstep := m_nCurrentFrame-m_nStartFrame + 1;
         maxstep := m_nEndFrame-m_nStartFrame + 1;
         Shift (m_btDir, m_nMoveStep, curstep, maxstep);  //����
      end;
      if m_nCurrentFrame >= m_nEndFrame then begin
         if self = g_MySelf then begin
            if FrmMain.ServerAcceptNextAction then begin
               m_nCurrentAction := 0;      //��ǰ��������
               m_boLockEndFrame := TRUE;
               m_dwSmoothMoveTime := GetTickCount;
            end;
         end else begin
            m_nCurrentAction := 0; //���� �Ϸ�
            m_boLockEndFrame := TRUE;
            m_dwSmoothMoveTime := GetTickCount;
         end;
         Result := TRUE;
      end;
      ErrCode := 4;
      if m_nCurrentAction = SM_RUSH then begin
         if self = g_MySelf then begin
            g_dwDizzyDelayStart := GetTickCount;
            g_dwDizzyDelayTime := 300; //������
         end;
      end;
      if m_nCurrentAction = SM_RUSHKUNG then begin  //Ұ����ײʧ��
         if m_nCurrentFrame >= m_nEndFrame - 3 then begin
            m_nCurrX := m_nActBeforeX;
            m_nCurrY := m_nActBeforeY;
            m_nRx := m_nCurrX;
            m_nRy := m_nCurrY;
            m_nCurrentAction := 0;
            m_boLockEndFrame := TRUE;
            //m_dwSmoothMoveTime := GetTickCount;
         end;
      end;
      Result := TRUE;
    end;
    if (m_nCurrentAction = SM_BACKSTEP) then begin  //����
      if (m_nCurrentFrame > m_nEndFrame) or (m_nCurrentFrame < m_nStartFrame) then begin
         m_nCurrentFrame := m_nEndFrame + 1;
      end;
      if m_nCurrentFrame > m_nStartFrame then begin
         Dec (m_nCurrentFrame);
         if m_boMsgMuch or fastmove then
            if m_nCurrentFrame > m_nStartFrame then Dec (m_nCurrentFrame);

         //�ε巴�� �̵��ϰ� �Ϸ���
         curstep := m_nEndFrame - m_nCurrentFrame + 1;
         maxstep := m_nEndFrame - m_nStartFrame + 1;
         Shift (GetBack(m_btDir), m_nMoveStep, curstep, maxstep);
      end;
      if m_nCurrentFrame <= m_nStartFrame then begin
         if self = g_MySelf then begin
            //if FrmMain.ServerAcceptNextAction then begin
               m_nCurrentAction := 0;     //��ϢΪ��
               m_boLockEndFrame := TRUE;   //������ǰ����
               m_dwSmoothMoveTime := GetTickCount;

               //�ڷ� �и� ���� �ѵ��� �� �����δ�.
               g_dwDizzyDelayStart := GetTickCount;
               g_dwDizzyDelayTime := 1000; //1�� ������
            //end;
         end else begin
            m_nCurrentAction := 0; //���� �Ϸ�
            m_boLockEndFrame := TRUE;
            m_dwSmoothMoveTime := GetTickCount;
         end;
         Result := TRUE;
      end;
      Result := TRUE;
    end;
    ErrCode := 5;
    //����ǰ��������һ������֡��ͬ����װ�ص�ǰ��������
    if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      ErrCode := 6;
      LoadSurface;
    end;
  except
    DebugOutStr('TActor.Move Code:'+IntToStr(ErrCode));
  end;
end;

//�ƶ�ʧ�ܣ��������������ƶ����ʱ���˻ص��ϴε�λ��
procedure TActor.MoveFail;
begin
   m_nCurrentAction := 0; //���� �Ϸ�
   m_boLockEndFrame := TRUE;
   g_MySelf.m_nCurrX := m_nOldx;
   g_MySelf.m_nCurrY := m_nOldy;
   g_MySelf.m_btDir := m_nOldDir;
   CleanUserMsgs;
end;

function  TActor.CanCancelAction: Boolean;
begin
   Result := FALSE;
   if (m_nCurrentAction = SM_HIT) or (m_nCurrentAction = SM_HIT_107) then
      if not m_boUseEffect then
         Result := TRUE;
end;

procedure TActor.CancelAction;
begin
   m_nCurrentAction := 0; //���� �Ϸ�
   m_boLockEndFrame := TRUE;
end;

procedure TActor.CleanCharMapSetting (x, y: integer);
begin
   g_MySelf.m_nCurrX := x;
   g_MySelf.m_nCurrY := y;
   g_MySelf.m_nRx := x;
   g_MySelf.m_nRy := y;
   m_nOldx := x;
   m_nOldy := y;
   m_nCurrentAction := 0;
   m_nCurrentFrame := -1;
   CleanUserMsgs;
end;

//ʵ�ַ�����ʾ˵�����ݵ�Saying
procedure TActor.Say (str: string);
var
   i, len, aline, n: integer;
   temp: string;
   loop: Boolean;
const
   MAXWIDTH = 150;
begin
   m_dwSayTime := GetTickCount;
   m_nSayLineCount := 0;

   n := 0;
   loop := TRUE;
   while loop do begin
      temp := '';
      i := 1;
      len := Length (str);
      while TRUE do begin
         if i > len then begin
            loop := FALSE;
            break;
         end;
         if byte (str[i]) >= 128 then begin
            temp := temp + str[i];
            Inc (i);
            if i <= len then temp := temp + str[i]
            else begin
               loop := FALSE;
               break;
            end;
         end else
            temp := temp + str[i];

         aline := FrmMain.Canvas.TextWidth (temp);
         if aline > MAXWIDTH then begin
            m_SayingArr[n] := temp;
            m_SayWidthsArr[n] := aline;
            Inc (m_nSayLineCount);
            Inc (n);
            if n >= MAXSAY then begin
               loop := FALSE;
               break;
            end;
            str := Copy (str, i+1, Len-i);
            temp := '';
            break;
         end;
         Inc (i);
      end;
      if temp <> '' then begin
         if n < MAXWIDTH then begin
            m_SayingArr[n] := temp;
            m_SayWidthsArr[n] := FrmMain.Canvas.TextWidth (temp);
            Inc (m_nSayLineCount);
         end;
      end;
   end;
end;


{============================== NPCActor =============================}
procedure TNpcActor.CalcActorFrame;
var
  Pm:pTMonsterAction;
begin
  m_boUseMagic    :=False;
  m_nCurrentFrame :=-1;
  m_nBodyOffset   :=GetNpcOffset(m_wAppearance);
                //npcΪ50
  Pm:=GetRaceByPM(m_btRace,m_wAppearance);
  if pm = nil then exit;
  m_btDir := m_btDir mod 3;
  case m_nCurrentAction of
    SM_TURN: begin //ת��
      if g_boNpcWalk then Exit;
      if m_wAppearance in [54..62,70..75,90..93,64..66,82..84,103,105,107..112,113..118] then begin //�����ʼ�NPC
        m_nStartFrame := pm.ActStand.start;// + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
        m_dwFrameTime := pm.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := pm.ActStand.frame;
        Shift (m_btDir, 0, 0, 1);
        if m_wAppearance in [54..59,62,82..84, 103,107..112,116] then
          m_boUseEffect:=False
        else m_boUseEffect:=True;
        if m_boUseEffect then begin
          case m_wAppearance of
            61: begin //ʥ����
              m_nEffectStart:=pm.ActStand.start + 20;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 19;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=130;
            end;
            64: begin //����¯
              m_nEffectStart:=pm.ActStand.start + 10;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 11;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=130;
            end;
            65..66: begin
              m_nEffectStart:=pm.ActStand.start + 180;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 3;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=600;
            end;
            105: begin //
              m_nEffectStart:=610;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 15;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=300;
              m_boUseEffect1 := True;
            end;
            113..115: begin
              m_nEffectStart:=pm.ActStand.start + 10;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 14;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=130;
            end;
            117..118: begin
              m_nEffectStart:=pm.ActStand.start + 20;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 8;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=130;
            end;
            else begin
              m_nEffectStart:=pm.ActStand.start + 4;
              m_nEffectFrame:=m_nEffectStart;
              m_nEffectEnd:=m_nEffectStart + 3;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=600;
            end;
          end;
        end;
      end else begin
          m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
          m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
          m_dwFrameTime := pm.ActStand.ftime;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActStand.frame;
          Shift (m_btDir, 0, 0, 1);
          if ((m_wAppearance = 33) or (m_wAppearance = 34))and not m_boUseEffect then begin
            m_boUseEffect:=True;
            m_nEffectStart := 30;
            m_nEffectFrame:=m_nEffectStart;
            m_nEffectEnd:=m_nEffectStart + 9;
            m_dwEffectStartTime:=GetTickCount();
            m_dwEffectFrameTime:=300;
          end else begin
            if m_wAppearance in [42..47] then begin
              m_nStartFrame:=20;
              m_nEndFrame:=10;
              m_boUseEffect:=True;
              m_nEffectStart:=0;
              m_nEffectFrame:=0;
              m_nEffectEnd:=19;
              m_dwEffectStartTime:=GetTickCount();
              m_dwEffectFrameTime:=100;
            end else begin
              if m_wAppearance = 51 then begin
                m_boUseEffect:=True;
                m_nEffectStart:=60;
                m_nEffectFrame:=m_nEffectStart;
                m_nEffectEnd:=m_nEffectStart + 7;
                m_dwEffectStartTime:=GetTickCount();
                m_dwEffectFrameTime:=500;
              end;
            end;
          end;
        end;
    end;
    SM_HIT: begin  //����
      if g_boNpcWalk then Exit;
      case m_wAppearance of
        33,34,52,54..62,70..75,90..93,64..66,103,105,107..112,113..118: begin //70 �����ʼ�NPC
          if m_wAppearance in [54..62,70..75,90..93,64..66, 103,107..112,113..118] then m_nStartFrame := pm.ActStand.start else
          m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
          m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActStand.frame;
        end;
        else begin
          if m_wAppearance = 106 then //�ò���
            m_nStartFrame := pm.ActAttack.start + (pm.ActAttack.frame + pm.ActAttack.skip)
          else
            m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
          m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
          m_dwFrameTime := pm.ActAttack.ftime;
          m_dwStartTime := GetTickCount;
          if m_wAppearance = 51 then begin
            m_boUseEffect:=True;
            m_nEffectStart:=60;
            m_nEffectFrame:=m_nEffectStart;
            m_nEffectEnd:=m_nEffectStart + 7;
            m_dwEffectStartTime:=GetTickCount();
            m_dwEffectFrameTime:=500;
          end else
            if m_wAppearance in [82..84] then begin
              m_nStartFrame := pm.ActAttack.start;
              m_nEndFrame := m_nStartFrame + pm.ActStand.frame;
            end;
        end;
      end;
    end;
    SM_DIGUP: begin
      if m_wAppearance = 52 then begin
        m_bo248:=True;
        m_dwUseEffectTick:=GetTickCount + 23000;
        Randomize;
        PlaySound(Random(7) + 146);
        m_boUseEffect:=True;
        m_nEffectStart:=60;
        m_nEffectFrame:=m_nEffectStart;
        m_nEffectEnd:=m_nEffectStart + 11;
        m_dwEffectStartTime:=GetTickCount();
        m_dwEffectFrameTime:=100;
      end;
    end;
    SM_NPCWALK: begin //NPC�߶�
      if m_wAppearance = 81 then begin
        m_nStartFrame := 4250;
        m_nEndFrame := m_nStartFrame + 79;
        m_nCurrentFrame := -1;
        m_dwFrameTime := 80;
        m_dwStartTime := GetTickCount;
        g_boNpcWalk := True;
      end;
    end;
  end;
end;

constructor TNpcActor.Create; //0x0047C42C
begin
  inherited;
  m_EffSurface:=nil;
  m_boHitEffect:=False;
  m_EffSurface1:=nil;
  m_boUseEffect1:=False;
  m_bo248:=False;
  m_boNpcWalkEffect := False; //20080621
  m_boNpcWalkEffectSurface := nil; //20080621
  g_boNpcWalk := False;
end;

destructor TNpcActor.Destroy;
begin
  inherited Destroy;
end;
// ��NPC ��������ͼ
procedure TNpcActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  try
    m_btDir := m_btDir mod 3;
    if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
    end;
    ceff := GetDrawEffectValue;

    if m_BodySurface <> nil then begin
      if m_wAppearance in [54..58] then begin //ѩ��NPC
        DrawBlend (dsurface,
               dx + m_nPx + m_nShiftX,
               dy + m_nPy + m_nShiftY,
               m_BodySurface,
               120);
      end else
      if m_wAppearance = 51 then begin  //�ƹ��ϰ���
        DrawEffSurface (dsurface,
                        m_BodySurface,
                        dx + m_nPx + m_nShiftX,
                        dy + m_nPy + m_nShiftY,
                        True,
                        ceff);
      end else begin
        DrawEffSurface (dsurface,      //�˴�Ϊ��
                        m_BodySurface,
                        dx + m_nPx + m_nShiftX,
                        dy + m_nPy + m_nShiftY,
                        blend,
                        ceff);
      end;
    end;
    if m_boNpcWalkEffect then begin   //���ƹ�2�� �ϰ���Ч��(�߳������Ĺ�)
      if m_boNpcWalkEffectSurface <> nil then begin
        DrawBlend (dsurface,
               dx + m_nNpcWalkEffectPx + m_nShiftX,
               dy + m_nNpcWalkEffectPy + m_nShiftY,
               m_boNpcWalkEffectSurface,
               120);
      end;
    end;
  except
    DebugOutStr('TNpcActor.DrawChr');
  end;
end;


procedure TNpcActor.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  try
    if m_boUseEffect1 and (m_EffSurface1 <> nil) then begin
      DrawBlend (dsurface,
                 dx + m_nEffX1 + m_nShiftX,
                 dy + m_nEffY1 + m_nShiftY,
                 m_EffSurface1,
                 120);
    end;
    if m_boUseEffect and (m_EffSurface <> nil) then begin
      DrawBlend (dsurface,
                 dx + m_nEffX + m_nShiftX,
                 dy + m_nEffY + m_nShiftY,
                 m_EffSurface,
                 120);
    end;
  except
    DebugOutStr('TNpcActor.DrawEff');
  end;
end;

function  TNpcActor.GetDefaultFrame (wmode: Boolean): integer;
var
   cf: integer;
   pm: PTMonsterAction;
begin
   Result:=0;//Jacky
   pm := GetRaceByPM (m_btRace,m_wAppearance);
   if pm = nil then exit;
   m_btDir := m_btDir mod 3;  //NPCֻ��3�����������ˣ�

   if m_nCurrentDefFrame < 0 then cf := 0
   else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
   else cf := m_nCurrentDefFrame;
   if m_wAppearance in [54..62,70..75,90..93,64..66,82..84, 103,107..112,113..118] then  //�����ʼ�NPC
    Result := pm.ActStand.start + cf
   else
   Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
end;

procedure TNpcActor.LoadSurface;
begin
  if (m_wAppearance = 81) and g_boNpcWalk then begin  //�ϰ���
   m_BodySurface:=g_WNpcImgImages.GetCachedImage(m_nCurrentFrame, m_nPx, m_nPy); //ȡͼ
   if m_boNpcWalkEffect then  //ȡ�������ͼ 20080621
     m_boNpcWalkEffectSurface:=g_WNpcImgImages.GetCachedImage(m_nCurrentFrame+79, m_nNpcWalkEffectPx, m_nNpcWalkEffectPy); //ȡͼ
  end else begin
    m_BodySurface := frmMain.GetWNpcImg(m_wAppearance, m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
   // m_BodySurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
  end;

  if m_wAppearance in [42..47] then m_BodySurface:=nil;
  if m_boUseEffect then begin
    if m_wAppearance in [33..34] then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance = 42 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX:=m_nEffX + 71;
      m_nEffY:=m_nEffY + 5;
    end else if m_wAppearance = 43 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX:=m_nEffX + 71;
      m_nEffY:=m_nEffY + 37;
    end else if m_wAppearance = 44 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX:=m_nEffX + 7;
      m_nEffY:=m_nEffY + 12;
    end else if m_wAppearance = 45 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX:=m_nEffX + 6;
      m_nEffY:=m_nEffY + 12;
    end else if m_wAppearance = 46 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX:=m_nEffX + 7;
      m_nEffY:=m_nEffY + 12;
    end else if m_wAppearance = 47 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX:=m_nEffX + 8;
      m_nEffY:=m_nEffY + 12;
    end else if m_wAppearance = 51 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance = 52 then begin
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance in [70..75,90..93, 60, 61, 64..66] then begin //�����ʼ�NPC
      m_EffSurface:=g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance = 105 then begin
      m_EffSurface:=g_WStateEffectImages.GetCachedImage(m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance in [113..118] then begin
      m_EffSurface:=g_WNpc2ImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end;
  end;
  if m_boUseEffect1 then begin
    if m_wAppearance = 105 then begin
      m_EffSurface1:=g_WNpc2ImgImages.GetCachedImage(m_nBodyOffset+m_nCurrentFrame+4, m_nEffX1, m_nEffY1);
    end;
  end;
end;


procedure TNpcActor.Run;
var
  nEffectFrame:Integer;
  dwEffectFrameTime:LongWord;
begin
  try
    inherited Run;
    if (m_wAppearance = 81) and g_boNpcWalk then begin
      if not m_boNpcWalkEffect then begin
        if m_nCurrentFrame = 4297 then m_boNpcWalkEffect := True;
      end;
    
      if m_nCurrentFrame >= m_nEndFrame then begin
        g_boNpcWalk := False;
        m_boNpcWalkEffect := False;
        SendMsg (SM_TURN, m_nCurrX, m_nCurrY, m_btDir, 0, m_nState, '', 0, m_nFeature); //ת��
      end;
    end;

    nEffectFrame:=m_nEffectFrame;
    if m_boUseEffect then begin    //NPC�Ƿ�ʹ����ħ����
      if m_boUseMagic then begin
        dwEffectFrameTime:=Round(m_dwEffectFrameTime / 3);
      end else dwEffectFrameTime:=m_dwEffectFrameTime;

      if GetTickCount - m_dwEffectStartTime > dwEffectFrameTime then begin
        m_dwEffectStartTime:=GetTickCount();
        if m_nEffectFrame < m_nEffectEnd then begin
          Inc(m_nEffectFrame);
        end else begin
          if m_bo248 then begin
            if GetTickCount > m_dwUseEffectTick then begin
              m_boUseEffect:=False;
              m_bo248:=False;
              m_dwUseEffectTick:=GetTickCount();
            end;
            m_nEffectFrame:=m_nEffectStart;
          end else m_nEffectFrame:=m_nEffectStart;
          m_dwEffectStartTime:=GetTickCount();
        end;
      end;
    end;
    if nEffectFrame <> m_nEffectFrame then begin     //ħ����
      m_dwLoadSurfaceTime:=GetTickCount();
      LoadSurface();
    end;
  except
    DebugOutStr('TNpcActor.Run');
  end;
end;


{============================== HUMActor =============================}
constructor THumActor.Create;
begin
   inherited Create;
   m_HairSurface := nil;
   m_WeaponSurface := nil;
   m_WeaponEffSurface := nil;
   m_HumWinSurface:=nil;
   m_boWeaponEffect := FALSE;
   //m_boMagbubble4      := False; //20080811
   m_dwFrameTime:=150;
   m_dwFrameTick:=GetTickCount();
   m_nFrame:=0;
   m_dwEffFrameTime:=150;
   m_dwEffFrameTick:=GetTickCount();
   m_nEffFrame:=0;
   m_nHumWinOffset:=0;
   m_nCboHumWinOffset:=0;
   m_Hit4Meff := nil;
   m_nFeature.nDressLook := High(m_nFeature.nDressLook);
   m_nFeature.nWeaponLook := High(m_nFeature.nWeaponLook);
  {$IF M2Version <> 2}
  m_wTitleIcon := 0;
  m_sTitleName := '';
  {$IFEND}
end;

destructor THumActor.Destroy;
begin
  inherited Destroy;
end;

procedure THumActor.CalcActorFrame;
{var
  haircount: integer; }
var
  Meff:TMagicEff;
begin
  m_boUseMagic := FALSE;
  m_boHitEffect := FALSE;
  m_nCurrentFrame := -1;
  m_boCboMode := False;
   //human
  m_btHair   := m_nFeature.btHair; //HAIRfeature (m_nFeature);         //����
  m_btDress  := m_nFeature.nDress; //DRESSfeature (m_nFeature);        //����//��װ
  m_btWeapon := m_nFeature.nWeapon; //WEAPONfeature (m_nFeature);
 // m_btHorse  :=Horsefeature(m_nFeatureEx);  20080721 ע������
  m_btEffect :=Effectfeature(m_nFeatureEx);
  m_nBodyOffset := HUMANFRAME * (m_btDress); //m_btSex; //��0, Ů1

  //haircount := g_WHairImgImages.ImageCount div {HUMANFRAME}1200 div 2;  //����ͷ����=3600/600/2=3,��ÿ���Ա�ķ�����
  //PlayScene.MemoLog.Lines.Add('sdf '+inttostr(g_WHairImgImages.ImageCount div {HUMANFRAME}1200 div 2));

  case m_btHair of
    255: m_nHairOffset := HUMANFRAME * (m_btSex + 6);  //��ͨ����
    254: m_nHairOffset := HUMANFRAME * (m_btSex + 8); //��ɫ����
    253: m_nHairOffset := HUMANFRAME * (m_btSex + 12); //��ɱ����
    252: m_nHairOffset := HUMANFRAME * ({m_btSex +} 10); //��ţ����   Ů�Ķ�������������
    251: m_nHairOffset := HUMANFRAME * (m_btSex + 14); //��ţ����   Ů�Ķ�������������
    250: m_nHairOffset := HUMANFRAME * (m_btSex + 16); //���涷��
    249: m_nHairOffset := HUMANFRAME * (m_btSex + 18); //��¶���
    else begin
      if m_btSex = 1 then begin //Ů
        if m_btHair = 1 then begin
          m_nCboHairOffset := 2000;
          m_nHairOffset := 600
        end else begin
           if m_btHair > 1{haircount-1} then m_btHair := 1{haircount-1};
           m_btHair := m_btHair * 2;
           if m_btHair > 1 then begin
              m_nCboHairOffset := NEWHUMANFRAME * (m_btHair + m_btSex);
              m_nHairOffset := HUMANFRAME * (m_btHair + m_btSex);
           end else begin
             m_nCboHairOffset := -1;
             m_nHairOffset := -1;
           end;
        end;
      end else begin                 //��
        if m_btHair = 0 then begin
          m_nHairOffset := -1;
          m_nCboHairOffset := -1;
        end else begin
           if m_btHair > 1{haircount-1} then m_btHair := 1{haircount-1};
           m_btHair := m_btHair * 2;
           if m_btHair > 1 then begin
              m_nCboHairOffset := NEWHUMANFRAME * (m_btHair + m_btSex);
              m_nHairOffset := HUMANFRAME * (m_btHair + m_btSex);
           end else begin
             m_nCboHairOffset := -1;
             m_nHairOffset := -1;
           end;
        end;
      end;
    end;
  end;
  m_nWeaponOffset := HUMANFRAME * m_btWeapon; //(weapon*2 + m_btSex);    //����ͼƬ��ʼ֡�������Ա𣿣�
  if m_nFeature.nWeaponLook <> High(m_nFeature.nWeaponLook) then begin
    if (m_nFeature.nWeaponLook > 2399) and (m_nFeature.nWeaponLookWil = 1) then begin
      m_nWeaponEffOffset := m_nFeature.nWeaponLook + m_btSex * HUMANFRAME;
      m_nCboWeaponEffOffset := (m_nWeaponEffOffset div HUMANFRAME2) * NEWHUMANFRAME2 - 16000 + m_btSex * NEWHUMANFRAME;
    end else begin
      m_nWeaponEffOffset := m_nFeature.nWeaponLook + m_btSex * HUMANFRAME;
      if m_nFeature.nWeaponLookWil <> 2 then
        m_nCboWeaponEffOffset := (m_nWeaponEffOffset div HUMANFRAME2) * NEWHUMANFRAME2 + 40000 + m_btSex * NEWHUMANFRAME;
    end;
  end;
  if m_btEffect = 50 then
    m_nHumWinOffset:=352
  else if m_nFeature.nDressLook <> High(m_nFeature.nDressLook) then begin
    if (m_nFeature.nDressLook > 4799) and (m_nFeature.nDressLookWil = 1) then begin
      m_nHumWinOffset := m_nFeature.nDressLook;
      m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME - 8) * NEWHUMANFRAME;
    end else begin
      m_nHumWinOffset := m_nFeature.nDressLook;
      case m_nFeature.nDressLookWil of
        0,3: m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME;
        1,2: m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME + 40000;
      end;
      {if m_nFeature.nDressLookWil = 0 then
        m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME
      else m_nCboHumWinOffset := (m_nHumWinOffset div HUMANFRAME) * NEWHUMANFRAME + 40000;   }
    end;
  end;

  case m_nCurrentAction of
    SM_TURN: begin//ת
      m_nStartFrame := HA.ActStand.start + m_btDir * (HA.ActStand.frame + HA.ActStand.skip);
      m_nEndFrame := m_nStartFrame + HA.ActStand.frame - 1;
      m_dwFrameTime := HA.ActStand.ftime;
      m_dwStartTime := GetTickCount;
      m_nDefFrameCount := HA.ActStand.frame;
      Shift (m_btDir, 0, 0, m_nEndFrame-m_nStartFrame+1);
    end;
    SM_WALK, //��
    SM_BACKSTEP: begin//����
      m_nStartFrame := HA.ActWalk.start + m_btDir * (HA.ActWalk.frame + HA.ActWalk.skip);
      m_nEndFrame := m_nStartFrame + HA.ActWalk.frame - 1;
      m_dwFrameTime := HA.ActWalk.ftime;
      m_dwStartTime := GetTickCount;
      m_nMaxTick := HA.ActWalk.UseTick;
      m_nCurTick := 0;
      //WarMode := FALSE;
      m_nMoveStep := 1;
      if m_nCurrentAction = SM_BACKSTEP then
         Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1)
      else Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
    end;
    SM_RUSH: begin//Ұ����ײ
      if m_nRushDir = 0 then begin
        m_nRushDir := 1;
        m_nStartFrame := HA.ActRushLeft.start + m_btDir * (HA.ActRushLeft.frame + HA.ActRushLeft.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRushLeft.frame - 1;
        m_dwFrameTime := HA.ActRushLeft.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := HA.ActRushLeft.UseTick;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        Shift (m_btDir, 1, 0, m_nEndFrame-m_nStartFrame+1);
      end else begin
        m_nRushDir := 0;
        m_nStartFrame := HA.ActRushRight.start + m_btDir * (HA.ActRushRight.frame + HA.ActRushRight.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRushRight.frame - 1;
        m_dwFrameTime := HA.ActRushRight.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := HA.ActRushRight.UseTick;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        Shift (m_btDir, 1, 0, m_nEndFrame-m_nStartFrame+1);
      end;
    end;
    SM_RUSHKUNG: begin//Ұ����ײʧ��
      m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
      m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
      m_dwFrameTime := HA.ActRun.ftime;
      m_dwStartTime := GetTickCount;
      m_nMaxTick := HA.ActRun.UseTick;
      m_nCurTick := 0;
      m_nMoveStep := 1;
      Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
    end;
    SM_SITDOWN: begin
      m_nStartFrame := HA.ActSitdown.start + m_btDir * (HA.ActSitdown.frame + HA.ActSitdown.skip);
      m_nEndFrame := m_nStartFrame + HA.ActSitdown.frame - 1;
      m_dwFrameTime := HA.ActSitdown.ftime;
      m_dwStartTime := GetTickCount;
    end;
    SM_RUN: begin
      m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
      m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
      m_dwFrameTime := HA.ActRun.ftime;
      m_dwStartTime := GetTickCount;
      m_nMaxTick := HA.ActRun.UseTick;
      m_nCurTick := 0;
      //WarMode := FALSE;
      if m_nCurrentAction = SM_RUN then m_nMoveStep := 2
      else m_nMoveStep := 1;

      //m_nMoveStep := 2;
      Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
    end;
      { 20080803ע��������Ϣ
      SM_HORSERUN: begin
            m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
            m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
            m_dwFrameTime := HA.ActRun.ftime;
            m_dwStartTime := GetTickCount;
            m_nMaxTick := HA.ActRun.UseTick;
            m_nCurTick := 0;
            //WarMode := FALSE;
            if m_nCurrentAction = SM_HORSERUN then m_nMoveStep := 3
            else m_nMoveStep := 1;

            //m_nMoveStep := 2;
            Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
      end;    }
      {SM_THROW:  //20080803ע��
         begin
            m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
            m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
            m_dwFrameTime := HA.ActHit.ftime;
            m_dwStartTime := GetTickCount;
            m_boWarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            m_boThrow := TRUE;
            Shift (m_btDir, 0, 0, 1);
         end; }
      SM_HIT, SM_POWERHIT, {$IF M2Version <> 2}SM_LONGHITFORFENGHAO,SM_FIREHITFORFENGHAO,{$IFEND}
      SM_LONGHIT, SM_LONGHIT4, SM_WIDEHIT, SM_WIDEHIT4, SM_BATTERHIT1,SM_BATTERHIT2,SM_BATTERHIT3,SM_BATTERHIT4,
      SM_FIREHIT{�һ�}, SM_4FIREHIT{4���һ�}, SM_CRSHIT, SM_TWINHIT{����ն�ػ�}, SM_QTWINHIT{����ն���},
      SM_CIDHIT{��Ӱ����},SM_LEITINGHIT,SM_BLOODSOUL{Ѫ��һ��(ս)},SM_WIDEHIT4EX1..SM_WIDEHIT4EX3,
      SM_FIREHITEX1..SM_FIREHITEX3, SM_POWERHITEX1..SM_POWERHITEX3,SM_LONGHITEX1..SM_LONGHITEX3,
      SM_HIT_107:
         begin
           if m_nCurrentAction <>  SM_BATTERHIT4 then begin
             m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
             m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
             m_dwFrameTime := HA.ActHit.ftime;
             m_dwStartTime := GetTickCount;
             m_boWarMode := TRUE;
             m_dwWarModeTime := GetTickCount;
           end;

            if (m_nCurrentAction = SM_POWERHIT) then begin //��ɱ
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 1;
            end;
            if (m_nCurrentAction = SM_LONGHIT) then begin  //��ɱ
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 2;
            end;
            {$IF M2Version <> 2}
            if (m_nCurrentAction = SM_LONGHITFORFENGHAO) then begin //��ɫ��ɱ
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 20;
            end;
            if (m_nCurrentAction = SM_FIREHITFORFENGHAO) then begin //��ɫ�һ�
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 21;
            end;
            {$IFEND}
            if (m_nCurrentAction = SM_LONGHIT4) then begin  //4����ɱ
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 17;
            end;
            if (m_nCurrentAction = SM_WIDEHIT) then begin  //����
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 3;
            end;
            if (m_nCurrentAction = SM_WIDEHIT4) then begin  //Բ���䵶
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 18;
            end;
            if (m_nCurrentAction = SM_FIREHIT) then begin  //�һ�
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 4;
            end;
            if (m_nCurrentAction = SM_4FIREHIT) then begin  //4���һ�
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 9;
            end;
            if (m_nCurrentAction = SM_CRSHIT) then begin   //����
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 6;
            end;
            if (m_nCurrentAction = SM_TWINHIT) then begin  //����ն�ػ�
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 7;
               meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagic5Images,m_btDir*10+550,10,85,True);
               PlayScene.m_EffectList.Add(meff);
            end;
            if (m_nCurrentAction = SM_QTWINHIT) then begin  //����ն��� 2008.02.12
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 10;
               meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagic5Images,m_btDir*10+710,10,85,True);
               PlayScene.m_EffectList.Add(meff);
            end;
            if (m_nCurrentAction = SM_CIDHIT) then begin  //��Ӱ����
               m_boHitEffect := TRUE;
               m_nMagLight := 2;
               m_nHitEffectNumber := 8;
            end;
            if (m_nCurrentAction = SM_FIREHITEX1) then begin 
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 25;
            end;
            if (m_nCurrentAction = SM_FIREHITEX2) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 26;
            end;
            if (m_nCurrentAction = SM_FIREHITEX3) then begin 
              m_boHitEffect := TRUE;
              m_nMagLight := 2;
              m_nHitEffectNumber := -1;
              meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagic8Images16,m_btDir*10+1840,8,85,True);
              PlayScene.m_EffectList.Add(meff);
            end;
            if (m_nCurrentAction = SM_WIDEHIT4EX1) then begin 
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 27;
            end;
            if (m_nCurrentAction = SM_WIDEHIT4EX2) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 28;
            end;
            if (m_nCurrentAction = SM_WIDEHIT4EX3) then begin 
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 29;
            end;
            if (m_nCurrentAction = SM_POWERHITEX1) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 30;
            end;
            if (m_nCurrentAction = SM_POWERHITEX2) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 31;
            end;
            if (m_nCurrentAction = SM_POWERHITEX3) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 32;
            end;
            if (m_nCurrentAction = SM_LONGHITEX1) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 33;
            end;
            if (m_nCurrentAction = SM_LONGHITEX2) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 34;
            end;
            if (m_nCurrentAction = SM_LONGHITEX3) then begin
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 35;
            end;
            if (m_nCurrentAction = SM_HIT_107) then begin//�ݺὣ��
              m_boHitEffect := TRUE;
              m_nMagLight := 2;
              m_nHitEffectNumber := -1;
              meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagic10Images,m_btDir*20+420,15,85,True);
              PlayScene.m_EffectList.Add(meff);
            end;
            if (m_nCurrentAction = SM_LEITINGHIT{����һ��սʿЧ�� 20080611}) then begin
               m_boHitEffect := True;
               m_nMagLight := 2;
               m_nHitEffectNumber := 12;
            end;
            //׷�Ĵ�
            if (m_nCurrentAction =  SM_BATTERHIT1)  then begin
              m_nStartFrame := HA.ActCboSpell9.start + m_btDir * (HA.ActCboSpell9.frame + HA.ActCboSpell9.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCboSpell9.frame - 1;
              m_dwFrameTime := HA.ActCboSpell9.ftime;
              m_dwStartTime := GetTickCount;
              m_boWarMode := TRUE;
              m_dwWarModeTime := GetTickCount;
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 13;
              m_boCboMode := True;
            end;
            //����ɱ
            if (m_nCurrentAction =  SM_BATTERHIT2) then begin
              m_nStartFrame := HA.ActCboSpell11.start + m_btDir * (HA.ActCboSpell11.frame + HA.ActCboSpell11.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCboSpell11.frame - 1;
              m_dwFrameTime := HA.ActCboSpell11.ftime;
              m_dwStartTime := GetTickCount;
              m_boWarMode := TRUE;
              m_dwWarModeTime := GetTickCount;
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 15;
              m_boCboMode := True;
            end;
            //��ɨǧ��
            if (m_nCurrentAction =  SM_BATTERHIT3) then begin
              m_nStartFrame := HA.ActCboSpell10.start + m_btDir * (HA.ActCboSpell10.frame + HA.ActCboSpell10.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCboSpell10.frame - 1;
              m_dwFrameTime := HA.ActCboSpell10.ftime;
              m_dwStartTime := GetTickCount;
              m_boWarMode := TRUE;
              m_dwWarModeTime := GetTickCount;
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 14;
              m_boCboMode := True;
            end;
            //����ն
            if (m_nCurrentAction =  SM_BATTERHIT4) then begin   //����Ч����
              m_nStartFrame :=  HA.ActWarMode.start + m_btDir * (HA.ActWarMode.frame + HA.ActWarMode.skip);
              m_nEndFrame := m_nStartFrame + HA.ActWarMode.frame - 1;
              m_dwFrameTime := 1000;
              m_dwStartTime := GetTickCount;
              m_boWarMode := TRUE;
              m_dwWarModeTime := GetTickCount;
              m_Hit4Meff := TObjectEffects.Create(Self,g_WCboEffectImages,1920+m_btDir*10,5,90,TRUE{Blendģʽ});
              m_Hit4Meff.ImgLib := g_WCboEffectImages;
              m_Hit4Meff.MagOwner:=self;
              PlayScene.m_EffectList.Add(m_Hit4Meff);
              m_boHit4 := True;
            end;
            //Ѫ��һ��(ս)
            if (m_nCurrentAction = SM_BLOODSOUL) then begin
              m_nStartFrame := HA.ActCboSpell12.start + m_btDir * (HA.ActCboSpell12.frame + HA.ActCboSpell12.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCboSpell12.frame - 1;
              m_dwFrameTime := HA.ActCboSpell12.ftime+35;
              m_dwStartTime := GetTickCount;
              m_boHitEffect := True;
              m_nMagLight := 2;
              m_nHitEffectNumber := 19;
              m_boCboMode := True;
            end;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_HEAVYHIT:
         begin
            m_nStartFrame := HA.ActHeavyHit.start + m_btDir * (HA.ActHeavyHit.frame + HA.ActHeavyHit.skip);
            m_nEndFrame := m_nStartFrame + HA.ActHeavyHit.frame - 1;
            m_dwFrameTime := HA.ActHeavyHit.ftime;
            m_dwStartTime := GetTickCount;
            m_boWarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
         end;
      SM_BIGHIT, SM_DAILY{���ս���}{$IF M2Version <> 2},SM_DAILYFORFENGHAO{$IFEND},
      SM_DAILYEX1..SM_DAILYEX3:
         begin
            m_nStartFrame := HA.ActBigHit.start + m_btDir * (HA.ActBigHit.frame + HA.ActBigHit.skip);
            m_nEndFrame := m_nStartFrame + HA.ActBigHit.frame - 1;
            m_dwFrameTime := HA.ActBigHit.ftime;
            m_dwStartTime := GetTickCount;
            m_boWarMode := TRUE;
            m_dwWarModeTime := GetTickCount;
            Shift (m_btDir, 0, 0, 1);
            case m_nCurrentAction of
              SM_DAILY: begin
                m_boHitEffect := True;
                m_nMagLight := 2;
                m_nHitEffectNumber := 11;
              end;
              {$IF M2Version <> 2}
              SM_DAILYFORFENGHAO: begin
                m_boHitEffect := True;
                m_nMagLight := 2;
                m_nHitEffectNumber := 22;
              end;
              {$IFEND}
              SM_DAILYEX1: begin
                m_boHitEffect := True;
                m_nMagLight := 2;
                m_nHitEffectNumber := 23;
              end;
              SM_DAILYEX2: begin
                m_boHitEffect := True;
                m_nMagLight := 2;
                m_nHitEffectNumber := 24;
              end;
              SM_DAILYEX3: begin
                m_boHitEffect := TRUE;
                m_nMagLight := 2;
                m_nHitEffectNumber := -1;
                meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagic9Images,m_btDir*10+180,8,85,True);
                PlayScene.m_EffectList.Add(meff);
              end;
            end;
         end;
      SM_SPELL: //����ʹ��ħ����Ϣ
         begin
              m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
              m_dwFrameTime := HA.ActSpell.ftime;
              m_dwStartTime := GetTickCount;
              m_nCurEffFrame := 0;
              m_boUseMagic := TRUE;
              
              m_nMagLight := 2;
              m_nSpellFrame := 8;
            if m_CurMagic.EffectLevelEx in [1..9] then begin
              case m_CurMagic.EffectNumber of
                10, 11, 12, 100, 118, 119: begin//���,�����,��ʥս����,4�����,��ɫ��ʥս����, ��ɫ�����
                  case m_CurMagic.EffectLevelEx of
                    1..3: m_nSpellFrame := 7;
                    4..6: m_nSpellFrame := 9;
                    7..9: m_nSpellFrame := 10;
                  end;
                end;
                15: m_nSpellFrame := 10; //�ٻ�����
                76: begin //�ٻ�ʥ��
                  case m_CurMagic.EffectLevelEx of
                    1..3: m_nSpellFrame := 12;
                    4..6: m_nSpellFrame := 15;
                    7..9: m_nSpellFrame := 17;
                  end;
                end;
              end;
            end else
            case m_CurMagic.EffectNumber of
               60: begin
                  m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
                  m_dwFrameTime := HA.ActHit.ftime;
                  m_nMagLight := 2;
                  m_nSpellFrame := 2;
                  //m_nSpellFrame := 15;//15
               end;
               22: begin //�����׹�
                 m_nMagLight := 4;  //�ڼ�ȭ
                 m_nSpellFrame := 10; //�ڼ�ȭ�� 10 ���������� ����
               end;
               26: begin //������ʾ
                 m_nMagLight := 2;
                 m_nSpellFrame := 20;
                 m_dwFrameTime := m_dwFrameTime div 2;
               end;
               129: m_nSpellFrame := 10;
               {43: begin //ʨ�Ӻ�
                 m_nMagLight := 2;
                 m_nSpellFrame := 20;
               end;  }
               52: begin  //�ļ�ħ����
                  m_nSpellFrame := 9;
               end;
               80: m_nSpellFrame := 10; //4�����ǻ���
               91: begin  //�������
                 m_nSpellFrame := 10;
               end;
               66: begin //��������
                 m_nSpellFrame := 16;
               end;
               77,78: m_nSpellFrame := 10; //4��ʩ����
               132: m_nSpellFrame := 18; //����֮��
               103: begin //˫���� 20090624
                  m_nStartFrame := HA.ActCboSpell1.start + m_btDir * (HA.ActCboSpell1.frame + HA.ActCboSpell1.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell1.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell1.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := CBODEFSPELLFRAME;
               end;
               104: begin //��Х�� 20090624
                  m_nStartFrame := HA.ActCboSpell7.start + m_btDir * (HA.ActCboSpell7.frame + HA.ActCboSpell7.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell7.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell7.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := 6;
               end;
               106: begin //����� 20090624
                  m_nStartFrame := HA.ActCboSpell6.start + m_btDir * (HA.ActCboSpell6.frame + HA.ActCboSpell6.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell6.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell6.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := 6;
               end;
               107: begin //������ 20090624
                  m_nStartFrame := HA.ActCboSpell5.start + m_btDir * (HA.ActCboSpell5.frame + HA.ActCboSpell5.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell5.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell5.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := 12;
               end;
               109: begin //���ױ� 20090624
                  m_nStartFrame := HA.ActCboSpell2.start + m_btDir * (HA.ActCboSpell2.frame + HA.ActCboSpell2.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell2.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell2.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := DEFSPELLFRAME;
               end;
               110: begin //������
                  m_nStartFrame := HA.ActCboSpell4.start + m_btDir * (HA.ActCboSpell4.frame + HA.ActCboSpell4.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell4.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell4.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := 12;
               end;
               112: begin //����ѩ�� 20090624
                  m_nStartFrame := HA.ActCboSpell3.start + m_btDir * (HA.ActCboSpell3.frame + HA.ActCboSpell3.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell3.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell3.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := True;
                  m_nSpellFrame := 8;
               end;
               113: begin //�򽣹��� 20090624
                  m_nStartFrame := HA.ActCboSpell8.start + m_btDir * (HA.ActCboSpell8.frame + HA.ActCboSpell8.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell8.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell8.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := TRUE;
                  m_nSpellFrame := 14;
               end;
               55: begin //����ٵ�
                  m_nStartFrame :=  HA.ActCboSpell13.start + m_btDir * (HA.ActCboSpell13.frame + HA.ActCboSpell13.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell13.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell13.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := True;
                  m_nSpellFrame := 12;
               end;
               82: begin //Ѫ��һ��(��)
                  m_nStartFrame :=  HA.ActCboSpell14.start + m_btDir * (HA.ActCboSpell14.frame + HA.ActCboSpell14.skip);
                  m_nEndFrame := m_nStartFrame + HA.ActCboSpell14.frame - 1;
                  m_dwFrameTime := HA.ActCboSpell14.ftime;
                  m_dwStartTime := GetTickCount;
                  m_nCurEffFrame := 0;
                  m_boCboMode := True;
                  m_boUseMagic := True;
                  m_nSpellFrame := 9;
               end;
            end;
            if (m_btRace = 1) or (m_btRace = 150) then  //Ӣ�ۣ�����
              m_dwWaitMagicRequest := GetTickCount - 1500 //��ֹ,����������ʱ����Ϣ�ۻ�,Ӣ���������ӷ�ħ��ʱ,���־��ֿ����� ���پ��ַ��µ�ʱ����20080720
            else begin
              if m_CurMagic.EffectNumber in [103,106,109,112] then
                 m_dwWaitMagicRequest := GetTickCount - 1500
              else
              m_dwWaitMagicRequest := GetTickCount;
            end;
            m_boWarMode := TRUE;
            m_dwWarModeTime := GetTickCount;

            Shift (m_btDir, 0, 0, 1);
         end;
      (*SM_READYFIREHIT:
         begin
            startframe := HA.ActFireHitReady.start + Dir * (HA.ActFireHitReady.frame + HA.ActFireHitReady.skip);
            m_nEndFrame := startframe + HA.ActFireHitReady.frame - 1;
            m_dwFrameTime := HA.ActFireHitReady.ftime;
            m_dwStartTime := GetTickCount;

            BoHitEffect := TRUE;
            HitEffectNumber := 4;
            MagLight := 2;

            CurGlimmer := 0;
            MaxGlimmer := 6;

            WarMode := TRUE;
            WarModeTime := GetTickCount;
            Shift (Dir, 0, 0, 1);
         end; *)
      SM_STRUCK: begin
        m_nStartFrame := HA.ActStruck.start + m_btDir * (HA.ActStruck.frame + HA.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + HA.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; //HA.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift (m_btDir, 0, 0, 1);

        m_dwGenAnicountTime := GetTickCount;
        m_nCurBubbleStruck := 0;
        m_nCurProtEctionStruck := 0;
        m_dwProtEctionStruckTime := GetTickCount;
      end;
      SM_NOWDEATH: begin
        m_nStartFrame := HA.ActDie.start + m_btDir * (HA.ActDie.frame + HA.ActDie.skip);
        m_nEndFrame := m_nStartFrame + HA.ActDie.frame - 1;
        m_dwFrameTime := HA.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

procedure THumActor.DefaultMotion;
var
  wm: TWMImages;
begin
  inherited DefaultMotion;
  if (m_btEffect = 50) then begin
    if (m_nCurrentFrame <= 536) then begin
      if (GetTickCount - m_dwFrameTick) > 100 then begin
        if m_nFrame < 19 then Inc(m_nFrame)
        else begin
          {if not m_bo2D0 then m_bo2D0:=True
          else m_bo2D0:=False;  }
          m_nFrame:=0;
        end;
        m_dwFrameTick:=GetTickCount();
      end;
      if (not m_boDeath){20080406} then
      m_HumWinSurface:={FrmMain.WEffectImg}g_WEffectImages.GetCachedImage (m_nHumWinOffset + m_nFrame, m_nSpx, m_nSpy);
    end;
  end else if m_nFeature.nDressLook <> High(m_nFeature.nDressLook) then begin
    wm := GetEffectWil(m_nFeature.nDressLookWil);
    if wm <> nil then begin
      if m_nCurrentFrame < 64 then begin
        if (GetTickCount - m_dwFrameTick) > m_dwFrameTime then begin
          if m_nFrame < 7 then Inc(m_nFrame)
          else m_nFrame:=0;
          m_dwFrameTick:=GetTickCount();
        end;
        m_HumWinSurface := wm.GetCachedImage (m_nHumWinOffset+ (m_btDir * 8) + m_nFrame, m_nSpx, m_nSpy);
      end else begin
        m_HumWinSurface := wm.GetCachedImage (m_nHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy);
      end;
    end;
  end;
end;

function  THumActor.GetDefaultFrame (wmode: Boolean): integer;   //��̬����
var
   cf: integer;
begin
   //GlimmingMode := FALSE;
   //dr := Dress div 2;            //HUMANFRAME * (dr)
   if m_boDeath then      //����
      Result := HA.ActDie.start + m_btDir * (HA.ActDie.frame + HA.ActDie.skip) + (HA.ActDie.frame - 1)
   else
   if wmode then begin      //ս��״̬
      //GlimmingMode := TRUE;
      Result := HA.ActWarMode.start + m_btDir * (HA.ActWarMode.frame + HA.ActWarMode.skip);
   end else begin           //վ��״̬
      m_nDefFrameCount := HA.ActStand.frame;
      if m_nCurrentDefFrame < 0 then cf := 0
      else if m_nCurrentDefFrame >= HA.ActStand.frame then cf := 0 //HA.ActStand.frame-1
      else cf := m_nCurrentDefFrame;
      Result := HA.ActStand.start + m_btDir * (HA.ActStand.frame + HA.ActStand.skip) + cf;
   end;
end;

procedure  THumActor.RunFrameAction (frame: integer);
var
   meff: TMapEffect;
   event: TClEvent;
//   mfly: TFlyingAxe;
begin
   //m_boHideWeapon := FALSE; 20080803ע��
   case m_nCurrentAction of
     SM_HEAVYHIT:
        if (frame = 5) and (m_boDigFragment) then begin
           m_boDigFragment := FALSE;
           meff := TMapEffect.Create (8 * m_btDir, 3, m_nCurrX, m_nCurrY);
           meff.ImgLib := {FrmMain.WEffectImg}g_WEffectImages;
           meff.NextFrameTime := 80;
           PlaySound (s_strike_stone);
           //PlaySound (s_drop_stonepiece);
           PlayScene.m_EffectList.Add (meff);
           event := EventMan.GetEvent (m_nCurrX, m_nCurrY, ET_PILESTONES);
           if event <> nil then
              event.m_nEventParam := event.m_nEventParam + 1;
        end;
     SM_BATTERHIT4: begin //����ն
       if (frame = 3) and (m_boHit41) then begin
         m_boHit41 := False;
         frmMain.DrawEffectHum(m_nRecogId,18,0,0,0);
         MyPlaySound (cboZs3_start);
         m_boRunSound := False;
         {$IF M2Version <> 2}
         PlayScene.OpenScreenShake;
         {$IFEND}
       end;
     end;
     SM_QTWINHIT, SM_TWINHIT: begin
       if frame = 5 then begin
         {$IF M2Version <> 2}
         PlayScene.OpenScreenShake;
         {$IFEND}
       end;
     end;
     (*SM_69HIT: //����ٵ�
        if (frame = 9) {and ()} then begin
          frmMain.DrawEffectHum(m_nRecogId,20,m_nCurrX,m_nCurrY);
        end;*)
   end;
   (*if m_nCurrentAction = SM_BATTERHIT4 then begin
      if (frame = 3) and (m_boHit41) then begin
        m_boHit41 := False;
        frmMain.DrawEffectHum(m_nRecogId,18,0,0);
      end;
   end; *)
   (*//20080803ע��
   if m_nCurrentAction = SM_THROW then begin
      if (frame = 3) and (m_boThrow) then begin
         m_boThrow := FALSE;
         //�Ӹ�ͷЧ��
         mfly := TFlyingAxe (PlayScene.NewFlyObject (self,
                          m_nCurrX,
                          m_nCurrY,
                          m_nTargetX,
                          m_nTargetY,
                          m_nTargetRecog,
                          mtFlyAxe));
         if mfly <> nil then begin
            TFlyingAxe(mfly).ReadyFrame := 40;
            mfly.ImgLib := {FrmMain.WMon3Img20080720ע��}g_WMonImagesArr[2];
            mfly.FlyImageBase := FLYOMAAXEBASE;
         end;

      end;
      if frame >= 3 then
         m_boHideWeapon := TRUE;
   end;   *)
end;

procedure  THumActor.DoWeaponBreakEffect;
begin
   m_boWeaponEffect := TRUE;
   m_nCurWeaponEffect := 0;
end;

procedure  THumActor.Run;
  //�ж�ħ���Ƿ��Ѿ���ɣ����ࣺ3�룬������2�룩
   function MagicTimeOut: Boolean;
   begin
      if self = g_MySelf then begin
        if m_CurMagic.EffectNumber = 60 then   //�ƻ�ն  �������￳��ȥ�Ķ��� 20080227
         Result := GetTickCount - m_dwWaitMagicRequest > 500
        else Result := GetTickCount - m_dwWaitMagicRequest > 3000;
      end else
      if m_CurMagic.EffectNumber = 60 then begin
       Result := GetTickCount - m_dwWaitMagicRequest > 500  //�ƻ�ն  �������￳��ȥ�Ķ��� 20080227
      end else if m_CurMagic.EffectNumber in [103,107,109,110,113] then Result := GetTickCount - m_dwWaitMagicRequest > 3000  else Result := GetTickCount - m_dwWaitMagicRequest > 2000;
      if Result then m_CurMagic.ServerMagicCode := 0;
   end;
var
   prv: integer;
   m_dwFrameTimetime: longword;
   bofly: Boolean;
   nCode: Byte;
   Meff: TMagicEff;
begin
  nCode:= 0;
  try
   if GetTickCount - m_dwGenAnicountTime > 120 then begin //�ּ��Ǹ� ��... �ִϸ��̼� ȿ��
      m_dwGenAnicountTime := GetTickCount;
      Inc (m_nGenAniCount);
      if m_nGenAniCount > 100000 then m_nGenAniCount := 0;
      Inc (m_nCurBubbleStruck);
   end;
   if m_btEffect = 42 then begin //����
     if (not m_boDeath) then begin
       if (m_nCurrentFrame <= 536) then begin
         if (GetTickCount - m_dwEffFrameTick) > 1000 then begin
           if m_nEffFrame < 6 then Inc(m_nEffFrame)
           else begin
             Meff := TObjectEffects.Create(Self,g_WStateEffectImages,610,15,260,TRUE{Blendģʽ});
             Meff.ImgLib := g_WStateEffectImages;
             Meff.MagOwner:=Self;
             PlayScene.m_EffectList.Add(Meff);
             m_nEffFrame:=0;
           end;
           m_dwEffFrameTick:=GetTickCount();
         end;
       end;
     end;
   end;
   nCode:= 1;
   if m_nCurrentAction = SM_BATTERHIT4 then begin
     if m_Hit4Meff <> nil then begin
       nCode:= 2;
       if (m_Hit4Meff.curframe = 4) and (m_boHit4) then begin
          nCode:= 3;
          m_boHit4 := False;
          m_boHit41 := True;
          m_dwFrameTime := HA.ActCboSpell12.ftime;
          m_dwStartTime := GetTickCount;
          m_nStartFrame := HA.ActCboSpell12.start + m_btDir * (HA.ActCboSpell12.frame + HA.ActCboSpell12.skip);
          m_nEndFrame := m_nStartFrame + HA.ActCboSpell12.frame - 1;
          m_boWarMode := TRUE;
          m_dwWarModeTime := GetTickCount;
          m_boCboMode := True;
          m_boHitEffect := True;
          m_nMagLight := 2;
          m_nHitEffectNumber := 16;
          nCode:= 4;
          Shift (m_btDir, 0, 0, 1);
       end;
     end;
   end;
   nCode:= 5;
   if m_boWeaponEffect then begin  //����Ч����ÿ120��仯һ֡����5֡
      if GetTickCount - m_dwWeaponpEffectTime > 120 then begin
         m_dwWeaponpEffectTime := GetTickCount;
         Inc (m_nCurWeaponEffect);
         if m_nCurWeaponEffect >= MAXWPEFFECTFRAME then m_boWeaponEffect := FALSE;
      end;
   end;
   nCode:= 6;
   if (m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_NPCWALK) or
      (m_nCurrentAction = SM_BACKSTEP) or
      (m_nCurrentAction = SM_RUN) or
      //(m_nCurrentAction = SM_HORSERUN) or 20080803ע��������Ϣ
      (m_nCurrentAction = SM_RUSH) or
      (m_nCurrentAction = SM_RUSHKUNG)
   then Exit;
   m_boMsgMuch := FALSE;
   nCode:= 7;
   if (self <> g_MySelf) and (m_MsgList <> nil) then begin
     nCode := 26;
      if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
   end;
   nCode:= 8;
   //������Ч
   RunActSound (m_nCurrentFrame - m_nStartFrame);
   nCode:= 9;
   RunFrameAction (m_nCurrentFrame - m_nStartFrame);
   nCode:= 10;
   prv := m_nCurrentFrame;
   if m_nCurrentAction <> 0 then begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
         m_nCurrentFrame := m_nStartFrame;
      if (self <> g_MySelf) and (m_boUseMagic) then begin
         m_dwFrameTimetime := Round(m_dwFrameTime / 1.8);
      end else begin
         if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
         else m_dwFrameTimetime := m_dwFrameTime;
      end;
      nCode:= 11;
      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
         if m_nCurrentFrame < m_nEndFrame then begin
            if m_boUseMagic then begin
               if (m_nCurEffFrame = m_nSpellFrame-2) or (MagicTimeOut) then begin //ħ��ִ����
                  if (m_CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then begin //������ ���� ���� ���. ���� �ȿ����� ��ٸ�
                     Inc (m_nCurrentFrame);
                     Inc (m_nCurEffFrame);
                     m_dwStartTime := GetTickCount;
                  end;
               end else begin
                  if m_nCurrentFrame < m_nEndFrame - 1 then Inc (m_nCurrentFrame);
                  Inc (m_nCurEffFrame);
                  m_dwStartTime := GetTickCount;
               end;
            end else begin   //������ ���з�ӳ
               Inc (m_nCurrentFrame);
               m_dwStartTime := GetTickCount;
            end;
         end else begin
            if Self = g_MySelf then begin
               if FrmMain.ServerAcceptNextAction then begin //�������ﱾ�� ���������ؽ�� ���ͷ�
                  m_nCurrentAction := 0;   //�������
                  m_boUseMagic := FALSE;   //ħ��Ϊ��
               end;
            end else begin     //��������
               m_nCurrentAction := 0;  //����Ϊ��
               m_boUseMagic := FALSE;
            end;
            m_boHitEffect := FALSE;
         end;
         nCode:= 12;
         if m_boHitEffect and ((m_nHitEffectNumber = 7) or (m_nHitEffectNumber = 8) or (m_nHitEffectNumber = 10) or (m_nHitEffectNumber = 12){ or (m_nHitEffectNumber = 16)}) then begin//ħ������Ч��  20080202
             if m_nCurrentFrame = m_nEndFrame - 1 then begin
                case m_nHitEffectNumber of
                    8: FrmMain.ShowMyShow(Self,1); //��Ӱ����  ��9������Ч�� 20080202
                      //MyShow.Create(m_nCurrX,m_nCurrY,1,80,9,m_btDir,g_WMagic2Images);
                    //7: FrmMain.ShowMyShow(Self,2); //����ն�ػ����Ч��
                   //10: FrmMain.ShowMyShow(Self,3); //����ն������Ч��
                   12: FrmMain.ShowMyShow(Self,6);//����һ��սʿЧ��
                end;
             end;
         end;
         nCode:= 13;
         if m_boUseMagic then begin
           if m_CurMagic.EffectNumber <> 110 then begin
              if m_nCurEffFrame = m_nSpellFrame - 1 then begin //ħ������ �ȷ�����ħ�� ��-1ͼ
                 //���� �߻�
                 if m_CurMagic.ServerMagicCode > 0 then begin
                   nCode:= 14;
                    with m_CurMagic do
                       PlayScene.NewMagic (self, ServerMagicCode, EffectNumber,
                                        m_nCurrX, m_nCurrY, TargX, TargY, Target,
                                        EffectType, Recusion, AniTime, EffectLevelEx, bofly);
                    nCode:= 15;
                    if bofly then
                      case m_CurMagic.MagicSerial of
                        46: MyPlaySound ('wav\splitshadow.wav'); //������
                        77: MyPlaySound ('wav\cboFs1_target.wav'); //˫����
                        78: MyPlaySound ('wav\cboDs1_target.wav'); //��Х��
                        80: MyPlaySound ('wav\cboFs2_target.wav'); //�����
                        81: MyPlaySound ('wav\cboDs2_target.wav'); //������
                        83: MyPlaySound ('wav\cboFs3_target.wav'); //���ױ�
                        84: MyPlaySound ('wav\cboDs3_target.wav'); //������
                        87: MyPlaySound ('wav\cboDs4_target.wav'); //�򽣹���
                        else PlaySound (m_nMagicFireSound);
                      end
                    else begin
                      nCode:= 16;
                      case m_CurMagic.MagicSerial of
                        58, 70, 92, 108: MyPlaySound ('wav\M58-3.wav'); //����������� 20080511
                        84: MyPlaySound ('wav\cboDs3_target.wav'); //������
                        69: begin
                          PlaySound (m_nWeaponSound);
                          if m_btSex = 0 then MyPlaySound (cboZs3_start_m)
                          else MyPlaySound (cboZs3_start_w); //Ů
                          m_boRunSound := False;
                        end;
                        else PlaySound (m_nMagicExplosionSound);
                      end;
                    end;
                 end;
                 nCode:= 17;
                 if self = g_MySelf then g_dwLatestSpellTick := GetTickCount;
                 m_CurMagic.ServerMagicCode := 0;
              end;
           end else begin //������
              nCode:= 18;
              if (m_nCurEffFrame = m_nSpellFrame-2) or (m_nCurEffFrame = m_nSpellFrame-4) or (m_nCurEffFrame = m_nSpellFrame-6)  then begin //ħ������ �ȷ�����ħ�� ��-1ͼ
                 //���� �߻�
                 if m_CurMagic.ServerMagicCode > 0 then begin
                   nCode:= 19;
                    with m_CurMagic do
                       PlayScene.NewMagic (self,
                                        ServerMagicCode,
                                        EffectNumber,
                                        m_nCurrX,
                                        m_nCurrY,
                                        TargX,
                                        TargY,
                                        Target,
                                        EffectType,
                                        Recusion,
                                        AniTime,
                                        EffectLevelEx,
                                        bofly);
                 nCode:= 20;
                 if self = g_MySelf then g_dwLatestSpellTick := GetTickCount;
                 if m_nCurEffFrame = m_nSpellFrame-2 then m_CurMagic.ServerMagicCode := 0;
                end;
              end;
           end;
         end;

      end;
      nCode:= 21;
      if (m_btRace = 0) or (m_btRace = 1) or (m_btRace = 150) then m_nCurrentDefFrame := 0 //����,Ӣ��,����20080629
      else m_nCurrentDefFrame := -10;
      m_dwDefFrameTime := GetTickCount;
   end else begin
     nCode:= 22;
      if GetTickCount - m_dwSmoothMoveTime > 200 then begin
         if GetTickCount - m_dwDefFrameTime > 500 then begin
            m_dwDefFrameTime := GetTickCount;
            Inc (m_nCurrentDefFrame);
            if m_nCurrentDefFrame >= m_nDefFrameCount then begin
              m_nCurrentDefFrame := 0;
            end;
         end;
         nCode:= 23;
         DefaultMotion;
      end;
   end;
   nCode:= 24;
   if prv <> m_nCurrentFrame then begin
      m_dwLoadSurfaceTime := GetTickCount;
      nCode:= 25;
      LoadSurface;
   end;
  except
    DebugOutStr('THumActor.Run Code:'+inttostr(nCode));
  end;
end;

function   THumActor.Light: integer;
var
   l: integer;
begin
   l := m_nChrLight;
   if l < m_nMagLight then begin
      if m_boUseMagic or m_boHitEffect then
         l := m_nMagLight;
   end;
   Result := l;
end;

procedure  THumActor.LoadSurface;

  procedure GetNJXY(index: integer; var x, y: Integer);
  begin
    case index of
      0: begin X:=28; Y:=-29 end;        1: begin X:=29; Y:=-31 end;
      2: begin X:=29; Y:=-33 end;        3: begin X:=29; Y:=-31 end;
      8: begin X:=29; Y:=-18 end;        9: begin X:=30; Y:=-19 end;
      10: begin X:=31; Y:=-19 end;      11: begin X:=31; Y:=-19 end;
      16: begin X:=19; Y:=-13 end;      17: begin X:=20; Y:=-12 end;
      18: begin X:=21; Y:=-13 end;      19: begin X:=21; Y:=-12 end;
      24: begin X:=9; Y:=-11 end;       25: begin X:=10; Y:=-10 end;
      26: begin X:=11; Y:=-10 end;      27: begin X:=11; Y:=-10 end;
      32: begin X:=-6; Y:=-16 end;      33: begin X:=-4; Y:=-16 end;
      34: begin X:=-4; Y:=-16 end;      35: begin X:=-5; Y:=-16 end;
      40: begin X:=-30; Y:=-26 end;     41: begin X:=-30; Y:=-25 end;
      42: begin X:=-31; Y:=-25 end;     43: begin X:=-30; Y:=-25 end;
      48: begin X:=-25; Y:=-30 end;     49: begin X:=-27; Y:=-30 end;
      50: begin X:=-28; Y:=-30 end;     51: begin X:=-27; Y:=-30 end;
      56: begin X:=1; Y:=-32 end;       57: begin X:=-1; Y:=-34 end;
      58: begin X:=-1; Y:=-36 end;      59: begin X:=-1; Y:=-34 end;
      64: begin X:=29; Y:=-31 end;      65: begin X:=29; Y:=-44 end;
      66: begin X:=27; Y:=-56 end;      67: begin X:=25; Y:=-64 end;
      68: begin X:=27; Y:=-48 end;      69: begin X:=30; Y:=-35 end;
      72: begin X:=27; Y:=-16 end;      73: begin X:=30; Y:=-27 end;
      74: begin X:=34; Y:=-40 end;      75: begin X:=37; Y:=-49 end;
      76: begin X:=33; Y:=-32 end;      77: begin X:=29; Y:=-18 end;
      80: begin X:=15; Y:=-12 end;      81: begin X:=20; Y:=-14 end;
      82: begin X:=27; Y:=-17 end;      83: begin X:=32; Y:=-20 end;
      84: begin X:=26; Y:=-16 end;      85: begin X:=19; Y:=-12 end;
      88: begin X:=6; Y:=-13 end;       89: begin X:=9; Y:=-13 end;
      90: begin X:=15; Y:=-12 end;      91: begin X:=20; Y:=-11 end;
      92: begin X:=15; Y:=-11 end;      93: begin X:=8; Y:=-11 end;
      96: begin X:=-14; Y:=-20 end;     97: begin X:=-10; Y:=-18 end;
      98: begin X:=-2; Y:=-15 end;      99: begin X:=2; Y:=-12 end;
      100: begin X:=-3; Y:=-14 end;    101: begin X:=-13; Y:=-17 end;
      104: begin X:=-34; Y:=-29 end;   105: begin X:=-38; Y:=-28 end;
      106: begin X:=-38; Y:=-25 end;   107: begin X:=-38; Y:=-23 end;
      108: begin X:=-36; Y:=-24 end;   109: begin X:=-35; Y:=-27 end;
      112: begin X:=-21; Y:=-32 end;   113: begin X:=-31; Y:=-34 end;
      114: begin X:=-41; Y:=-34 end;   115: begin X:=-45; Y:=-35 end;
      116: begin X:=-37; Y:=-31 end;   117: begin X:=-26; Y:=-31 end;
      120: begin X:=10; Y:=-38 end;    122: begin X:=-13; Y:=-54 end;
      123: begin X:=-19; Y:=-60 end;   124: begin X:=-9; Y:=-48 end;
      125: begin X:=5; Y:=-40 end;     128: begin X:=34; Y:=-52 end;
      129: begin X:=28; Y:=-73 end;    130: begin X:=13; Y:=-99 end;
      131: begin X:=10; Y:=-92 end;    132: begin X:=20; Y:=-91 end;
      133: begin X:=27; Y:=-67 end;    136: begin X:=32; Y:=-29 end;
      137: begin X:=36; Y:=-57 end;    138: begin X:=39; Y:=-91 end;
      139: begin X:=31; Y:=-91 end;    140: begin X:=40; Y:=-80 end;
      141: begin X:=33; Y:=-50 end;    144: begin X:=17; Y:=-15 end;
      145: begin X:=27; Y:=-29 end;    146: begin X:=38; Y:=-69 end;
      147: begin X:=35; Y:=-82 end;    148: begin X:=38; Y:=-53 end;
      149: begin X:=26; Y:=-23 end;    152: begin X:=4; Y:=-15 end;
      153: begin X:=14; Y:=-17 end;    154: begin X:=26; Y:=-44 end;
      155: begin X:=27; Y:=-68 end;    156: begin X:=26; Y:=-27 end;
      157: begin X:=14; Y:=-17 end;    160: begin X:=-19; Y:=-23 end;
      161: begin X:=-1; Y:=-20 end;    162: begin X:=7; Y:=-34 end;
      163: begin X:=11; Y:=-60 end;    164: begin X:=6; Y:=-20 end;
      165: begin X:=-3; Y:=-20 end;    168: begin X:=-41; Y:=-34 end;
      169: begin X:=-36; Y:=-31 end;   170: begin X:=-20; Y:=-45 end;
      171: begin X:=-3; Y:=-62 end;    172: begin X:=-29; Y:=-33 end;
      173: begin X:=-36; Y:=-31 end;   176: begin X:=-27; Y:=-46 end;
      177: begin X:=-40; Y:=-48 end;   178: begin X:=-33; Y:=-66 end;
      179: begin X:=-9; Y:=-74 end;    180: begin X:=-40; Y:=-58 end;
      181: begin X:=-38; Y:=-44 end;   184: begin X:=9; Y:=-59 end;
      185: begin X:=-14; Y:=-70 end;   186: begin X:=-21; Y:=-90 end;
      187: begin X:=-6; Y:=-86 end;    188: begin X:=-22; Y:=-85 end;
      189: begin X:=-10; Y:=-66 end;   192: begin X:=46; Y:=-49 end;
      193: begin X:=40; Y:=-26 end;    194: begin X:=2; Y:=-22 end;
      195: begin X:=-36; Y:=-40 end;   196: begin X:=-44; Y:=-71 end;
      197: begin X:=-17; Y:=-97 end;   198: begin X:=16; Y:=-100 end;
      199: begin X:=38; Y:=-80 end;    200: begin X:=46; Y:=-71 end;
      201: begin X:=-38; Y:=-13 end;   202: begin X:=8; Y:=-46 end;
      203: begin X:=42; Y:=-85 end;    204: begin X:=-13; Y:=-38 end;
      205: begin X:=22; Y:=-44 end;    208: begin X:=39; Y:=-47 end;
      209: begin X:=-69; Y:=-39 end;   210: begin X:=-27; Y:=-46 end;
      211: begin X:=58; Y:=-57 end;    212: begin X:=38; Y:=-35 end;
      213: begin X:=43; Y:=-29 end;    216: begin X:=17; Y:=-33 end;
      217: begin X:=-53; Y:=-80 end;   218: begin X:=-40; Y:=-59 end;
      219: begin X:=32; Y:=-40 end;    220: begin X:=53; Y:=-15 end;
      221: begin X:=41; Y:=-7 end;     224: begin X:=-15; Y:=-39 end;
      225: begin X:=-5; Y:=-102 end;   226: begin X:=-18; Y:=-81 end;
      227: begin X:=-11; Y:=-41 end;   228: begin X:=50; Y:=6 end;
      229: begin X:=27; Y:=4 end;      232: begin X:=-38; Y:=-63 end;
      233: begin X:=29; Y:=-92 end;    234: begin X:=5; Y:=-89 end;
      235: begin X:=-39; Y:=-64 end;   236: begin X:=24; Y:=17 end;
      237: begin X:=4; Y:=4 end;       240: begin X:=-28; Y:=-91 end;
      241: begin X:=56; Y:=-60 end;    242: begin X:=16; Y:=-78 end;
      243: begin X:=-35; Y:=-95 end;   244: begin X:=-16; Y:=12 end;
      245: begin X:=-38; Y:=-9 end;    248: begin X:=9; Y:=-103 end;
      249: begin X:=60; Y:=-34 end;    250: begin X:=30; Y:=-63 end;
      251: begin X:=-14; Y:=-113 end;  252: begin X:=-53; Y:=-3 end;
      253: begin X:=-49; Y:=-22 end;   256: begin X:=36; Y:=-95 end;
      257: begin X:=27; Y:=-15 end;    258: begin X:=32; Y:=-53 end;
      259: begin X:=13; Y:=-109 end;   260: begin X:=-53; Y:=-23 end;
      261: begin X:=-26; Y:=-38 end;   264: begin X:=43; Y:=-41 end;
      265: begin X:=-16; Y:=-19 end;   266: begin X:=31; Y:=-73 end;
      267: begin X:=3; Y:=-42 end;     268: begin X:=1; Y:=-47 end;
      269: begin X:=31; Y:=-68 end;    272: begin X:=38; Y:=-27 end;
      273: begin X:=-47; Y:=-30 end;   274: begin X:=42; Y:=-54 end;
      275: begin X:=33; Y:=-34 end;    276: begin X:=28; Y:=-39 end;
      277: begin X:=45; Y:=-39 end;    280: begin X:=-9; Y:=-19 end;
      281: begin X:=-44; Y:=-46 end;   282: begin X:=10; Y:=-50 end;
      283: begin X:=51; Y:=-18 end;    284: begin X:=43; Y:=-26 end;
      285: begin X:=38; Y:=-23 end;    288: begin X:=-47; Y:=-29 end;
      289: begin X:=-4; Y:=-64 end;    290: begin X:=-16; Y:=-59 end;
      291: begin X:=50; Y:=3 end;      292: begin X:=45; Y:=-9 end;
      293: begin X:=1; Y:=-14 end;     296: begin X:=-49; Y:=-64 end;
      297: begin X:=25; Y:=-60 end;    298: begin X:=-25; Y:=-79 end;
      299: begin X:=19; Y:=13 end;     300: begin X:=21; Y:=1 end;
      301: begin X:=-43; Y:=-23 end;   304: begin X:=-13; Y:=-91 end;
      305: begin X:=39; Y:=-43 end;    306: begin X:=-11; Y:=-100 end;
      307: begin X:=-36; Y:=10 end;    309: begin X:=-51; Y:=-57 end;
      312: begin X:=15; Y:=-90 end;    313: begin X:=42; Y:=-27 end;
      314: begin X:=-2; Y:=-104 end;   315: begin X:=-58; Y:=-3 end;
      316: begin X:=-52; Y:=-10 end;   317: begin X:=-18; Y:=-84 end;
      320: begin X:=36; Y:=-66 end;    321: begin X:=26; Y:=-18 end;
      322: begin X:=13; Y:=-93 end;    323: begin X:=-41; Y:=-28 end;
      324: begin X:=-38; Y:=-33 end;   325: begin X:=10; Y:=-89 end;
      328: begin X:=45; Y:=-53 end;    329: begin X:=-28; Y:=-19 end;
      330: begin X:=-51; Y:=-56 end;   331: begin X:=-30; Y:=-44 end;
      332: begin X:=44; Y:=-36 end;    333: begin X:=25; Y:=-72 end;
      334: begin X:=-58; Y:=-44 end;   335: begin X:=21; Y:=-75 end;
      336: begin X:=28; Y:=-32 end;    337: begin X:=-56; Y:=-49 end;
      338: begin X:=-43; Y:=-86 end;   339: begin X:=-51; Y:=-65 end;
      340: begin X:=15; Y:=-24 end;    341: begin X:=55; Y:=-41 end;
      342: begin X:=-29; Y:=-78 end;   343: begin X:=46; Y:=-47 end;
      344: begin X:=-2; Y:=-27 end;    345: begin X:=-44; Y:=-85 end;
      346: begin X:=-5; Y:=-106 end;   347: begin X:=-35; Y:=-97 end;
      348: begin X:=-33; Y:=-23 end;   349: begin X:=57; Y:=-10 end;
      350: begin X:=18; Y:=-91 end;    351: begin X:=50; Y:=-22 end;
      352: begin X:=-34; Y:=-47 end;   353: begin X:=-3; Y:=-103 end;
      354: begin X:=17; Y:=-102 end;   355: begin X:=1; Y:=-111 end;
      356: begin X:=-51; Y:=-53 end;   357: begin X:=36; Y:=8 end;
      358: begin X:=41; Y:=-73 end;    359: begin X:=35; Y:=-5 end;
      360: begin X:=-40; Y:=-77 end;   361: begin X:=25; Y:=-95 end;
      362: begin X:=34; Y:=-79 end;    363: begin X:=21; Y:=-101 end;
      364: begin X:=-33; Y:=-86 end;   365: begin X:=-20; Y:=10 end;
      366: begin X:=47; Y:=-38 end;    367: begin X:=-17; Y:=-2 end;
      368: begin X:=-12; Y:=-100 end;  369: begin X:=47; Y:=-65 end;
      370: begin X:=40; Y:=-66 end;    371: begin X:=38; Y:=-75 end;
      372: begin X:=-2; Y:=-99 end;    373: begin X:=-68; Y:=-6 end;
      374: begin X:=34; Y:=-14 end;    375: begin X:=-60; Y:=-15 end;
      376: begin X:=32; Y:=-101 end;   377: begin X:=54; Y:=-35 end;
      378: begin X:=34; Y:=-53 end;    379: begin X:=44; Y:=-58 end;
      380: begin X:=26; Y:=-84 end;    381: begin X:=-64; Y:=-42 end;
      382: begin X:=10; Y:=-7 end;     383: begin X:=-55; Y:=-48 end;
      384: begin X:=49; Y:=-82 end;    385: begin X:=28; Y:=-19 end;
      386: begin X:=-16; Y:=-50 end;   387: begin X:=20; Y:=-45 end;
      388: begin X:=44; Y:=-55 end;    389: begin X:=-18; Y:=-73 end;
      390: begin X:=-39; Y:=-16 end;   391: begin X:=-14; Y:=-76 end;
      392: begin X:=32; Y:=-87 end;    393: begin X:=3; Y:=-98 end;
      394: begin X:=-9; Y:=-79 end;    395: begin X:=-1; Y:=-61 end;
      396: begin X:=19; Y:=-95 end;    397: begin X:=26; Y:=-83 end;
      400: begin X:=43; Y:=-63 end;    401: begin X:=25; Y:=-99 end;
      402: begin X:=-5; Y:=-95 end;    403: begin X:=-20; Y:=-75 end;
      404: begin X:=18; Y:=-95 end;    405: begin X:=49; Y:=-60 end;
      408: begin X:=35; Y:=-36 end;    409: begin X:=30; Y:=-87 end;
      410: begin X:=9; Y:=-103 end;    411: begin X:=-21; Y:=-95 end;
      412: begin X:=12; Y:=-95 end;    413: begin X:=51; Y:=-26 end;
      416: begin X:=18; Y:=-21 end;    417: begin X:=29; Y:=-69 end;
      418: begin X:=24; Y:=-98 end;    419: begin X:=1; Y:=-107 end;
      420: begin X:=9; Y:=-94 end;     421: begin X:=34; Y:=-10 end;
      424: begin X:=-21; Y:=-31 end;   425: begin X:=18; Y:=-59 end;
      426: begin X:=19; Y:=-87 end;    427: begin X:=10; Y:=-108 end;
      428: begin X:=1; Y:=-99 end;     429: begin X:=-5; Y:=-9 end;
      432: begin X:=-43; Y:=-58 end;   433: begin X:=2; Y:=-59 end;
      434: begin X:=12; Y:=-73 end;    435: begin X:=15; Y:=-94 end;
      437: begin X:=-56; Y:=-24 end;   440: begin X:=-27; Y:=-84 end;
      441: begin X:=-13; Y:=-72 end;   442: begin X:=8; Y:=-66 end;
      443: begin X:=23; Y:=-74 end;    444: begin X:=11; Y:=-101 end;
      445: begin X:=-63; Y:=-48 end;   448: begin X:=9; Y:=-98 end;
      449: begin X:=-14; Y:=-88 end;   451: begin X:=23; Y:=-63 end;
      452: begin X:=20; Y:=-98 end;    453: begin X:=-25; Y:=-79 end;
      456: begin X:=26; Y:=-25 end;    457: begin X:=17; Y:=-32 end;
      458: begin X:=35; Y:=-16 end;    459: begin X:=43; Y:=-22 end;
      460: begin X:=30; Y:=-5 end;     461: begin X:=46; Y:=-1 end;
      462: begin X:=19; Y:=2 end;      463: begin X:=34; Y:=15 end;
      464: begin X:=-1; Y:=-1 end;     465: begin X:=8; Y:=18 end;
      466: begin X:=-34; Y:=-11 end;   467: begin X:=-38; Y:=8 end;
      468: begin X:=-36; Y:=-20 end;   469: begin X:=-55; Y:=-8 end;
      470: begin X:=-11; Y:=-26 end;   471: begin X:=-33; Y:=-24 end;
      472: begin X:=43; Y:=-14 end;    473: begin X:=42; Y:=-30 end;
      474: begin X:=41; Y:=-44 end;    481: begin X:=33; Y:=-8 end;
      482: begin X:=39; Y:=-15 end;    489: begin X:=12; Y:=-4 end;
      490: begin X:=20; Y:=-7 end;     496: begin X:=-44; Y:=-15 end;
      497: begin X:=-24; Y:=-10 end;   498: begin X:=-9; Y:=-9 end;
      504: begin X:=-58; Y:=-34 end;   505: begin X:=-54; Y:=-25 end;
      506: begin X:=-50; Y:=-22 end;   512: begin X:=-27; Y:=-65 end;
      513: begin X:=-43; Y:=-51 end;   514: begin X:=-53; Y:=-44 end;
      520: begin X:=30; Y:=-70 end;    521: begin X:=6; Y:=-68 end;
      522: begin X:=-12; Y:=-68 end;   528: begin X:=47; Y:=-49 end;
      529: begin X:=38; Y:=-60 end;    530: begin X:=31; Y:=-68 end;
      536: begin X:=9; Y:=-80 end;     537: begin X:=-14; Y:=-51 end;
      538: begin X:=-17; Y:=27 end;    539: begin X:=10; Y:=47 end;
      544: begin X:=48; Y:=-73 end;    545: begin X:=-20; Y:=-66 end;
      546: begin X:=-45; Y:=16 end;    547: begin X:=-47; Y:=47 end;
      552: begin X:=39; Y:=-46 end;    553: begin X:=-8; Y:=-83 end;
      554: begin X:=-42; Y:=-16 end;   555: begin X:=-70; Y:=16 end;
      560: begin X:=17; Y:=-16 end;    561: begin X:=17; Y:=-87 end;
      562: begin X:=-24; Y:=-37 end;   563: begin X:=-44; Y:=-21 end;
      568: begin X:=-8; Y:=-18 end;    569: begin X:=16; Y:=-77 end;
      570: begin X:=5; Y:=-38 end;     571: begin X:=-10; Y:=-36 end;
      576: begin X:=-26; Y:=-33 end;   577: begin X:=12; Y:=-59 end;
      578: begin X:=40; Y:=-33 end;    579: begin X:=36; Y:=-27 end;
      584: begin X:=-42; Y:=-48 end;   585: begin X:=13; Y:=-46 end;
      586: begin X:=62; Y:=-12 end;    587: begin X:=72; Y:=-6 end;
      592: begin X:=-30; Y:=-66 end;   593: begin X:=8; Y:=-49 end;
      594: begin X:=34; Y:=12 end;     595: begin X:=70; Y:=24 end;
      600: begin X:=29; Y:=-36 end;    601: begin X:=30; Y:=-38 end;
      602: begin X:=30; Y:=-39 end;    603: begin X:=30; Y:=-38 end;
      608: begin X:=27; Y:=-20 end;    609: begin X:=29; Y:=-23 end;
      610: begin X:=29; Y:=-23 end;    611: begin X:=28; Y:=-22 end;
      616: begin X:=18; Y:=-13 end;    617: begin X:=19; Y:=-13 end;
      618: begin X:=20; Y:=-13 end;    619: begin X:=19; Y:=-13 end;
      624: begin X:=7; Y:=-14 end;     625: begin X:=9; Y:=-13 end;
      626: begin X:=9; Y:=-13 end;     627: begin X:=9; Y:=-13 end;
      632: begin X:=-4; Y:=-18 end;    633: begin X:=-3; Y:=-17 end;
      634: begin X:=-3; Y:=-17 end;    635: begin X:=-4; Y:=-17 end;
      640: begin X:=-29; Y:=-26 end;   641: begin X:=-29; Y:=-25 end;
      642: begin X:=-29; Y:=-25 end;   643: begin X:=-28; Y:=-24 end;
      648: begin X:=-27; Y:=-30 end;   649: begin X:=-27; Y:=-31 end;
      650: begin X:=-27; Y:=-31 end;   651: begin X:=-28; Y:=-30 end;
      656: begin X:=2; Y:=-37 end;     657: begin X:=1; Y:=-39 end;
      664: begin X:=26; Y:=-29 end;    665: begin X:=27; Y:=-37 end;
      666: begin X:=27; Y:=-48 end;    667: begin X:=27; Y:=-65 end;
      668: begin X:=27; Y:=-53 end;    669: begin X:=27; Y:=-42 end;
      672: begin X:=20; Y:=-14 end;    673: begin X:=23; Y:=-18 end;
      674: begin X:=27; Y:=-30 end;    675: begin X:=32; Y:=-46 end;
      676: begin X:=28; Y:=-35 end;    677: begin X:=25; Y:=-21 end;
      680: begin X:=11; Y:=-13 end;    681: begin X:=15; Y:=-14 end;
      682: begin X:=21; Y:=-16 end;    683: begin X:=26; Y:=-19 end;
      684: begin X:=22; Y:=-17 end;    685: begin X:=17; Y:=-14 end;
      688: begin X:=5; Y:=-16 end;     689: begin X:=7; Y:=-15 end;
      690: begin X:=12; Y:=-15 end;    691: begin X:=17; Y:=-14 end;
      692: begin X:=13; Y:=-15 end;    693: begin X:=8; Y:=-14 end;
      696: begin X:=-14; Y:=-22 end;   697: begin X:=-13; Y:=-20 end;
      698: begin X:=-7; Y:=-18 end;    699: begin X:=-3; Y:=-15 end;
      700: begin X:=-4; Y:=-17 end;    701: begin X:=-13; Y:=-19 end;
      704: begin X:=-29; Y:=-27 end;   705: begin X:=-31; Y:=-27 end;
      706: begin X:=-34; Y:=-25 end;   707: begin X:=-35; Y:=-24 end;
      708: begin X:=-33; Y:=-25 end;   709: begin X:=-34; Y:=-26 end;
      712: begin X:=-16; Y:=-29 end;   713: begin X:=-21; Y:=-32 end;
      714: begin X:=-31; Y:=-35 end;   715: begin X:=-37; Y:=-43 end;
      716: begin X:=-32; Y:=-37 end;   717: begin X:=-24; Y:=-36 end;
      720: begin X:=17; Y:=-35 end;    721: begin X:=12; Y:=-42 end;
      722: begin X:=1; Y:=-50 end;     723: begin X:=-7; Y:=-64 end;
      725: begin X:=11; Y:=-46 end;    728: begin X:=33; Y:=-55 end;
      729: begin X:=30; Y:=-75 end;    730: begin X:=19; Y:=-92 end;
      731: begin X:=16; Y:=-81 end;    732: begin X:=23; Y:=-87 end;
      733: begin X:=29; Y:=-69 end;    736: begin X:=27; Y:=-31 end;
      737: begin X:=32; Y:=-56 end;    738: begin X:=36; Y:=-85 end;
      739: begin X:=27; Y:=-80 end;    740: begin X:=37; Y:=-77 end;
      741: begin X:=31; Y:=-53 end;    744: begin X:=13; Y:=-16 end;
      745: begin X:=23; Y:=-30 end;    746: begin X:=36; Y:=-66 end;
      747: begin X:=30; Y:=-74 end;    748: begin X:=35; Y:=-54 end;
      749: begin X:=22; Y:=-27 end;    752: begin X:=1; Y:=-19 end;
      753: begin X:=10; Y:=-20 end;    754: begin X:=23; Y:=-48 end;
      755: begin X:=23; Y:=-68 end;    756: begin X:=22; Y:=-32 end;
      757: begin X:=12; Y:=-20 end;    760: begin X:=-18; Y:=-26 end;
      761: begin X:=-2; Y:=-22 end;    762: begin X:=7; Y:=-40 end;
      763: begin X:=10; Y:=-61 end;    764: begin X:=7; Y:=-23 end;
      765: begin X:=-1; Y:=-22 end;    768: begin X:=-36; Y:=-35 end;
      769: begin X:=-32; Y:=-33 end;   770: begin X:=-14; Y:=-50 end;
      771: begin X:=-1; Y:=-65 end;    772: begin X:=-21; Y:=-38 end;
      773: begin X:=-31; Y:=-32 end;   776: begin X:=-22; Y:=-52 end;
      777: begin X:=-32; Y:=-54 end;   778: begin X:=-23; Y:=-70 end;
      779: begin X:=-3; Y:=-73 end;    780: begin X:=-30; Y:=-62 end;
      781: begin X:=-32; Y:=-49 end;   784: begin X:=16; Y:=-61 end;
      785: begin X:=-3; Y:=-72 end;    786: begin X:=-8; Y:=-86 end;
      787: begin X:=5; Y:=-80 end;     788: begin X:=-11; Y:=-82 end;
      789: begin X:=-4; Y:=-67 end;    792: begin X:=43; Y:=-53 end;
      793: begin X:=33; Y:=-25 end;    794: begin X:=13; Y:=-12 end;
      795: begin X:=-24; Y:=-24 end;   796: begin X:=-42; Y:=-50 end;
      797: begin X:=-25; Y:=-77 end;   798: begin X:=15; Y:=-88 end;
      799: begin X:=39; Y:=-79 end;    800: begin X:=39; Y:=-72 end;
      801: begin X:=-17; Y:=-17 end;   802: begin X:=10; Y:=-42 end;
      803: begin X:=35; Y:=-70 end;    804: begin X:=-23; Y:=-42 end;
      805: begin X:=25; Y:=-57 end;    808: begin X:=35; Y:=-54 end;
      809: begin X:=-51; Y:=-29 end;   810: begin X:=-23; Y:=-43 end;
      811: begin X:=52; Y:=-52 end;    812: begin X:=31; Y:=-44 end;
      813: begin X:=46; Y:=-35 end;    816: begin X:=19; Y:=-42 end;
      817: begin X:=-44; Y:=-48 end;   818: begin X:=-33; Y:=-50 end;
      819: begin X:=26; Y:=-32 end;    820: begin X:=53; Y:=-20 end;
      821: begin X:=50; Y:=-10 end;    824: begin X:=-5; Y:=-46 end;
      825: begin X:=-4; Y:=-66 end;    826: begin X:=-13; Y:=-61 end;
      827: begin X:=-10; Y:=-37 end;   828: begin X:=56; Y:=2 end;
      829: begin X:=35; Y:=5 end;      832: begin X:=-21; Y:=-63 end;
      833: begin X:=23; Y:=-67 end;    834: begin X:=11; Y:=-66 end;
      835: begin X:=-28; Y:=-57 end;   836: begin X:=35; Y:=18 end;
      837: begin X:=-2; Y:=8 end;      840: begin X:=-16; Y:=-82 end;
      841: begin X:=46; Y:=-56 end;    842: begin X:=22; Y:=-62 end;
      843: begin X:=-24; Y:=-80 end;   844: begin X:=-8; Y:=18 end;
      845: begin X:=-51; Y:=-5 end;    848: begin X:=9; Y:=-92 end;
      849: begin X:=51; Y:=-37 end;    850: begin X:=29; Y:=-55 end;
      851: begin X:=-18; Y:=-92 end;   852: begin X:=-55; Y:=4 end;
      853: begin X:=-58; Y:=-24 end;   856: begin X:=31; Y:=-86 end;
      857: begin X:=35; Y:=-21 end;    858: begin X:=29; Y:=-47 end;
      859: begin X:=6; Y:=-85 end;     860: begin X:=-60; Y:=-18 end;
      861: begin X:=-22; Y:=-52 end;   864: begin X:=38; Y:=-42 end;
      865: begin X:=18; Y:=-19 end;    866: begin X:=24; Y:=-66 end;
      867: begin X:=-7; Y:=-45 end;    868: begin X:=-2; Y:=-47 end;
      869: begin X:=26; Y:=-63 end;    872: begin X:=30; Y:=-28 end;
      873: begin X:=-21; Y:=-23 end;   874: begin X:=36; Y:=-55 end;
      875: begin X:=21; Y:=-42 end;    876: begin X:=20; Y:=-42 end;
      877: begin X:=40; Y:=-38 end;    880: begin X:=-10; Y:=-22 end;
      881: begin X:=-41; Y:=-32 end;   882: begin X:=10; Y:=-45 end;
      883: begin X:=45; Y:=-25 end;    884: begin X:=38; Y:=-28 end;
      885: begin X:=39; Y:=-23 end;    888: begin X:=-34; Y:=-41 end;
      889: begin X:=-27; Y:=-44 end;   890: begin X:=-12; Y:=-53 end;
      891: begin X:=52; Y:=-7 end;     892: begin X:=44; Y:=-13 end;
      893: begin X:=5; Y:=-15 end;     896: begin X:=-30; Y:=-70 end;
      897: begin X:=12; Y:=-52 end;    898: begin X:=-17; Y:=-70 end;
      899: begin X:=35; Y:=9 end;      900: begin X:=30; Y:=-2 end;
      901: begin X:=-35; Y:=-17 end;   904: begin X:=-4; Y:=-87 end;
      905: begin X:=28; Y:=-46 end;    906: begin X:=-7; Y:=-88 end;
      907: begin X:=-20; Y:=13 end;    908: begin X:=-19; Y:=1 end;
      909: begin X:=-45; Y:=-47 end;   912: begin X:=11; Y:=-83 end;
      913: begin X:=36; Y:=-35 end;    914: begin X:=-5; Y:=-91 end;
      915: begin X:=-54; Y:=3 end;     916: begin X:=-47; Y:=-6 end;
      917: begin X:=-19; Y:=-74 end;   920: begin X:=30; Y:=-60 end;
      921: begin X:=34; Y:=-23 end;    922: begin X:=8; Y:=-81 end;
      923: begin X:=-48; Y:=-23 end;   924: begin X:=-38; Y:=-29 end;
      925: begin X:=7; Y:=-80 end;     928: begin X:=42; Y:=-69 end;
      929: begin X:=2; Y:=-17 end;     930: begin X:=-33; Y:=-54 end;
      931: begin X:=-6; Y:=-44 end;    932: begin X:=39; Y:=-48 end;
      933: begin X:=2; Y:=-76 end;     934: begin X:=-57; Y:=-27 end;
      935: begin X:=3; Y:=-78 end;     936: begin X:=38; Y:=-48 end;
      937: begin X:=-40; Y:=-23 end;   938: begin X:=-47; Y:=-64 end;
      939: begin X:=-39; Y:=-50 end;   940: begin X:=37; Y:=-33 end;
      941: begin X:=38; Y:=-60 end;    942: begin X:=-41; Y:=-63 end;
      943: begin X:=33; Y:=-62 end;    944: begin X:=20; Y:=-34 end;
      945: begin X:=-51; Y:=-55 end;   946: begin X:=-24; Y:=-88 end;
      947: begin X:=-41; Y:=-74 end;   948: begin X:=-5; Y:=-23 end;
      949: begin X:=60; Y:=-24 end;    950: begin X:=7; Y:=-83 end;
      951: begin X:=52; Y:=-33 end;    952: begin X:=-8; Y:=-40 end;
      953: begin X:=-21; Y:=-83 end;   954: begin X:=11; Y:=-97 end;
      955: begin X:=-8; Y:=-95 end;    956: begin X:=-36; Y:=-33 end;
      957: begin X:=55; Y:=-1 end;     958: begin X:=38; Y:=-74 end;
      959: begin X:=50; Y:=-13 end;    960: begin X:=-27; Y:=-59 end;
      961: begin X:=10; Y:=-91 end;    962: begin X:=27; Y:=-84 end;
      963: begin X:=13; Y:=-97 end;    964: begin X:=-36; Y:=-61 end;
      965: begin X:=17; Y:=14 end;     966: begin X:=48; Y:=-40 end;
      968: begin X:=-20; Y:=-82 end;   969: begin X:=33; Y:=-72 end;
      970: begin X:=36; Y:=-69 end;    971: begin X:=28; Y:=-76 end;
      972: begin X:=-11; Y:=-82 end;   973: begin X:=-44; Y:=11 end;
      974: begin X:=40; Y:=-13 end;    975: begin X:=-38; Y:=-2 end;
      976: begin X:=8; Y:=-93 end;     977: begin X:=47; Y:=-43 end;
      978: begin X:=35; Y:=-56 end;    979: begin X:=36; Y:=-63 end;
      980: begin X:=4; Y:=-82 end;     981: begin X:=-72; Y:=-16 end;
      982: begin X:=18; Y:=-4 end;     983: begin X:=-62; Y:=-25 end;
      984: begin X:=33; Y:=-86 end;    985: begin X:=43; Y:=-26 end;
      986: begin X:=12; Y:=-50 end;    987: begin X:=32; Y:=-51 end;
      988: begin X:=25; Y:=-62 end;    989: begin X:=-48; Y:=-58 end;
      990: begin X:=-28; Y:=-8 end;    991: begin X:=-39; Y:=-62 end;
      992: begin X:=-9; Y:=-83 end;    993: begin X:=-13; Y:=-82 end;
      994: begin X:=-17; Y:=-64 end;   995: begin X:=-23; Y:=-58 end;
      996: begin X:=-12; Y:=-55 end;   997: begin X:=34; Y:=-87 end;
      1000: begin X:=28; Y:=-84 end;  1001: begin X:=26; Y:=-86 end;
      1002: begin X:=-11; Y:=-81 end; 1003: begin X:=-31; Y:=-61 end;
      1004: begin X:=-31; Y:=-69 end; 1005: begin X:=35; Y:=-77 end;
      1008: begin X:=36; Y:=-69 end;  1009: begin X:=36; Y:=-71 end;
      1010: begin X:=11; Y:=-90 end;  1011: begin X:=-12; Y:=-77 end;
      1012: begin X:=-21; Y:=-92 end; 1013: begin X:=24; Y:=-69 end;
      1016: begin X:=32; Y:=-41 end;  1017: begin X:=33; Y:=-45 end;
      1018: begin X:=28; Y:=-85 end;  1019: begin X:=19; Y:=-81 end;
      1020: begin X:=6; Y:=-106 end;  1021: begin X:=8; Y:=-69 end;
      1024: begin X:=20; Y:=-20 end;  1025: begin X:=22; Y:=-23 end;
      1026: begin X:=20; Y:=-69 end;  1027: begin X:=20; Y:=-69 end;
      1028: begin X:=13; Y:=-99 end;  1029: begin X:=-7; Y:=-76 end;
      1032: begin X:=1; Y:=-20 end;   1033: begin X:=6; Y:=-18 end;
      1034: begin X:=10; Y:=-52 end;  1035: begin X:=19; Y:=-55 end;
      1036: begin X:=22; Y:=-78 end;  1037: begin X:=-10; Y:=-87 end;
      1040: begin X:=-32; Y:=-35 end; 1041: begin X:=-29; Y:=-33 end;
      1042: begin X:=3; Y:=-44 end;   1043: begin X:=18; Y:=-51 end;
      1044: begin X:=27; Y:=-64 end;  1045: begin X:=2; Y:=-94 end;
      1048: begin X:=-36; Y:=-61 end; 1049: begin X:=-38; Y:=-59 end;
      1050: begin X:=-2; Y:=-49 end;  1051: begin X:=9; Y:=-54 end;
      1052: begin X:=24; Y:=-55 end;  1053: begin X:=22; Y:=-92 end;
      1056: begin X:=23; Y:=-35 end;  1057: begin X:=6; Y:=-44 end;
      1058: begin X:=28; Y:=-25 end;  1059: begin X:=40; Y:=-36 end;
      1060: begin X:=22; Y:=-7 end;   1061: begin X:=44; Y:=-7 end;
      1062: begin X:=13; Y:=-5 end;   1063: begin X:=31; Y:=10 end;
      1064: begin X:=5; Y:=-6 end;    1065: begin X:=10; Y:=16 end;
      1066: begin X:=-24; Y:=-13 end; 1067: begin X:=-24; Y:=7 end;
      1068: begin X:=-34; Y:=-20 end; 1069: begin X:=-52; Y:=-8 end;
      1070: begin X:=-13; Y:=-30 end; 1071: begin X:=-39; Y:=-26 end;
      1072: begin X:=39; Y:=-25 end;  1073: begin X:=39; Y:=-41 end;
      1074: begin X:=39; Y:=-54 end;  1080: begin X:=26; Y:=-4 end;
      1081: begin X:=33; Y:=-12 end;  1082: begin X:=39; Y:=-21 end;
      1088: begin X:=7; Y:=-2 end;    1089: begin X:=18; Y:=-6 end;
      1090: begin X:=24; Y:=-8 end;   1096: begin X:=-32; Y:=-14 end;
      1097: begin X:=-13; Y:=-10 end; 1098: begin X:=2; Y:=-9 end;
      1104: begin X:=-50; Y:=-31 end; 1105: begin X:=-47; Y:=-22 end;
      1106: begin X:=-40; Y:=-19 end; 1112: begin X:=-28; Y:=-60 end;
      1113: begin X:=-42; Y:=-47 end; 1114: begin X:=-51; Y:=-40 end;
      1120: begin X:=21; Y:=-68 end;  1121: begin X:=-2; Y:=-67 end;
      1122: begin X:=-19; Y:=-67 end; 1128: begin X:=42; Y:=-54 end;
      1129: begin X:=33; Y:=-63 end;  1130: begin X:=27; Y:=-70 end;
      1136: begin X:=30; Y:=-27 end;  1137: begin X:=28; Y:=-20 end;
      1138: begin X:=16; Y:=-59 end;  1139: begin X:=-26; Y:=-62 end;
      1144: begin X:=33; Y:=-17 end;  1145: begin X:=39; Y:=-9 end;
      1146: begin X:=54; Y:=-45 end;  1147: begin X:=53; Y:=-64 end;
      1152: begin X:=20; Y:=-10 end;  1153: begin X:=28; Y:=1 end;
      1154: begin X:=59; Y:=-7 end;   1155: begin X:=85; Y:=-27 end;
      1160: begin X:=5; Y:=-12 end;   1161: begin X:=11; Y:=3 end;
      1162: begin X:=41; Y:=15 end;   1163: begin X:=68; Y:=26 end;
      1168: begin X:=-4; Y:=-17 end;  1169: begin X:=-3; Y:=-2 end;
      1170: begin X:=7; Y:=21 end;    1171: begin X:=21; Y:=50 end;
      1176: begin X:=-19; Y:=-27 end; 1177: begin X:=-21; Y:=-13 end;
      1178: begin X:=-41; Y:=9 end;   1179: begin X:=-30; Y:=40 end;
      1184: begin X:=-22; Y:=-34 end; 1185: begin X:=-26; Y:=-24 end;
      1186: begin X:=-69; Y:=-14 end; 1187: begin X:=-77; Y:=8 end;
      1192: begin X:=-1; Y:=-33 end;  1193: begin X:=-6; Y:=-26 end;
      1194: begin X:=-44; Y:=-42 end; 1195: begin X:=-80; Y:=-27 end;
    end;
  end;

var
  wm: TWMImages;
begin
   m_BodySurface := FrmMain.GetWHumImg(m_btDress,m_btSex ,m_nCurrentFrame, m_nPx, m_nPy, m_CurMagic, m_boCboMode);
   if m_BodySurface = nil then begin
     m_BodySurface := FrmMain.GetWHumImg(0,m_btSex ,m_nCurrentFrame, m_nPx, m_nPy, m_CurMagic, m_boCboMode);
   end;

   if (m_nHairOffset >= 0) then begin
     if not m_boCboMode then m_HairSurface := g_WHairImgImages.GetCachedImage (m_nHairOffset + m_nCurrentFrame, m_nHpx, m_nHpy)
     else begin
       m_HairSurface := g_WCboHairImgImages.GetCachedImage (m_nCboHairOffset + m_nCurrentFrame, m_nHpx, m_nHpy);
     end;
   end else m_HairSurface := nil;
   if (m_btEffect = 50) then begin
     if (m_nCurrentFrame <= 536) then begin
       if (GetTickCount - m_dwFrameTick) > 100 then begin
         if m_nFrame < 19 then Inc(m_nFrame)
         else m_nFrame:=0;
         m_dwFrameTick:=GetTickCount();
       end;
       m_HumWinSurface := g_WEffectImages.GetCachedImage (m_nHumWinOffset + m_nFrame, m_nSpx, m_nSpy);
     end;
   end else if m_nFeature.nDressLook <> High(m_nFeature.nDressLook) then begin
     wm := GetEffectWil(m_nFeature.nDressLookWil);
     if wm <> nil then begin
       if m_nCurrentFrame < 64 then begin
         if (GetTickCount - m_dwFrameTick) > m_dwFrameTime then begin
           if m_nFrame < 7 then Inc(m_nFrame)   //8������
           else m_nFrame:=0;
           m_dwFrameTick:=GetTickCount();
         end;
         m_HumWinSurface := wm.GetCachedImage (m_nHumWinOffset + (m_btDir * 8) + m_nFrame, m_nSpx, m_nSpy);
       end else begin
         if not m_boCboMode then begin
           m_HumWinSurface := wm.GetCachedImage (m_nHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy);
         end else begin
           if wm = g_WHumWing4Images then
             m_HumWinSurface:=g_WCboHumWingImages4.GetCachedImage (m_nCboHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy)
           else
           if wm = g_WHumWing3Images then
             m_HumWinSurface:=g_WCboHumWingImages3.GetCachedImage (m_nCboHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy)
           else if (wm = g_WHumWing2Images) and (m_nFeature.nDressLook > 4799) then
             m_HumWinSurface:=g_WCboHumWingImages2.GetCachedImage (m_nCboHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy)
           else m_HumWinSurface:=g_WCboHumWingImages.GetCachedImage (m_nCboHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy);
         end;
       end;
     end;
   end;
   m_WeaponSurface:=FrmMain.GetWWeaponImg(m_btWeapon,m_btSex,m_nCurrentFrame, m_nWpx, m_nWpy, m_boCboMode);
   if m_nFeature.nWeaponLook <> High(m_nFeature.nWeaponLook) then begin
     wm := GetEffectWil(m_nFeature.nWeaponLookWil);
     if wm <> nil then begin
       if not m_boCboMode then begin
         m_WeaponEffSurface := wm.GetCachedImage(m_nWeaponEffOffset + m_nCurrentFrame, m_nEpx, m_nEpy);
         if (m_nFeature.nWeaponLook = 0) and (wm = g_WHumWing2Images) then
           GetNJXY(m_nWeaponEffOffset + m_nCurrentFrame, m_nEpx, m_nEpy);
       end else begin
         if (wm = g_WHumWing2Images) and (m_nFeature.nWeaponLook > 2399) then
           m_WeaponEffSurface := g_WCboHumWingImages2.GetCachedImage(m_nCboWeaponEffOffset + m_nCurrentFrame, m_nEpx, m_nEpy)
         else if wm = g_WWeaponEffectImages4 then
           m_WeaponEffSurface := g_WCboWeaponEffectImages4.GetCachedImage(m_nCboWeaponEffOffset + m_nCurrentFrame, m_nEpx, m_nEpy)
         else if m_nFeature.nWeaponLookWil <> 2 then
           m_WeaponEffSurface := g_WCboHumWingImages.GetCachedImage(m_nCboWeaponEffOffset + m_nCurrentFrame, m_nEpx, m_nEpy)
         else m_WeaponEffSurface := nil;
       end;
     end;
   end;
   if m_WeaponSurface = nil then
     m_WeaponSurface:=FrmMain.GetWWeaponImg(0,m_btSex,m_nCurrentFrame, m_nWpx, m_nWpy, m_boCboMode);
end;
{
7 0 1
6   2
5 4 3
}
procedure  THumActor.DrawStall (dsurface: TDirectDrawSurface; dx, dy: integer);
var
  d: TDirectDrawSurface;
begin
  if m_boIsShop and not m_boDeath then begin
    if m_btDir > 7 then Exit; //��ǰվ������ ������0..7
    d := nil;
    case m_btDir of
      7: begin
        d := g_qingqingImages.Images[16];
        if d <> nil then begin
          dsurface.Draw(dx +  m_nShiftX - 52, dy  + m_nShiftY - 32, d.ClientRect, d);
        end;
      end;
      1: begin
        d := g_qingqingImages.Images[18];
        if d <> nil then begin
          dsurface.Draw(dx + m_nShiftX - 22, dy + m_nShiftY - 25, d.ClientRect, d);
        end;
      end;
      5: begin
        d := g_qingqingImages.Images[17];
        if d <> nil then begin
          dsurface.Draw(dx +  m_nShiftX - 45, dy + m_nShiftY - 10, d.ClientRect, d);
        end;
      end;
      3: begin
        d := g_qingqingImages.Images[15];
        if d <> nil then begin
          dsurface.Draw(dx + m_nShiftX - 24, dy + m_nShiftY - 10, d.ClientRect, d);
        end;
      end;
    end;
  end;
end;
{-----------------------------------------------------------------}
//��������
{-----------------------------------------------------------------}
procedure  THumActor.DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean;boFlag:Boolean);
var
   idx, ax, ay: integer;
   d: TDirectDrawSurface;
   ceff: TColorEffect;
   wimg: TWMImages;
   ErrorCode: Integer;
begin
  try
    d := nil;//Jacky
    if m_btDir > 7 then Exit; //��ǰվ������ ������0..7
    if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin  //60���ͷ�һ��δʹ�õ�ͼƬ������ÿ��60��Ҫ����װ��һ��
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; //����װ��ͼƬ��bodysurface
    end;

    ceff := GetDrawEffectValue;//������ʾ��ɫ
    ErrorCode := 3;
    if (m_btRace = 0) or (m_btRace = 1) or (m_btRace = 150) then begin //����,Ӣ��,����20080629
      if (m_nCurrentFrame >= 0) and (m_nCurrentFrame <= 599) then m_nWpord := WORDER[m_btSex, m_nCurrentFrame];
      {$IF M2Version <> 2}
      if not g_boHideHumanWing then begin
      {$IFEND}
        //if (m_btEffect <> 0) then begin
        if (m_nFeature.nDressLook <> High(m_nFeature.nDressLook)) or (m_btEffect = 50) then begin
          if ((m_btDir = 3) or (m_btDir = 4) or (m_btDir = 5)) and (m_HumWinSurface <> nil) then begin
            if (g_MySelf = Self) then begin
                   DrawBlend (dsurface, dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 120);
            end else begin;//0x0047CF4D
                if ((g_FocusCret <> nil) or (g_MagicTarget <> nil)) and blend and not boFlag then begin
                   DrawBlend (dsurface,
                              dx + m_nSpx + m_nShiftX,
                              dy + m_nSpy + m_nShiftY,
                              m_HumWinSurface,
                              120);
                end else begin;//0x0047CFD4
                  if boFlag then begin
                     DrawBlend (dsurface,
                                dx + m_nSpx + m_nShiftX,
                                dy + m_nSpy + m_nShiftY,
                                m_HumWinSurface,
                                120);
                  end;//0x0047D03F
                end;
            end;
          end;
        end;//0x0047D03F
      {$IF M2Version <> 2}
      end;
      {$IFEND}
      ErrorCode := 4;
      //�Ȼ�����
      if (m_nWpord = 0) and (not blend) and (m_btWeapon >= 2) and (m_WeaponSurface <> nil) {and (not m_boHideWeapon)20080803ע��} then begin
         DrawEffSurface (dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY, blend, ceNone);  //Į�� ���� �Ⱥ���
          if (m_nFeature.nWeaponLook <> High(m_nFeature.nWeaponLook)) and (m_WeaponEffSurface <> nil){$IF M2Version <> 2} and (not g_boHideWeaponEffect){$IFEND} then
            DrawBlend(dsurface,dx + m_nEpx + m_nShiftX, dy + m_nEpy + m_nShiftY, m_WeaponEffSurface, 120);
      end;
      //������
      ErrorCode := 5;
      if m_BodySurface <> nil then begin
         DrawEffSurface (dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
      end;
      //��ͷ��
      if m_HairSurface <> nil then
         DrawEffSurface (dsurface, m_HairSurface, dx + m_nHpx + m_nShiftX, dy + m_nHpy + m_nShiftY, blend, ceff);
      ErrorCode := 6;
      //������
      if (m_nWpord = 1) and {(not blend) and} (m_btWeapon >= 2) and (m_WeaponSurface <> nil) {and (not m_boHideWeapon)20080803ע��} then begin
         DrawEffSurface (dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY, blend, ceNone);
          if (m_nFeature.nWeaponLook <> High(m_nFeature.nWeaponLook)) and (m_WeaponEffSurface <> nil) {$IF M2Version <> 2}and not g_boHideWeaponEffect{$IFEND} then
             DrawBlend(dsurface,dx + m_nEpx + m_nShiftX, dy + m_nEpy + m_nShiftY, m_WeaponEffSurface, 120);
      end;
      
      ErrorCode := 7;      
      {$IF M2Version <> 2}
      if not g_boHideHumanWing then begin
      {$IFEND}
        if (m_btEffect = 50) then begin
          if not m_boDeath then begin //20080424 ����������������ʾ�⻷
            if (m_HumWinSurface <> nil) then
              DrawBlend (dsurface, dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 120);
          end;
        end else
        //if m_btEffect <> 0 then begin
        if m_nFeature.nDressLook <> High(m_nFeature.nDressLook) then begin
          if ((m_btDir = 0) or (m_btDir = 7) or (m_btDir = 1) or (m_btDir = 6)  or (m_btDir = 2)) and (m_HumWinSurface <> nil) then begin
            if g_MySelf = Self then begin
                 DrawBlend (dsurface, dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 120);
            end else begin;//0x0047D30D
              if ((g_FocusCret <> nil) or (g_MagicTarget <> nil)) and not boFlag then begin
                   DrawBlend (dsurface,
                              dx + m_nSpx + m_nShiftX,
                              dy + m_nSpy + m_nShiftY,
                              m_HumWinSurface,
                              120);
              end else begin;//0x0047D3A0
                if boFlag then begin
                   DrawBlend (dsurface,
                              dx + m_nSpx + m_nShiftX,
                              dy + m_nSpy + m_nShiftY,
                              m_HumWinSurface,
                              120);
                end;//0x0047D41D
              end;
            end;
          end;
        end;//0x0047D41D
      {$IF M2Version <> 2}
      end;
      {$IFEND}

      ErrorCode := 9;
      if not m_boDeath then begin  //��������ʾ
        if m_nState and $02000000 <> 0 then begin //�򽣹��ڻ���״̬
            idx := 4010 + (m_nGenAniCount mod 8);
            d := g_WCboEffectImages.GetCachedImage(idx, ax, ay);
            if d <> nil then
              DrawBlend (dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 150);
        end;
        //��ʾħ����ʱЧ��
        if m_nState and $00100000{STATE_BUBBLEDEFENCEUP} <> 0 then begin  //�ּ��Ǹ�
           if (m_nCurrentAction = SM_STRUCK) and (m_nCurBubbleStruck < 3) then
              idx := MAGBUBBLESTRUCKBASE + m_nCurBubbleStruck
           else
              idx := MAGBUBBLEBASE + (m_nGenAniCount mod 3);
           d := g_WMagicImages.GetCachedImage (idx, ax, ay);
           if d <> nil then
              DrawBlend (dsurface,
                               dx + ax + m_nShiftX,
                               dy + ay + m_nShiftY,
                               d, 130);

        end;
        {$IF M2Version <> 2}
        if m_nState and $00040000 <> 0 then begin  //��ɫħ����
           if (m_nCurrentAction = SM_STRUCK) and (m_nCurBubbleStruck < 3) then
              idx := 1845 + m_nCurBubbleStruck
           else
              idx := 1835 + (m_nGenAniCount mod 3);
           d := g_WMagic5Images.GetCachedImage (idx, ax, ay);
           if d <> nil then
              DrawBlend (dsurface,
                               dx + ax + m_nShiftX,
                               dy + ay + m_nShiftY,
                               d, 130);
        end;
        if m_nState and $00020000 <> 0 then begin//�ķ�״̬
          idx := 160 + (m_nGenAniCount mod 26);
          d := g_WMagic10Images.GetCachedImage (idx, ax, ay);
          if d <> nil then
            DrawBlend (dsurface, dx + ax + m_nShiftX,
                       dy + ay + m_nShiftY, d, 130);
        end;
        {$IFEND}
        ErrorCode := 8;
        if m_nState and $10000000 <> 0 then begin //С��״̬
            idx := 3740 + (m_nGenAniCount mod 10);;
            d := g_WMonImagesArr[23].GetCachedImage(idx, ax, ay);
            if d <> nil then
              DrawBlend (dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 150);
        end;
        if m_nState and $00004000 <> 0 then begin //����״̬
            idx := 1080 + (m_nGenAniCount mod 8);
            d := g_WMagic10Images.GetCachedImage(idx, ax, ay);
            if d <> nil then
              DrawBlend (dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 150);
        end;
        if m_nState and $00008000 <> 0 then begin//��������״̬
            idx := 964 + (m_nGenAniCount mod 4);;
            d := g_WMagic10Images.GetCachedImage(idx, ax, ay);
            if d <> nil then
              DrawBlend (dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 150);
        end;
      end;

    end;
    ErrorCode := 10;
    DrawMyShow(dsurface,dx,dy); //��ʾ������   20080229
    ErrorCode := 11;
    //��ʾħ��Ч��
    if m_boUseMagic and (m_CurMagic.EffectNumber > 0) then begin
      if m_nCurEffFrame in [0..m_nSpellFrame-1] then begin
         ErrorCode := 15;
         GetEffectBase (m_CurMagic.EffectNumber-1, 0, wimg, idx, m_btDir, m_CurMagic.EffectLevelEx);//ȡ��ħ��Ч������ͼ��
         idx := idx + m_nCurEffFrame;//IDx��ӦWIL�ļ� ���ͼƬλ�ã����ü���ʱ��ʾ�Ķ���
         ErrorCode := 16;
         if wimg <> nil then begin
            d := wimg.GetCachedImage (idx, ax, ay);
            ErrorCode := 17;
            {$IF M2Version <> 2}
            if m_CurMagic.EffectLevelEx = 0 then
              case m_CurMagic.EffectNumber of //���������λ
                115: begin //��ɫ��Ѫ��
                  if g_WMagic2Images <> nil then
                    g_WMagic2Images.GetCachedImage(idx-25, ax, ay);
                end;
                116: begin //��ɫ�ļ���Ѫ��
                  if g_WMagic2Images <> nil then
                    g_WMagic2Images.GetCachedImage(idx+15, ax, ay);
                end;
                117: begin //��ɫ�޼�����
                  if g_WMagic2Images <> nil then
                    g_WMagic2Images.GetCachedImage(idx-1015, ax, ay);
                end;
              end;
            {$IFEND}
           if d <> nil then begin
              ErrorCode := 18;
              DrawBlend (dsurface,
                               dx + ax + m_nShiftX,
                               dy + ay + m_nShiftY,
                               d, 160);
           end;
         end;
      end;
    end;
    ErrorCode := 12;
    {----------------------------------------------------------------------------}
    //��ʾ����Ч��              2007.10.31 updata
    //m_boHitEffect �Ƿ��ǹ�������
    //m_nHitEffectNumber  ʹ�ù��������� ȡ��ͼ�ĺ�
    //m_btDir  ����
    //m_nCurrentFrame ��ǰ������   m_nStartFrame��ʼ������
    {----------------------------------------------------------------------------}
    if m_boHitEffect and (m_nHitEffectNumber > 0) then begin
      GetEffectBase (m_nHitEffectNumber - 1, 1, wimg, idx, m_btDir, 0);
      {$IF M2Version <> 2}
      if m_nHitEffectNumber <> 21 then begin
      {$IFEND}
      if m_nHitEffectNumber in [8,15] then idx := idx{��ʼ�ĺ�} + m_btDir{����}*20 + (m_nCurrentFrame-m_nStartFrame){��Ӱ����}
      else idx := idx{��ʼ�ĺ�} + m_btDir{����}*10 + (m_nCurrentFrame-m_nStartFrame);
       if wimg <> nil then
         d := wimg.GetCachedImage (idx, ax, ay);
      {$IF M2Version <> 2}
      end;
      case m_nHitEffectNumber of //���������λ
        20: begin //��ɫ��ɱ����
          ax := ax + 20;
          ay := ay - 10;
        end;
        21: begin //��ɫ�һ𽣷�
           idx := idx + m_btDir*7 + (m_nCurrentFrame-m_nStartFrame);
           if wimg <> nil then
             d := wimg.GetCachedImage (idx, ax, ay);
          ax := ax + 24;
          ay := ay - 27;
        end;
        22: begin //��ɫ���ս���
          ax := ax + 25;
          ay := ay - 8
        end;
      end;
      {$IFEND}
      if d <> nil then
         DrawBlend (dsurface,
                          dx + ax + m_nShiftX,
                          dy + ay + m_nShiftY,
                          d, 200);
    end;
    ErrorCode := 13;
    //��ʾ����Ч��
    if m_boWeaponEffect then begin
      idx := WPEFFECTBASE + m_btDir * 10 + m_nCurWeaponEffect;
      d := g_WMagicImages.GetCachedImage (idx, ax, ay);
      if d <> nil then
         DrawBlend (dsurface,
                     dx + ax + m_nShiftX,
                     dy + ay + m_nShiftY,
                     d, 200);
    end;
    ErrorCode := 14;
  except
    DebugOutStr('THumActor.DrawChr'+IntToStr(ErrorCode));
  end;
end;

function TActor.FindMsg(wIdent: Word): Boolean;
var
  I: Integer;
  Msg: pTChrMsg;
begin
  Result := FALSE;
  m_MsgList.Lock;
  try
    for I := 0 to m_MsgList.Count - 1 do begin
      Msg := m_MsgList.Items[I];
      if (Msg.ident = wIdent) then begin
        Result := True;
        Break;
      end;
    end;
  finally
    m_MsgList.UnLock;
  end;
end;

end.