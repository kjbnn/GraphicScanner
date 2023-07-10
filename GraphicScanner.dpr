library GraphicScanner;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{%ToDo 'GraphicScanner.todo'}

uses
  SysUtils,
  Classes,
  Windows,
  Dialogs,
  Forms,
  IniFiles,
  ShellApi,
  mScanner in 'mScanner.pas' {Scanner};

{$R *.res}
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE MSWINDOWS}

Const
 TestConst = 'Это строка принадлежит DLL.';


Procedure InitLibrary;
begin
  Scanner:= TScanner.Create(nil);
end;


Procedure InitGraphicScanner(Left, Top, Col, Row: word); stdcall;
begin
  Scanner.Init(Left, Top, Col, Row);
end;


Procedure ViewGraphicScanner(Value: boolean); stdcall;
begin
  Scanner.Visible:= Value;
end;


Procedure DrawGraphicScanner(m: array of byte; Num: word; Color: dword); stdcall;
begin
  Scanner.Draw(m, Num, Color);
end;


Procedure TestDLL (TestStr: String); stdcall;
begin
 MessageDlg (TestConst + Chr (13) + Chr (13) + 'Это - аргумент: ' + TestStr, mtInformation, [mbOk], 0);
end;


Exports
 InitGraphicScanner,
 ViewGraphicScanner,
 DrawGraphicScanner,
 TestDLL;

 
begin
 InitLibrary;
end.
