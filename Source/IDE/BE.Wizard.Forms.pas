unit BE.Wizard.Forms;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  BE.Commands.Interfaces, Vcl.ComCtrls, ToolsAPI, BE.Model;

type
  TBEWizardForms = class(TForm)
    pnlBottom: TPanel;
    btnInstall: TButton;
    btnUpdate: TButton;
    btnUninstall: TButton;
    Label3: TLabel;
    edtHostLogin: TComboBox;
    Label1: TLabel;
    edtDependency: TEdit;
    Label2: TLabel;
    edtVersion: TEdit;
    lstHistory: TListBox;
    btnLogin: TButton;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnUninstallClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure lstHistoryClick(Sender: TObject);
  private
    FProject: IOTAProject;
    FBossCommand: IBECommands;

    procedure DoRefresh;

    function GetDependency: TBEModelDependency;
    { Private declarations }
  public
    constructor create(AOwner: TComponent; BossCommand: IBECommands; Project: IOTAProject); reintroduce;
    { Public declarations }
  end;

var
  BEWizardForms: TBEWizardForms;

implementation

{$R *.dfm}

procedure TBEWizardForms.btnInstallClick(Sender: TObject);
var
  dependency: TBEModelDependency;
begin
  dependency := GetDependency;
  try
    FBossCommand.Install(dependency, Self.DoRefresh);
  finally
    dependency.Free;
  end;
end;

procedure TBEWizardForms.btnLoginClick(Sender: TObject);
begin
  FBossCommand.Login(edtHostLogin.Text);
end;

procedure TBEWizardForms.btnUninstallClick(Sender: TObject);
var
  dependency: TBEModelDependency;
begin
  dependency := GetDependency;
  try
    FBossCommand.Uninstall(dependency, Self.DoRefresh);
  finally
    dependency.Free;
  end;
end;

procedure TBEWizardForms.btnUpdateClick(Sender: TObject);
var
  dependency: TBEModelDependency;
begin
  dependency := GetDependency;
  try
    FBossCommand.Update(dependency, Self.DoRefresh);
  finally
    dependency.Free;
  end;
end;

constructor TBEWizardForms.create(AOwner: TComponent; BossCommand: IBECommands; Project: IOTAProject);
begin
  inherited create(AOwner);
  FBossCommand := BossCommand;
  FProject := Project;
end;

procedure TBEWizardForms.DoRefresh;
begin
  if Assigned(FProject) then
    FProject.Refresh(True);
end;

procedure TBEWizardForms.FormShow(Sender: TObject);
var
  theme: IOTAIDEThemingServices250;
  i: Integer;
begin
  theme := (BorlandIDEServices as IOTAIDEThemingServices250);
  theme.RegisterFormClass(TBEWizardForms);

  for i := 0 to Pred(Self.ComponentCount) do
  begin
    if Components[i] is TLabel then
      theme.ApplyTheme(TLabel(Components[i]));

    if Components[i] is TComboBox then
      theme.ApplyTheme(TComboBox(Components[i]));
  end;
end;

function TBEWizardForms.GetDependency: TBEModelDependency;
begin
  result := TBEModelDependency.create(edtDependency.Text, edtVersion.Text);
end;

procedure TBEWizardForms.lstHistoryClick(Sender: TObject);
begin
  edtDependency.Text := lstHistory.Items[lstHistory.ItemIndex];
end;

end.
