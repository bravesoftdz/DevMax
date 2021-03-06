program TestViewItem;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  ViewItemBasicTest in 'ViewItemBasicTest.pas',
  ViewItemTestForm in 'ViewItemTestForm.pas' {frmViewItem},
  DevMax.VIewItem.ToolbarRightButton in '..\..\Source\ViewItem\DevMax.VIewItem.ToolbarRightButton.pas' {ToolbarRightButton: TFrame},
  DevMax.ViewItem.ListBox in '..\..\Source\ViewItem\DevMax.ViewItem.ListBox.pas' {frListBox: TFrame},
  DevMax.ViewItem.ListBoxItem in '..\..\Source\ViewItem\DevMax.ViewItem.ListBoxItem.pas',
  DevMax.View in '..\..\Source\View\DevMax.View.pas',
  DevMax.View.Types in '..\..\Source\View\DevMax.View.Types.pas',
  DevMax.View.Factory in '..\..\Source\View\DevMax.View.Factory.pas',
  DevMax.View.Manager in '..\..\Source\View\DevMax.View.Manager.pas',
  DevMax.Types in '..\..\Source\Type\DevMax.Types.pas',
  DevMax.Types.ViewInfo in '..\..\Source\Type\DevMax.Types.ViewInfo.pas',
  TestViewInfoData in '..\Datas\TestViewInfoData.pas',
  ViewManagerTest in 'ViewManagerTest.pas',
  DevMax.ViewItem.Test in '..\..\Source\ViewItem\DevMax.ViewItem.Test.pas' {Frame1: TFrame},
  DevMax.View.Control in '..\..\Source\View\DevMax.View.Control.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}

  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
