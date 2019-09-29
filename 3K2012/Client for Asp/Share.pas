unit Share;

interface
uses Grobal2;
//var
//  g_sVersion        :String = '�汾�ţ�2009.06.12';

const
  g_sVerIdent          = '11.15';
  RUNLOGINCODE       = 0; //������Ϸ״̬��,Ĭ��Ϊ0 ����Ϊ 9
  CLIENTTYPE         = 0; //��ͨ��Ϊ0 ,99 Ϊ����ͻ���
    //0Ϊ���԰� 1Ϊ��Ѱ� 2��ҵ��
  GVersion = 2;      //1��2�����������е�½��  ����ͻ��˹ر�
  {
  ��
  ��
  ��
  ��
  ��
  ��
  ��
  Ϊ
  ��
  ��
  ��
  ��
  ��
  }

  DEBUG         = 0;



   WINLEFT = 60;
   WINTOP  = 60;

   MAPDIR             = '\Map\'; //��ͼ�ļ�����Ŀ¼
   CONFIGFILE         = 'Config\%s.ini';
   SDOCONFIGFILE      = 'Config\Ly%s_%s\%s.ini';
   ITEMFILTER = 'Config\Ly%s_%s\ItemFilter.dat';
   MAINIMAGEFILE      = 'Data\Prguse.wil';
   MAINIMAGEFILE2     = 'Data\Prguse2.wil';
   MAINIMAGEFILE3     = 'Data\Prguse3.wil';

   CHRSELIMAGEFILE    = 'Data\ChrSel.wil';
   MINMAPIMAGEFILE    = 'Data\mmap.wil';
   TITLESIMAGEFILE    = 'Data\Tiles.wil';
   TITLESIMAGEFILE1   = 'Data\Tiles%d.wil';
   SMLTITLESIMAGEFILE = 'Data\SmTiles.wil';
   SMLTITLESIMAGEFILE1 = 'Data\SmTiles%d.wil';
   HUMWINGIMAGESFILE  = 'Data\HumEffect.wil';
   HUMWINGIMAGESFILE2  = 'Data\HumEffect2.wil';
   HUMWINGIMAGESFILE3  = 'Data\HumEffect3.wil';

   CBOHUMWINGIMAGESFILE  = 'Data\cboHumEffect.wis';
   CBOHUMWINGIMAGESFILE2  = 'Data\cboHumEffect2.wil';
   CBOHUMWINGIMAGESFILE3  = 'Data\cboHumEffect3.wil';

   MAGICONIMAGESFILE  = 'Data\MagIcon.wil';
   MAGICONIMAGESFILE2  = 'Data\MagIcon2.wil';
   HUMIMGIMAGESFILE   = 'Data\Hum.wil';
   CBOHUMIMGIMAGESFILE= 'Data\cbohum.wis';
   CBOHUMIMGIMAGESFILE3= 'Data\cbohum3.wis';
   HUM2IMGIMAGESFILE  = 'Data\Hum2.wil'; //20080501
   HUM3IMGIMAGESFILE  = 'Data\Hum3.wil';
   HUM4IMGIMAGESFILE  = 'Data\Hum4.wil';
   HAIRIMGIMAGESFILE  = 'Data\Hair2.wil';
   CBOHAIRIMAGESFILE  = 'Data\cbohair.wis';
   WEAPONIMAGESFILE   = 'Data\Weapon.wil';
   CBOWEAPONIMAGESFILE = 'Data\cboweapon.wis';
   CBOWEAPONIMAGESFILE3 = 'Data\cboweapon3.wil';
   
   WEAPON2IMAGESFILE  = 'Data\Weapon2.wil';
   WEAPON3IMAGESFILE  = 'Data\Weapon3.wil'; 

   NPCIMAGESFILE      = 'Data\Npc.wil';
   NPC2IMAGESFILE     = 'Data\Npc2.wil';
   MAGICIMAGESFILE    = 'Data\Magic.wil';
   MAGIC2IMAGESFILE   = 'Data\Magic2.wil';
   MAGIC3IMAGESFILE   = 'Data\Magic3.wil';
   MAGIC4IMAGESFILE   = 'Data\Magic4.wil'; //2007.10.28
   MAGIC5IMAGESFILE   = 'Data\Magic5.wil'; //2007.11.29
   MAGIC6IMAGESFILE   = 'Data\Magic6.wil'; //2007.11.29

   MAGIC7IMAGESFILE   = 'Data\Magic7.wil';
   MAGIC7IMAGESFILE16 = 'Data\Magic7-16.wil';
   MAGIC8IMAGESFILE   = 'Data\Magic8.wil';
   MAGIC8IMAGESFILE16 = 'Data\Magic8-16.wil';

   MAGIC9IMAGESFILE    = 'Data\Magic9.wil';
   MAGIC10IMAGESFILE   = 'Data\Magic10.wil';

   CBOEFFECTIMAGESFILE= 'Data\cboEffect.wis';
   qingqingFILE       = 'Data\Qk_Prguse.wil';
   TasUiFILE          = 'Data\TasUi.wil'; //���ȿ���GM�����Ƥ���ļ� By TasNat at: 2012-04-15 13:46:46
   chantkkFILE        = 'Data\Qk_Prguse16.wil'; // liuzhigang add

   UI1IMAGESFILE      = 'Data\Ui1.wil';
   UI3IMAGESFILE      = 'Data\Ui3.wil';
   STATEEFFECTFILE    = 'Data\StateEffect.wil';
   NEWOPUIFIle        = 'Data\NewopUI.wil';

   BAGITEMIMAGESFILE   = 'Data\Items.wil';
   BAGITEMIMAGESFILE2   = 'Data\Items2.wil';
   STATEITEMIMAGESFILE = 'Data\StateItem.wil';
   STATEITEMIMAGESFILE2 = 'Data\StateItem2.wil';

   DNITEMIMAGESFILE    = 'Data\DnItems.wil';
   DNITEMIMAGESFILE2    = 'Data\DnItems2.wil';

   OBJECTIMAGEFILE     = 'Data\Objects.wil';
   OBJECTIMAGEFILE1    = 'Data\Objects%d.wil';
   MONIMAGEFILE        = 'Data\Mon%d.wil';
   DRAGONIMAGEFILE     = 'Data\Dragon.wil';
   EFFECTIMAGEFILE     = 'Data\Effect.wil';
   DRAGONIMGESFILE     = 'Data\Dragon.wil';
   WEAPONEFFECTFILE    = 'Data\WeaponEffect.wil';
   MONKULOUIMAGEFILE   = 'Data\Mon-kulou.wil';

  MAXBAGITEMCL = 52;
  ENEMYCOLOR = 69;
  
  BuildData = '�棺2012.12.18';
  {$IF M2Version = 0}
  g_sVersion = '�ϻ�' + BuildData;
  {$ELSEIF M2Version = 2}
  g_sVersion = '1.76' + BuildData;
  {$ELSE}
  g_sVersion = '����' + BuildData;
  {$IFEND}

implementation


end.
