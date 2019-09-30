{************************************************}
{                                                }
{               EurekaLog v 6.x                  }
{            Consts Unit - EConsts               }
{                                                }
{  Copyright (c) 2001 - 2007 by Fabio Dell'Aria  }
{                                                }
{************************************************}

unit EConsts;

{$I Exceptions.inc}

interface

uses ETypes;

type
  EMsgsRec = record
    Msg: string;
    No: Integer;
  end;

const
  // Number used to check EurekaLog information presents.
  // Before the 6.0.4 version was: $000FAB10 (changed for backward compatibility).
  MagicNumber6 = $100FAB10;
  MagicNumber5 = $000FAB10;

  EurekaLogCurrentVersion: Word = 6006; // Version number - 6.0.6
  EurekaLogVersion = '6.0.6'; // String version number.

  EurekaLogViewerVersion = '3.0.3'; // EurekaLog Viewer string version number.

  ECopyrightCaption = 'Copyright (c) 2001-2008';
  EAuthorCaption = 'by ���ͺ���';

  EurekaIni = 'EurekaLog.ini';

  // SafeCall consts...
  SafeCallExceptionHandled = '[SafeCall Exception]: ';

  UnassignedPointer: Pointer = Pointer(-1);

  // Dialog colors const...
  color_DialogBack = $00C8D0D4;

  color_BackColorActive = $00C29B82; // Caption color.
  color_BorderColorActive = $00404040;
  color_BorderBackActive = $00808080;

  color_BackColorInactive = $00979797; // Caption color.
  color_BorderColorInactive = $00303030;
  color_BorderBackInactive = $00606060;

  color_CaptionActive = $00FFFFFF;
  color_CaptionShadow = $00222222;
  color_CaptionInactive = $00E0E0E0;

  color_Text = $00000000;
  color_Back = $00FFFFFF;

{$IFDEF EUREKALOG_DEMO}
  EBuyItem = '���� EurekaLog...';
  EurekaDemoString =
    'The "%s" program is compiled with EurekaLog ' + EurekaLogVersion +
    ' trial version.'#13#10 +
    'You can test this program for 30 days after its compilation.'#13#10 +
    'To buy the EurekaLog full version go to: http://www.eurekalog.com';

  EurekaTypeTRL = 'Trial';
{$ENDIF}
{$IFNDEF PROFESSIONAL}
  EurekaTypeSTD = 'Standard';
{$ELSE}
  EurekaTypePRO = 'Professional';
  EurekaTypeENT = 'Enterprise';
{$ENDIF}

  EurekaLogSection = 'Exception Log';

  EurekaLogFirstLine_XML = '<!-- EurekaLog First Line';
  EurekaLogLastLine_XML = 'EurekaLog Last Line -->';
  EurekaLogFirstLine_TXT = '';
  EurekaLogLastLine_TXT = '';

  EurekaNotRegisteredVersion = 'û��ע���';
  EurekaGoToUpdatesPage = 'ȥ����ҳ';

  EurekaBUGString = '����: ''%s'''#13#10#13#10'����һ�� ' +
    'EurekaLog bug.'#13#10 + '���벻�뷢��������Ϣ�� ' +
    '�� EurekaLog ����?';

  EurekaInternalBUGString = '����: ''%s'''#13#10#13#10'����һ���ڲ� ' +
    'EurekaLog bug.'#13#10 + '���벻�뷢��������Ϣ�� ' +
    '�� EurekaLog ����?';

  EGeneralError = 'һ�����.';
  EModule = 'ģ��: ';
  EDebugInfoNotActive = 'ѡ��"������Ϣ"��"��ͼ�ļ� = ' +
    '�꾡�ĵ�ͼ�ļ�û�з���.'#13#10'��ͼ�ļ�: "%s".'#13#10 +
    'EurekaLog ���������������. �������: %d';

  ENotReadMapFile = '���ǲ����ܵ��Ķ���ͼ�ļ�.';
  ECorrupted = '�ܻ��˵�ͼ�ļ���δ֪���ļ���ʽ.';

  EInsertEmail = '�����ѡ��һ����Ч�ĵ����ʼ���ַ.';
  EInsertURL = '�����ѡ��һ����Ч��URL.';
  EURLNoPrm = '�㲻�ܲ����ʺ�/����/�˿ڲ�����URL.';
  EURLProtConf = '�����һ���鶨���URL��ͬ����ѡ����Э������.';
  EURLInvalidPort = '�����ѡ��һ����Ч��"����˿�" ֵ.';
  EInsertSMTPFrom = '�����ѡ��һ����Ч�� "SMTP-From" �����ʼ���ַ.';
  EInsertSMTPPort = '�����ѡ��һ����Ч"SMTP-Port" ֵ.';
  EInsertSMTPHost = '�����ѡ��һ����Ч "SMTP-Host" ֵ.';
  EInvalidTrakerField = '��������һ����Ч�� Web Bug-׷�� "%s".';
  EOptionsCaption = 'EurekaLog';
  EOptions = 'EurekaLog ѡ��...';
  EOptions2 = 'EurekaLog IDE ѡ��...';
  EOptions3 = 'EurekaLog ����';
  EViewItem = '�鿴�쳣��־...';
  EAboutItem = '���� EurekaLog...';
  ETutorialItem = 'EurekaLog Tutorial...';
  EFormCaption = 'EurekaLog  ѡ��';
  EActivateLog = '&���� EurekaLog';
  EAttenction = '����.';
  EInformation = '��Ϣ';
  EInternalBUG = '�������ڲ�ȱ��';
  EInternalBUGSubject = '��� EurekaLog ' + EurekaLogVersion + ' BUG.';
  EInternalCriticalBUGSubject = 'EurekaLog ' + EurekaLogVersion + ' �ؼ� BUG.';
  EInternalBUGBody = '����������־.';
  ENoConnectWithEClient = '�������������ĵ����ʼ��ͻ������.'#13#10 +
    '���ֶ����� "%s" �ļ��� support@eurekalog.com �����ʼ���ַ, ' +
    '֮����OK��ť���رմ˶Ի���.';
  EOK = '&ȷ��';
  ECancel = '&ȡ��';
  EHelp = '&����';
  EExceptionToIgnore = '�쳣����';
  EDefault = 'ȱʡ';
  EAdd = '����';
  ESub = '�Ƴ�';
  ECapType = '����';
  ELabel_OutputPath = '��־�ļ����·��';
  EExceptionDialog = '�쳣�Ի���';
  ECapMsg = '��Ϣ';
  EExceptionsTab = '�쳣';
  ESendTab = '����';
  ELogFileTab = '��־�ļ�';
  EMessagesTab = '֪ͨ��Ϣ';
  EAdvancedTab = '�߼�';
  ESelectOutputPath = 'ѡ�����·��...';
  EActivateHandle = '����';
  ESaveLogFile = '������־�ļ�';
  EErrorType = '��������';
  EAppendLogCaption = '������־�����ģ��޴�����';
  ESendEntireLog = '����������־�ļ�';
  ESendScreenshotCaption = '������Ļ���ս�ͼ';
  EUseActiveWindow = 'ֻʹ�û�Ĵ���';
  EAppendReproduceCaption = '���� ''Reproduce Text''';
  ESMTPShowDialog = '��ʾ���ͶԻ���';
  ECommonSendOptions = '�����ķ���ѡ��';
  ECommonSaveOptions = '�����ı���ѡ��';
  ETerminateGroup = '��ֹ��ť';
  ETerminateOperation = '����';
  ENone = '(��)';
  ETerminate = '��ֹ';
  ERestart = '��������';
  EShowTerminateBtnLabel = '�鿴';
  ETerminateLabel = '�鿴';
  ELogShow = '�鿴';
  EOptionsListType = '����';
  EOptionsListSubType = '��-����';
  EMessagesLabel = '֪ͨ��Ϣ';
  ELookAndFeel = 'ʹ�� EurekaLog Ĭ�ϵ����';
  EOptionsFiles = 'ѡ���';
  ELoadOptionsBtn = '&��ȡѡ��...';
  ESaveOptionsBtn = '&���� current ѡ��...';
  EOpenLogBtn = '����־�ļ�';
  EFreezeCaption = 'Anti-Freeze ѡ��';
  EFreezeActivate = '���ʱ';
  EFreezeTimeout = '��ʱ';
  EEmailSendOptions = 'Email ����ѡ��';
  ESendNo = '������';
  ESendEmailClient = 'ʹ�� Email �ͻ���';
  ESendSMTPClient = 'ʹ�� SMTP �ͻ���';
  ESendSMTPServer = 'ʹ�� SMTP �����';
  EEmailAddresses = '��ַ';
  EEmailObject = '����';
  EEmailMessage = '��Ϣ';
  ESMTPFromCaption = '��';
  ESMTPHostCaption = 'Host';
  ESMTPPortCaption = 'Port';
  ESMTPUserIDCaption = 'UserID';
  ESMTPPasswordCaption = '����';
  ELogSave = 'Saving Options';
  ELogNumberLog = 'Number of errors to save';
  ELogNotDuplicate = '�������ظ�����';
  EAreYouSure = '��϶�?';
  EShowExceptionDialog = '���쳣�Ի���';
  ELogNotFound = '�쳣��־�ļ�������.';
  ENoProjectSelected = 'No one currently selected EurekaLog project.';
  EQuestion = 'Question.';
  EExtFileStr = 'EurekaLog options file (*.eof)|*.eof';
  EErrorCaption = 'Error.';
  EForegroundTitle = 'Foreground Tab';
  ERadioCPU = 'CPU';
  ERadioModulesList = 'Modules List';
  ERadioCallStack = 'Call Stack';
  ERadioGeneral = 'General';
  EInternalErrorCaption = 'WARNING';
  EInternalError = 'An exception has raised into the "%s" event.'#13#10
    + 'Please contact the assistance.';
  EInternalHookExceptionError = 'An internal error has occurred into the ' +
    '"ExceptNotify" procedure at line %d.'#13#10 +
    'Please contact the assistance.';

  EAboutCaption = '���� EurekaLog';
  EExpireTime = 'Every project compiled with EurekaLog'#13#10'expires after 30 days.';
  EOrder = '&Buy now';
  EWhatIs = '&What is it?';
  EWaitingCaption = 'EurekaLog processing...';
  ECommonOptions = 'Common Options';
  ESendInThread = 'Sent in a separated thread';
  ESendHTML = 'Send last HTML page';
  ESaveFailure = 'Save only for failure sent';
  EWebSendOptions = 'Web Send Options';
  EWebPort = 'Port';
  EWebUser = 'User';
  EWebPassword = 'Password';
  EWebURL = 'URL';
  EWebUseFTP = 'FTP';
  EWebUseHTTP = 'HTTP';
  EWebUseHTTPS = 'HTTPS';  
  EWebNoSend = 'No send';
  EAttachedFiles = 'Attached files';
  ECopyLogInCaseOfError = '������־���ַ��ʹ���';
  ESaveFiles = '����ZIP�ļ���������ʧ��';
  EUseMainModuleOptions = 'ʹ����ģ��ѡ��';
  EAddDateInFileName = 'Add ''Date'' in sent file name';
  EAddComputerName = 'Add ''Computer name'' in Log file name';
  ESaveModulesAndProcessesSection = 'Save Modules and Processes Sections';
  ESaveAssemblerAndCPUSection = 'Save Assembler and CPU Sections';
  ESendXMLCopy = 'Send an XML Log''s copy';
  EDeleteLog = 'Delete the Log at version change';
  ECloseEveryDialog = 'Close every dialog after';
  ESeconds = 'seconds';
  ESupportURL = 'Support URL';
  EHTMLLayout = 'HTML Layout';
  EHTMLLayoutHELP = 'Help: use <%HTML_TAG%> tag';
  EShowDetailsButton = 'Show ''Details'' button';
  EShowInDetailedMode = 'Show dialog in ''Detailed'' mode';
  ESendEmailChecked = '''Send Error Report'' option checked';
  EAttachScreenshotChecked = '''Attach Screenshot'' option checked';
  EShowCopyToClipboard = 'Show ''Copy to clipboard'' option';
  EShowInTopMost = 'Show dialog in Top-Most mode';
  EEncryptPassword = 'Encryption password';
  EShowDlls = 'Show the DLLs functions';
  EShowBPLs = 'Show the BPLs functions';
  EShowBorladThreads = 'Show all Borland Threads call-stack';
  EShowWindowsThreads = 'Show all Windows Threads call-stack';
  EBehaviour = 'Behaviour Options';
  EAutoTerminateApplicationLabel1 = 'application after';
  EAutoTerminateApplicationLabel2 = '������';
  EAutoTerminateApplicationLabel3 = '����';
  EPauseBorlandThreads = '��ͣ����Borland�߳�';
  EDoNotPauseMainThread = '��ֹͣ�����߳�';
  EPauseWindowsthread = '��ͣ����Windows�߳�';
  EActivateAutoTerminateApplication = '�����Զ���ֹ/��������';

  EMsgs: array[0..171] of EMsgsRec = (
    (Msg: '֪ͨ��Ϣ����'; No: -1), // Items
    (Msg: '��Ϣ'; No: Integer(mtInformationMsgCaption)),
    (Msg: '����'; No: Integer(mtQuestionMsgCaption)),
    (Msg: '����'; No: Integer(mtErrorMsgCaption)),

    (Msg: '�쳣�Ի���(EurekaLog ����)'; No: -1), // Items
    (Msg: '���� (��������)'; No: Integer(mtDialog_Caption)),
    (Msg: '������Ϣ'; No: Integer(mtDialog_ErrorMsgCaption)),
    (Msg: '�������'; No: Integer(mtDialog_GeneralCaption)),
    (Msg: '���汨ͷ'; No: Integer(mtDialog_GeneralHeader)),
    (Msg: '���ö�ջ����'; No: Integer(mtDialog_CallStackCaption)),
    (Msg: '���ö�ջ��ͷ'; No: Integer(mtDialog_CallStackHeader)),
    (Msg: 'ģ���б����'; No: Integer(mtDialog_ModulesCaption)),
    (Msg: 'ģ���б�ͷ'; No: Integer(mtDialog_ModulesHeader)),
    (Msg: '�����б����'; No: Integer(mtDialog_ProcessesCaption)),
    (Msg: '�����б�ͷ'; No: Integer(mtDialog_ProcessesHeader)),
    (Msg: 'Asembler ����'; No: Integer(mtDialog_AsmCaption)),
    (Msg: 'Assembler ��ͷ'; No: Integer(mtDialog_AsmHeader)),
    (Msg: 'CPU ����'; No: Integer(mtDialog_CPUCaption)),
    (Msg: 'CPU ��ͷ'; No: Integer(mtDialog_CPUHeader)),
    (Msg: 'ȷ������'; No: Integer(mtDialog_OKButtonCaption)),
    (Msg: '��ֹ����'; No: Integer(mtDialog_TerminateButtonCaption)),
    (Msg: '������������'; No: Integer(mtDialog_RestartButtonCaption)),
    (Msg: 'ȱʡ����'; No: Integer(mtDialog_DetailsButtonCaption)),
    (Msg: '���水�� (��������)'; No: Integer(mtDialog_CustomButtonCaption)),
    (Msg: '��������Ϣ'; No: Integer(mtDialog_SendMessage)),
    (Msg: '��ͼ��Ϣ'; No: Integer(mtDialog_ScreenshotMessage)),
    (Msg: '������Ϣ'; No: Integer(mtDialog_CopyMessage)),
    (Msg: '֧����Ϣ'; No: Integer(mtDialog_SupportMessage)),

    (Msg: '�쳣�Ի���(΢����)'; No: -1), // Items
    (Msg: '������Ϣ'; No: Integer(mtMSDialog_ErrorMsgCaption)),
    (Msg: '����������Ϣ'; No: Integer(mtMSDialog_RestartCaption)),
    (Msg: '��ֹ��Ϣ'; No: Integer(mtMSDialog_TerminateCaption)),
    (Msg: '"��..." ��Ϣ'; No: Integer(mtMSDialog_PleaseCaption)),
    (Msg: '������Ϣ'; No: Integer(mtMSDialog_DescriptionCaption)),
    (Msg: '"����..." ��Ϣ'; No: Integer(mtMSDialog_SeeDetailsCaption)),
    (Msg: '"������" ��Ϣ'; No: Integer(mtMSDialog_SeeClickCaption)),
    (Msg: '"��θ���" ��Ϣ'; No: Integer(mtMSDialog_HowToReproduceCaption)),
    (Msg: '"Email ��ַ" �ı�'; No: Integer(mtMSDialog_EmailCaption)),
    (Msg: '���ͼ�'; No: Integer(mtMSDialog_SendButtonCaption)),
    (Msg: '�����ͼ�'; No: Integer(mtMSDialog_NoSendButtonCaption)),

    (Msg: '���ͶԻ���'; No: -1), // Item
    (Msg: '����'; No: Integer(mtSendDialog_Caption)),
    (Msg: '��Ϣ'; No: Integer(mtSendDialog_Message)),
    (Msg: '�����Ϣ'; No: Integer(mtSendDialog_Resolving)),
    (Msg: '��½��Ϣ'; No: Integer(mtSendDialog_Login)),
    (Msg: '����������Ϣ'; No: Integer(mtSendDialog_Connecting)),
    (Msg: '������Ϣ'; No: Integer(mtSendDialog_Connected)),
    (Msg: '���ڷ�����Ϣ'; No: Integer(mtSendDialog_Sending)),
    (Msg: '������Ϣ'; No: Integer(mtSendDialog_Sent)),
    (Msg: 'ѡ����Ŀ��Ϣ'; No: Integer(mtSendDialog_SelectProject)),
    (Msg: '������Ϣ'; No: Integer(mtSendDialog_Searching)),
    (Msg: '�޸���Ϣ'; No: Integer(mtSendDialog_Modifying)),
    (Msg: '���ڶϿ���Ϣ'; No: Integer(mtSendDialog_Disconnecting)),
    (Msg: '�Ͽ���Ϣ'; No: Integer(mtSendDialog_Disconnected)),

    (Msg: '���ƶԻ���'; No: -1), // Item
    (Msg: '����'; No: Integer(mtReproduceDialog_Caption)),
    (Msg: '������Ϣ'; No: Integer(mtReproduceDialog_Request)),
    (Msg: 'ȷ��'; No: Integer(mtReproduceDialog_OKButtonCaption)),

    (Msg: '��������'; No: -1), // Items
    (Msg: 'Ӧ��ͷ'; No: Integer(mtLog_AppHeader)),
    (Msg: '    ��ʼ����'; No: Integer(mtLog_AppStartDate)),
    (Msg: '    ����/����'; No: Integer(mtLog_AppName)),
    (Msg: '    �汾��'; No: Integer(mtLog_AppVersionNumber)),
    (Msg: '    ����'; No: Integer(mtLog_AppParameters)),
    (Msg: '    ��������'; No: Integer(mtLog_AppCompilationDate)),
    (Msg: '    ����ʱ��'; No: Integer(mtLog_AppUpTime)),
    (Msg: '�쳣��ͷ'; No: Integer(mtLog_ExcHeader)),
    (Msg: '    ����'; No: Integer(mtLog_ExcDate)),
    (Msg: '    ��ַ'; No: Integer(mtLog_ExcAddress)),
    (Msg: '    ģ����'; No: Integer(mtLog_ExcModuleName)),
    (Msg: '    ģ��汾'; No: Integer(mtLog_ExcModuleVersion)),
    (Msg: '    ����'; No: Integer(mtLog_ExcType)),
    (Msg: '    ��Ϣ'; No: Integer(mtLog_ExcMessage)),
    (Msg: '    ID'; No: Integer(mtLog_ExcID)),
    (Msg: '    ����'; No: Integer(mtLog_ExcCount)),
    (Msg: '    ״̬'; No: Integer(mtLog_ExcStatus)),
    (Msg: '    ��ע'; No: Integer(mtLog_ExcNote)),
    (Msg: '�û�����'; No: Integer(mtLog_UserHeader)),
    (Msg: '    ID'; No: Integer(mtLog_UserID)),
    (Msg: '    ����'; No: Integer(mtLog_UserName)),
    (Msg: '    Email'; No: Integer(mtLog_UserEmail)),
    (Msg: '    ��˾'; No: Integer(mtLog_UserCompany)),
    (Msg: '    ��Ȩ'; No: Integer(mtLog_UserPrivileges)),
    (Msg: '����Ʊ���'; No: Integer(mtLog_ActCtrlsHeader)),
    (Msg: '    ������'; No: Integer(mtLog_ActCtrlsFormClass)),
    (Msg: '    �����ı�'; No: Integer(mtLog_ActCtrlsFormText)),
    (Msg: '    ������'; No: Integer(mtLog_ActCtrlsControlClass)),
    (Msg: '    �����ı�'; No: Integer(mtLog_ActCtrlsControlText)),
    (Msg: '���Ա���'; No: Integer(mtLog_CmpHeader)),
    (Msg: '    ����'; No: Integer(mtLog_CmpName)),
    (Msg: '    �ܼ�������'; No: Integer(mtLog_CmpTotalMemory)),
    (Msg: '    �ڴ�'; No: Integer(mtLog_CmpFreeMemory)),
    (Msg: '    ��������'; No: Integer(mtLog_CmpTotalDisk)),
    (Msg: '    ���д���'; No: Integer(mtLog_CmpFreeDisk)),
    (Msg: '    ϵͳʱ��'; No: Integer(mtLog_CmpSystemUpTime)),
    (Msg: '    ������'; No: Integer(mtLog_CmpProcessor)),
    (Msg: '    ��ʾģʽ'; No: Integer(mtLog_CmpDisplayMode)),
    (Msg: '    ��ʾ DPI'; No: Integer(mtLog_CmpDisplayDPI)),
    (Msg: '    ��Ƶ��'; No: Integer(mtLog_CmpVideoCard)),
    (Msg: '    ��ӡ��'; No: Integer(mtLog_CmpPrinter)),
    (Msg: '����ϵͳ����'; No: Integer(mtLog_OSHeader)),
    (Msg: '    ����'; No: Integer(mtLog_OSType)),
    (Msg: '    Build #'; No: Integer(mtLog_OSBuildN)),
    (Msg: '    ����'; No: Integer(mtLog_OSUpdate)),
    (Msg: '    ����'; No: Integer(mtLog_OSLanguage)),
    (Msg: '    �ַ���'; No: Integer(mtLog_OSCharset)),
    (Msg: '��������'; No: Integer(mtLog_NetHeader)),
    (Msg: '    IP��ַ'; No: Integer(mtLog_NetIP)),
    (Msg: '    Submask'; No: Integer(mtLog_NetSubmask)),
    (Msg: '    ����'; No: Integer(mtLog_NetGateway)),
    (Msg: '    DNS 1'; No: Integer(mtLog_NetDNS1)),
    (Msg: '    DNS 2'; No: Integer(mtLog_NetDNS2)),
    (Msg: '    DHCP'; No: Integer(mtLog_NetDHCP)),
    (Msg: '������Ϣ����'; No: Integer(mtLog_CustInfoHeader)),

    (Msg: '���ö�ջ'; No: -1), // Items
    (Msg: '��ַ'; No: Integer(mtCallStack_Address)),
    (Msg: 'ģ��'; No: Integer(mtCallStack_Name)),
    (Msg: '��Ԫ'; No: Integer(mtCallStack_Unit)),
    (Msg: '��'; No: Integer(mtCallStack_Class)),
    (Msg: '����/����'; No: Integer(mtCallStack_Procedure)),
    (Msg: '�߳�'; No: Integer(mtCallStack_Line)),

    (Msg: '�߳�����'; No: -1), // Items
    (Msg: '���߳�'; No: Integer(mtCallStack_MainThread)),
    (Msg: '�쳣�߳�'; No: Integer(mtCallStack_ExceptionThread)),
    (Msg: '�����е��߳�'; No: Integer(mtCallStack_RunningThread)),
    (Msg: '�����õ��߳�'; No: Integer(mtCallStack_CallingThread)),
    (Msg: '�߳� ID'; No: Integer(mtCallStack_ThreadID)),
    (Msg: '�߳� Priority'; No: Integer(mtCallStack_ThreadPriority)),
    (Msg: '�߳�����'; No: Integer(mtCallStack_ThreadClass)),

    (Msg: 'й©����'; No: -1), // Items
    (Msg: 'й©����'; No: Integer(mtCallStack_LeakCaption)),
    (Msg: 'й© ''����'''; No: Integer(mtCallStack_LeakData)),
    (Msg: 'й© ����'; No: Integer(mtCallStack_LeakType)),
    (Msg: 'й© ��С'; No: Integer(mtCallStack_LeakSize)),
    (Msg: 'й© ����'; No: Integer(mtCallStack_LeakCount)),

    (Msg: 'ģ���б�'; No: -1), // Items
    (Msg: '���'; No: Integer(mtModules_Handle)),
    (Msg: '����'; No: Integer(mtModules_Name)),
    (Msg: '����'; No: Integer(mtModules_Description)),
    (Msg: '�汾'; No: Integer(mtModules_Version)),
    (Msg: '��С'; No: Integer(mtModules_Size)),
    (Msg: '����޸� '; No: Integer(mtModules_LastModified)),
    (Msg: '·��'; No: Integer(mtModules_Path)),

    (Msg: '�����б�'; No: -1), // Items
    (Msg: 'ID'; No: Integer(mtProcesses_ID)),
    (Msg: '����'; No: Integer(mtProcesses_Name)),
    (Msg: '����'; No: Integer(mtProcesses_Description)),
    (Msg: '�汾'; No: Integer(mtProcesses_Version)),
    (Msg: '�ڴ�'; No: Integer(mtProcesses_Memory)),
    (Msg: '����'; No: Integer(mtProcesses_Priority)),
    (Msg: '�߳�'; No: Integer(mtProcesses_Threads)),
    (Msg: '·��'; No: Integer(mtProcesses_Path)),

    (Msg: 'CPU'; No: -1), // Items
    (Msg: 'Registers'; No: Integer(mtCPU_Registers)),
    (Msg: 'ջ'; No: Integer(mtCPU_Stack)),
    (Msg: '�ڴ� Dump'; No: Integer(mtCPU_MemoryDump)),

    (Msg: '��������'; No: -1), // Items
    (Msg: '�ɹ�'; No: Integer(mtSend_SuccessMsg)),
    (Msg: 'ʧ��'; No: Integer(mtSend_FailureMsg)),
    (Msg: 'Bug�ر�'; No: Integer(mtSend_BugClosedMsg)),
    (Msg: 'δ֪����'; No: Integer(mtSend_UnknownErrorMsg)),
    (Msg: '��Ч��¼'; No: Integer(mtSend_InvalidLoginMsg)),
    (Msg: '��Ч����'; No: Integer(mtSend_InvalidSearchMsg)),
    (Msg: '��Ч��ѡ��'; No: Integer(mtSend_InvalidSelectionMsg)),
    (Msg: '��Ч����'; No: Integer(mtSend_InvalidInsertMsg)),
    (Msg: '��Ч�޸�'; No: Integer(mtSend_InvalidModifyMsg)),

    (Msg: '����Ҳ����Ϣ'; No: -1), // Items
    (Msg: '�ļ�����'; No: Integer(mtFileCrackedMsg)),
    (Msg: '����ͷ��쳣'; No: Integer(mtException_LeakMultiFree)),
    (Msg: '�ڴ泬֧�쳣'; No: Integer(mtException_LeakMemoryOverrun)),
    (Msg: 'Anti Freeze�쳣'; No: Integer(mtException_AntiFreeze)),
    (Msg: '��Ч�����ʼ�'; No: Integer(mtInvalidEmailMsg)));

  EText = '�ı�';

  EVals: array[TMessageType] of string =
  ('��Ϣ.', // mtInformationMsgCaption
    '����.', // mtQuestionMsgCaption
    '����.', // mtErrorMsgCaption

    '��������', // mtDialog_Caption
    '����ִ�г����쳣.'#13#10 + // mtDialog_ErrorMsgCaption
    '���Ķ��������ϣ�������һ������ϸ����.',
    '����', // mtDialog_GeneralCaption
    '������Ϣ', // mtDialog_GeneralHeader
    '���ö�ջ', // mtDialog_CallStackCaption
    '���ö�ջ��Ϣ', // mtDialog_CallStackHeader
    'ģ��', // mtDialog_ModulesCaption
    'ģ����Ϣ', // mtDialog_ModulesHeader
    '����', // mtDialog_ProcessesCaption
    '������Ϣ', // mtDialog_ProcessesHeader
    '���', // mtDialog_AsmCaption
    '�����Ϣ', // mtDialog_AsmHeader
    'CPU', // mtDialog_CPUCaption
    'CPU I��Ϣ', // mtDialog_CPUHeader
    'ȷ��', // mtDialog_OKButtonCaption
    '��ֹ', // mtDialog_TerminateButtonCaption
    '����', // mtDialog_RestartButtonCaption
    'ȱʡ', // mtDialog_DetailsButtonCaption
    '����', // mtDialog_CustomButtonCaption
    '���ʹ˴�����������', // mtDialog_SendMessage
    '���Ͻ�ͼ', // mtDialog_ScreenshotMessage
    '���Ƶ����а�', // mtDialog_CopyMessage
    'ȥ��ҳ', // mtDialog_SupportMessage

    'Ӧ����������һ������. ' +
      '���ǶԴ˱�ʾ�ź���Ϊ����.', // mtMSDialog_ErrorMsgCaption
    '��������.', // mtMSDialog_RestartCaption
    '��ֹ����.', // mtMSDialog_TerminateCaption
    '��������һ���ⷽ�������.', // mtMSDialog_PleaseCaption
    '�����Ѿ�������һ�����󱨸棬�����Է��͸�����. ' +
      '���ǽ������ݱ�����Ϊ���ܣ�����������.', // mtMSDialog_DescriptionCaption
    '  ����������ʲô���ݴ��󱨸� ,', // mtMSDialog_SeeDetailsCaption
    '������.', // mtMSDialog_SeeClickCaption
    'ʲô��������ʱ�����ⷢ������ѡ��?', // mtMSDialog_HowToReproduceCaption
    '���������ַ����ѡ��:', // mtMSDialog_EmailCaption
    '���ʹ��󱨸�', // mtMSDialog_SendButtonCaption
    '�����ʹ��󱨸�', // mtMSDialog_NoSendButtonCaption

    'Ӧ�ó���', // mtLog_AppHeader
    '��ʼ����', // mtLog_AppStartingTime
    '����/����', // mtLog_AppName
    '�汾��', // mtLog_AppVersionNumber
    '����', // mtLog_AppParameters
    '��������', // mtLog_AppCompilationDate
    '����ʱ��', // mtLog_AppUpTime

    '�쳣', // mtLog_ExcHeader
    '����', // mtLog_ExcTime
    '��ַ', // mtLog_ExcAddress
    'ģ������', // mtLog_ExcModuleName
    'ģ��汾', // mtLog_ExcModuleVersion
    '����', // mtLog_ExcType
    '��Ϣ', // mtLog_ExcMessage
    'ID', // mtLog_ExcID
    '����', // mtLog_ExcCount
    'װ״', // mtLog_ExcStatus
    '��ע', // mtLog_ExcNote

    '�û�', // mtLog_UserHeader
    'ID', // mtLog_UserID
    '����', // mtLog_UserName
    '�����ʼ�', // mtLog_UserEmail
    '��˾', // mtLog_UserCompany
    '��Ȩ', // mtLog_UserPrivileges

    '�����', // mtLog_ActCtrlsHeader
    '��������', // mtLog_ActCtrlsFormClass
    '�����ı�', // mtLog_ActCtrlsFormText
    '������', // mtLog_ActCtrlsControlClass
    '�����ı�', // mtLog_ActCtrlsControlText

    '�����', // mtLog_CmpHeader
    '����', // mtLog_CmpName
    '�ܼ�������', // mtLog_CmpTotalMemory
    '�ڴ�', // mtLog_CmpFreeMemory
    '��������', // mtLog_CmpTotalDisk
    '���д���', // mtLog_CmpFreeDisk
    'ϵͳʱ��', // mtLog_CmpSystemUpTime
    '������', // mtLog_CmpProcessor
    '��ʾģʽ', // mtLog_CmpDisplayMode
    '��ʾ DPI', // mtLog_CmpDisplayDPI
    '��Ƶ��', // mtLog_CmpVideoCard
    '��ӡ��', // mtLog_CmpPrinter

    '����ϵͳ ', // mtLog_OSHeader
    '����', // mtLog_OSType
    'Build #', // mtLog_OSBuildN
    '����', // mtLog_OSUpdate
    '����', // mtLog_OSLanguage
    '�ַ���', // mtLog_OSCharset

    '����', // mtLog_NetHeader
    'IP��ַ', // mtLog_NetIP
    '����', // mtLog_NetSubmask
    '����', // mtLog_NetGateway
    'DNS 1', // mtLog_NetDNS1
    'DNS 2', // mtLog_NetDNS2
    'DHCP', // mtLog_NetDHCP

    '������Ϣ', // mtLog_CustInfoHeader

    '��ַ', // mtCallStack_Address
    'ģ��', // mtCallStack_Name
    '��Ԫ', // mtCallStack_Unit
    '��', // mtCallStack_Class
    '����/����', // mtCallStack_Procedure
    '��', // mtCallStack_Line

    // Call Stack Thread Data...
    '��', // mtCallStack_MainThread
    '�쳣�߳�', // mtCallStack_ExceptionThread
    '�����е��߳�', // mtCallStack_RunningThread
    '�����õ��߳�', // mtCallStack_CallingThread
    'ID', // mtCallStack_ThreadID
    '����', // mtCallStack_ThreadPriority
    '����', // mtCallStack_ThreadClass

    // Call Stack Leak Data...
    '�ڴ�й©', // mtCallStack_LeakCaption
    '����', // mtCallStack_LeakData
    '����', // mtCallStack_LeakType
    '�ܴ�С', // mtCallStack_LeakSize
    '����', // mtCallStack_LeakCount

    '����.', // mtSendDialog_Caption
    '��Ϣ', // mtSendDialog_Message
    '���ing DNS...', // mtSendDialog_Resolving
    '��½...', // mtSendDialog_Login
    '�������ӵ�������...', // mtSendDialog_Connecting
    '���ӵ�������.', // mtSendDialog_Connected
    '���ڷ�����Ϣ...', // mtSendDialog_Sending
    '��Ϣ����.', // mtSendDialog_Sent
    'ѡ����Ŀ...', // mtSendDialog_SelectProject,
    '������Ѱ...', // mtSendDialog_Searching,
    '�����޸�...', // mtSendDialog_Modifying,
    '���ڶϿ�...', // mtSendDialog_Disconnecting,
    '�Ͽ�.', // mtSendDialog_Disconnected,

    'Ҫ��', // mtReproduceDialog_Caption
    '��˵�����裬�Ը��ƴ���:', // mtReproduceDialog_Request
    'ȷ��', // mtReproduceDialog_OKButtonCaption

    '���', // mtModules_Handle
    '����', // mtModules_Name
    '����', // mtModules_Description
    '�汾', // mtModules_Version
    '��С', // mtModules_Size
    '����', // mtModules_DateModified
    '·��', // mtModules_Path

    'ID', // mtProcesses_ID
    '����', // mtProcesses_Name
    '����', // mtProcesses_Description
    '�汾', // mtProcesses_Version
    '�ڴ�', // mtProcesses_Memory
    '����', // mtProcesses_Priority
    '�߳�', // mtProcesses_Threads
    '·��', // mtProcesses_Path

    'Registers', // mtCPU_Registers
    'ջ', // mtCPU_Stack
    '�ڴ� Dump', // mtCPU_MemoryDump

    '����Ϣ�������ɹ�.', // mtSend_SuccessMsg
    '�Բ��𣬷�����Ϣ��û�й���.', // mtSend_FailureMsg
    '��Щbug�Ǹոչر�.'+ #13#10 +
      '������վȡ�õ��������.', // mtSend_BugClosedMsg
    'δ֪����.', // mtSend_UnknownErrorMsg
    '��Ч��¼����.', // mtSend_InvalidLoginMsg
    '��Ч����������.', // mtSend_InvalidSearchMsg
    '��Ч��ѡ��Ҫ��.', // mtSend_InvalidSelectionMsg
    '������Ч������.', // mtSend_InvalidInsertMsg
    '��Ч���޸�Ҫ��.',  // mtSend_InvalidModifyMsg

    // Other messages
    '����ļ����ƻ�.' + #13#10 +
      '��ֹ��������.', // mtFileCrackedMsg
    '�����ͷ��ڴ�й©.', // mtException_LeakMultiFree
    '�ڴ泬֧й©.', // mtExceptionLeakMemoryOverrun
    'Ӧ�ó����ƺ�������.', // mtExceptionLeakMemoryOverrun
    '��Ч�����ʼ�.'); // mtExceptionLeakMemoryOverrun

  EShowOptions: array[TShowOption] of string = (
    'Ӧ�ó���|��ʼ����',
    'Ӧ�ó���|����',
    'Ӧ�ó���|�汾��',
    'Ӧ�ó���|����',
    'Ӧ�ó���|��������',
    'Ӧ�ó���|����ʱ��',

    '�쳣|����',
    '�쳣|��ַ',
    '�쳣|ģ������',
    '�쳣|ģ��汾',
    '�쳣|����',
    '�쳣|��Ϣ',
    '�쳣|ID',
    '�쳣|����',
    '�쳣|״̬',
    '�쳣|��ע',

    'ʹ��|ID',
    'ʹ��|����',
    'ʹ��|Email',
    'ʹ��|��Ȩ',
    'ʹ��|��˾',

    '�����|��������',
    '�����|�����ı�',
    '�����|��������',
    '�����|�����ı�',

    '�����|����',
    '�����|�ܼ�������',
    '�����|�ڴ�',
    '�����|��������',
    '�����|���д���',
    '�����|ϵͳʱ��',
    '�����|������',
    '�����|��ʾģʽ',
    '�����|��ʾ DPI',
    '�����|��Ƶ��',
    '�����|��ӡ��',

    '����ϵͳ|����',
    '����ϵͳ|Build #',
    '����ϵͳ|����',
    '����ϵͳ|����',
    '����ϵͳ|�ַ���',

    '����|IP ��ַ',
    '����|����',
    '����|����',
    '����|DNS 1',
    '����|DNS 2',
    '����|DHCP',

    'Custom ����|����');

  EVariablesOptions: array[0..25] of string = (
    '_BugReport | ���eurekalog bug����',
    '_ExceptModuleDesc | ����ģ����������һ���쳣',
    '_ExceptModuleName | ģ�������Ѿ���������һ���쳣',
    '_ExceptModuleVer | �汾��ģ�飬��������һ���쳣',
    '_ExceptMsg | ����쳣��Ϣ',
    '_LineBreak | �߳��˳�',
    '_MainModuleDesc | ������ǰ����ģ��',
    '_MainModuleName | ����Ŀǰ����ģ��',
    '_MainModuleVer | �汾Ŀǰ������ģ��',
    'AllUsersProfile | \Documents and Settings\All Users',
    'AppData | \Documents and Settings\{username}\Application Data',
    'CD | ��ǰĿ¼������·��',
    'ComputerName | {computername}',
    'Date | ��ǰ���ڸ�ʽȡ���ڲ���ϵͳ',
    'HomeDrive | ��������homeĿ¼',
    'HomePath | \Documents and Settings\{username}',
    'ProgramFiles | Ŀ¼���г�ʽ����',
    'SystemDrive | ��������������Ŀ¼',
    'SystemRoot | ��Windows��Ŀ¼',
    'Temp | ��ʱĿ¼',
    'Time | ��ǰʱ���ڸ�ʽȡ���ڲ���ϵͳ',
    'Tmp | ��ʱĿ¼',
    'UserDomain | ��ǰ�û�����',
    'UserName | {username}',
    'UserProfile | \Documents and Settings\{username}',
    'WinDir | WindowsĿ¼');

implementation

end.

