program DevMaxClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmClientMain},
  DevMax.Types in '..\Type\DevMax.Types.pas',
  DevMax.Types.ViewInfo in '..\Type\DevMax.Types.ViewInfo.pas',
  DevMax.Utils.Marshalling in '..\Utils\DevMax.Utils.Marshalling.pas',
  DevMax.View.Control in '..\View\DevMax.View.Control.pas',
  DevMax.View.Factory in '..\View\DevMax.View.Factory.pas',
  DevMax.View.Manager in '..\View\DevMax.View.Manager.pas',
  DevMax.View in '..\View\DevMax.View.pas',
  DevMax.View.Types in '..\View\DevMax.View.Types.pas',
  DevMax.Service.Manifest in '..\Services\DevMax.Service.Manifest.pas',
  DevMax.DAO.REST.Manifest in '..\DAO\DevMax.DAO.REST.Manifest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmClientMain, frmClientMain);
  Application.Run;
end.
