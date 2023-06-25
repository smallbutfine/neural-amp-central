unit neural;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, process, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, RTTICtrls, RichMemo, Zipper, Processutils;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MemConsole: TRichMemo;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem7: TMenuItem;
    NAMButton: TButton;
    procedure NAMButtonClick(Sender: TObject);

  private

  public
    procedure ProcessOutput(Sender:TProcessEx; output:string);
    procedure ProcessError(Sender:TProcessEx; {%H-}IsException:boolean);

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }


 procedure TMainForm.NAMButtonClick(Sender: TObject);

 var
   Proc: TProcessEx;
   namrunner:TextFile;
 begin
   //StartProcessAndStreamStdioToMemo('NAM-Runner.bat',MemConsole)
   AssignFile(namrunner, 'NAM-Runner060.bat');
  // Try
   Rewrite(namrunner);
   Writeln(namrunner,'');//Remember AnsiStrings are case sensitive
   Writeln(namrunner,'@echo off');
   Writeln(namrunner,'set NAMNAME=neural-amp-modeler-0.6.0');
   Writeln(namrunner,'set NAMVER=0.6.0');
   Writeln(namrunner,'if exist "%~dp0\%NAMNAME%\installed.txt" (');
   Writeln(namrunner,'echo NAM already installed!');
   Writeln(namrunner,'GOTO NAMISINSTALLED');
   Writeln(namrunner,')');
   Writeln(namrunner,'echo This program is downloading and installing the complete NAM modelling environment and all prerequisites and runtimes.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo PLEASE BE PATIENT.');
   Writeln(namrunner,'echo SOME PARTS OF THIS INSTALLATION PROCESS CAN TAKE QUITE SOME TIME!');
   Writeln(namrunner,'echo DON''T CLOSE THIS WINDOW UNTIL YOU ARE ASKED TO DO IT.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo Downloading and extracting Python archive...');
   Writeln(namrunner,'curl -L https://github.com/winpython/winpython/releases/download/6.1.20230527/Winpython64-3.10.11.1dot.exe -o python.exe');
   Writeln(namrunner,'if exist "%~dp0\%NAMNAME%" rmdir /q "%~dp0\%NAMNAME%"');
   Writeln(namrunner,'python.exe -y');
   Writeln(namrunner,'@echo. |call %~dp0\WPy64-310111\scripts\make_winpython_movable.bat');
   Writeln(namrunner,'move /Y "%~dp0\WPy64-310111\python-3.10.11.amd64" "%NAMNAME%"');
   Writeln(namrunner,'echo Removing Python archive and unused files...');
   Writeln(namrunner,'del /f /s /q "%~dp0\WPy64-310111" 1>nul');
   Writeln(namrunner,'rmdir /s /q "%~dp0\WPy64-310111"');
   Writeln(namrunner,'del python.exe');
   Writeln(namrunner,'echo Done.');
   Writeln(namrunner,'cd %NAMNAME%');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'set PYTHONPATH=%~dp0\%NAMNAME%;%~dp0\%NAMNAME%\DLLs;%~dp0\%NAMNAME%\lib;%~dp0\%NAMNAME%\lib\plat-win;%~dp0\%NAMNAME%\lib\site-packages');
   Writeln(namrunner,'set PATH=%~dp0%NAMNAME%;%~dp0%NAMNAME%\Scripts;%PATH%');
   Writeln(namrunner,'echo Upgrading PIP...');
   Writeln(namrunner,'python.exe -m pip install --upgrade pip');
   Writeln(namrunner,'echo Done.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo Installing NAM...');
   Writeln(namrunner,'python -m pip install neural-amp-modeler==%NAMVER%');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo Installing torch gpu...');
   Writeln(namrunner,'pip3 install scipy==1.10.1');
   Writeln(namrunner,'pip3 install torch torchvision torchaudio --force-reinstall --index-url https://download.pytorch.org/whl/cu118');
   Writeln(namrunner,'echo Done.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'>"%~dp0%NAMNAME%\installed.txt" echo done');
   Writeln(namrunner,'echo NAM install done.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,':NAMISINSTALLED');
   Writeln(namrunner,'set PYTHONPATH=%~dp0\%NAMNAME%;%~dp0\%NAMNAME%\DLLs;%~dp0\%NAMNAME%\lib;%~dp0\%NAMNAME%\lib\plat-win;%~dp0\%NAMNAME%\lib\site-packages');
   Writeln(namrunner,'set PATH=%~dp0%NAMNAME%;%~dp0%NAMNAME%\Scripts;%PATH%');
   Writeln(namrunner,'python -c "from winpython import wppm;dist=wppm.Distribution(r''%~dp0\%NAMNAME%'');dist.patch_standard_packages(''pip'', to_movable=True)"');
   Writeln(namrunner,'nam');
   Writeln(namrunner,'');
   Writeln(namrunner,'cd..');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'echo.');
   Writeln(namrunner,'::echo This window can now be closed.');
   Writeln(namrunner,'echo In case something went wrong or the installation got corrupted:');
   Writeln(namrunner,'echo You can simply delete the folder %NAMNAME% and try a reinstall.');
   Writeln(namrunner,'echo Note, that a reinstallation needs an internet connection.');
   Writeln(namrunner,'echo Thank you.');
   //Finally
   CloseFile(namrunner);
   //End;

   try
   Proc := TProcessEx.Create(nil);
   Proc.Executable := 'NAM-Runner060.bat';
   Proc.OnErrorM:=@(ProcessError);
   Proc.OnOutputM:=@(ProcessOutput);
   Proc.Execute();
   finally
     Proc.Free;
   end;
   DeleteFile('NAM-Runner060.bat');
 end;


 procedure TMainForm.ProcessError(Sender: TProcessEx; IsException: boolean);
 begin
    MemConsole.Lines.Append('Erreur ! ' + Sender.ExceptionInfo);
 end;

 procedure TMainForm.ProcessOutput(Sender: TProcessEx; output : String);
 begin
  MemConsole.Lines.Text :=  MemConsole.Lines.Text + output;
   // si vous avez des problème d'accent
   //MemConsole.Lines.Text := MemConsole.Lines.Text + ConsoleToUtf8(output);
   // pour scroll automatique
   MemConsole.SelStart := Length(MemConsole.Lines.Text)-1;
   MemConsole.SelLength:=0;
   Application.ProcessMessages;
 end;

end.

