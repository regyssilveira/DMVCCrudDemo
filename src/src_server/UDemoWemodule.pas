unit UDemoWemodule;

interface

uses
  System.SysUtils,
  System.Classes,

  Web.HTTPApp,

  MVCFramework;

type
  TDemoWebmodule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TDemoWebmodule;

implementation

{$R *.dfm}

uses
  UPessoaController,

  System.IOUtils,
  System.Generics.Collections,

  MVCFramework.Commons,
  MVCFramework.Middleware.Compression,
  MVCFramework.Server,
  MVCFramework.Server.Impl,
  MVCFramework.Middleware.Authentication;

procedure TDemoWebmodule.WebModuleCreate(Sender: TObject);
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      Config[TMVCConfigKey.SessionTimeout]           := '0';
      Config[TMVCConfigKey.DefaultContentType]       := TMVCConstants.DEFAULT_CONTENT_TYPE;
      Config[TMVCConfigKey.DefaultContentCharset]    := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      Config[TMVCConfigKey.AllowUnhandledAction]     := 'false';
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      Config[TMVCConfigKey.ViewPath]                 := 'templates';
      Config[TMVCConfigKey.MaxEntitiesRecordCount]   := '20';
      Config[TMVCConfigKey.ExposeServerSignature]    := 'true';
      Config[TMVCConfigKey.MaxRequestSize]           := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);

      Config['redis_connection_string']              := '127.0.0.1:6379';
      Config['redis_connection_key']                 := '';
    end);

  FMVC.AddController(TPessoaController);

  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);

  FMVC.AddMiddleware(
    TMVCBasicAuthenticationMiddleware.Create(
      TMVCDefaultAuthenticationHandler.New
      .SetOnAuthentication(
        procedure(const AUserName, APassword: string;
          AUserRoles: TList<string>; var IsValid: Boolean;
          const ASessionData: TDictionary<String, String>)
        begin
          IsValid := AUserName.Equals('admin') and APassword.Equals('admin');
        end
      )
    )
  );
end;

procedure TDemoWebmodule.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
