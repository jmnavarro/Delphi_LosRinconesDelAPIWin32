//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: main.pas
//
// Propósito:
//    Formulario principal del proyecto de pruebas con archivos proyectados.
//    Hace uso de las funciones para archivos proyectados del API Win32:
//          . CreateFileMapping
//          · MapViewOfFile
//          · UnMapViewOfFile
//
// Autor:          José Manuel Navarro (jose_manuel_navarro@yahoo.es)
// Fecha:          01/02/2003
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 13 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus;

type

  //
  // Clase TLog
  //
  // Representa las operaciones para manipular la lista de log.
  //
  TTipoLog = (tlMensaje, tlAviso, tlInfo);

  TLog = class(TObject)
  private
    FLista: TListView;

  public
    constructor Create(const ALista: TListView);

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure Clear;

    procedure Add(const texto: string; const tipo: TTipoLog);
  end;


  TProyeccion = class;

  //
  // Notificacion: representa un mensaje que se envía desde una instancia de este programa
  // hasta otra instancia. La notificación se registra en el sistema a través de la función
  // RegisterWindowMessage para asegurarnos de que el mensaje utilizado es único para todas
  // las aplicaciones.
  //
  TNotificacion = class(TObject)
  private
    FLog: TLog;
    FmsgContenido: cardinal;

  public
    constructor Create(const ALog: TLog);

    procedure Registrar;
    procedure Enviar(const hOrigen: HWND);
    procedure Recibir(const msg: TMessage; const Memo: TMemo; const AProyeccion: TProyeccion);

    property msgContenido: cardinal read FmsgContenido;
  end;


  //
  // Clase TProyeccion
  //
  TProyeccion = class(TObject)
  private
    FLog: TLog;

    FhProyeccion: THandle;
    FhVista: PChar;

  public
    constructor Create(const ALog: TLog);
    destructor Destroy; override;

    procedure Abrir;
    procedure Cerrar;
    procedure Actualizar(const Memo: TMemo);

    property hVista: PChar read FhVista;
  end;

  //
  // Ventana principal
  //
  TMainForm = class(TForm)
    Memo1: TMemo;
    cbx_sincronizado: TCheckBox;
    lv_log: TListView;
    p_splitter: TPanel;
    iconos: TImageList;
    pm_log: TPopupMenu;
    Vaciar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure cbx_sincronizadoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cambioContenido(Sender: TObject);
    procedure p_splitterMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Vaciar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    FLog: TLog;
    FNotificacion: TNotificacion;
    FProyeccion: TProyeccion;

    procedure SubClassWndProc(var msg: TMessage);

    procedure ActivarSincronismo(activar: boolean);

    procedure AbrirNuevaInstancia;

  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  ShellAPI;


const
  MAP_NAME = 'Proyección MultiMemo';

  WM_MULTIMEMO_CONTENIDO   = 'WM_MULTIMEMO_CHANGED';


resourcestring
  SErrorProyectando  = 'Error creando la proyeccion "%s".';
  SErrorCreandoVista = 'Error creando la vista.';
  SCaption           = 'MultiMemo - (handle %d)';

  
type
  //
  // Esta estructura se usa para pasar a la función de callback durante la
  // enumeración de ventanas
  //
  PEnumProcParam = ^TEnumProcParam;
  TEnumProcParam = record
    handle:        HWND;
    classname:     array[0..255] of char;
    NumInstancias: integer;
  end;



//
// Esta función corrige un pequeño bug del TListView.
// Cuando se hace un TListview.Scroll y la barra de desplazamiendo horizontal
// está visible, no se consigue haces un scroll hasta el final de la lista.
// Para corregirlo se simula la pulsación de Ctrl+End a través de los mensajes
// correspondientes.
//
procedure EndScroll(handle: HWND);
begin
  // pulsar
  PostMessage(handle, WM_KEYDOWN, VK_CONTROL, 1);
  PostMessage(handle, WM_KEYDOWN, VK_END, 1);
  // liberar
  PostMessage(handle, WM_KEYUP, VK_END, 1);
  PostMessage(handle, WM_KEYDOWN, VK_CONTROL, 1);
end;



//
// Clase TLog
//
constructor TLog.Create(const ALista: TListView);
begin
  inherited Create;

  FLista := ALista;
end;


procedure TLog.BeginUpdate;
begin
  FLista.Items.BeginUpdate;
end;


procedure TLog.EndUpdate;
begin
  FLista.Items.EndUpdate;
end;


procedure TLog.Clear;
begin
  if FLista = nil then
    exit;

  BeginUpdate;
  try
    FLista.Items.Clear;
  finally
    EndUpdate;
  end;
end;


procedure TLog.Add(const texto: string; const tipo: TTipoLog);
var
  item: TListItem;
begin
  if not Assigned(FLista) or (FLista = nil) then
    exit;

  BeginUpdate;
  try
    item := FLista.Items.Add;
    item.Caption := FormatDateTime('hh:nn:ss,zzz', Now);
    item.ImageIndex := Integer(tipo);
    item.SubItems.Text := texto;
    //
    // esto hace que la segunda columna se amplíe hasta la cadena más larga
    //
    FLista.Columns[1].AutoSize := false;
    FLista.Columns[1].AutoSize := true;
    //
    // se va al final de la lista
    //
    EndScroll(FLista.handle);

  finally
    EndUpdate;
  end;
end;



//
// Clase TNotificacion
//
constructor TNotificacion.Create(const ALog: TLog);
begin
  inherited Create;

  FLog := ALog;

  Registrar;
end;


procedure TNotificacion.Registrar;
begin
  //
  // Se registra el mensaje que y se obtiene su identificador
  //
  FmsgContenido := RegisterWindowMessage(WM_MULTIMEMO_CONTENIDO);
  //
  // Informar en el log del mensaje que hemos registrado
  //
  FLog.Add(Format('Mensaje %s (%d) registrado en el sistema.',
              [WM_MULTIMEMO_CONTENIDO, FmsgContenido]), tlInfo);
end;


procedure TNotificacion.Enviar(const hOrigen: HWND);
begin
  //
  // Se envía el mensaje a todas las ventanas
  //
  PostMessage(HWND_BROADCAST, FmsgContenido, hOrigen, 0);
  //
  // Informar en el log
  //
  FLog.Add(Format('Notificación enviada desde %d a todas las aplicaciones.',
              [hOrigen]), tlAviso);
end;


procedure TNotificacion.Recibir(const msg: TMessage;
                                const Memo: TMemo;
                                const AProyeccion: TProyeccion);
begin
  if Assigned(Memo) and Assigned(FLog) and Assigned(AProyeccion) and
     (msg.msg = FmsgContenido) then
  begin
    Memo.Lines.SetText(AProyeccion.hVista);
    //
    // Informar en el log
    //
    FLog.Add(Format('Notificación de contenido recibida desde %d.', [msg.WParam]), tlMensaje);
  end;
end;



//
// Clase TProyeccion
//
constructor TProyeccion.Create(const ALog: TLog);
begin
  inherited Create;

  FhProyeccion := 0;
  FhVista      := nil;

  FLog := ALog;
end;


destructor TProyeccion.Destroy;
begin
  Self.Cerrar;

  inherited;
end;


procedure TProyeccion.Abrir;
var
  mensaje: string;
begin
  if FhProyeccion = 0 then
  begin
    FhProyeccion := CreateFileMapping(
                        $FFFFFFFF,              // en el archivo de paginación
                        nil,                    // seguridad por defecto (no heredable)
                        PAGE_READWRITE,         // lectura/escritura
                        0, 1024 * sizeof(char), // hasta 1023 caracteres
                        MAP_NAME);              // nombre de la proyección

    if FhProyeccion = 0 then
      raise Exception.CreateResFmt(@SErrorProyectando, [MAP_NAME]);


    if GetLastError <> ERROR_ALREADY_EXISTS then
      mensaje := 'Proyección "%s" (%d) creada sobre el archivo de paginación.'
    else
      mensaje := 'Proyección "%s" (%d) abierta sobre el archivo de paginación.';

    //
    // Se informa en el log
    //
    FLog.Add(Format(mensaje, [MAP_NAME, FhProyeccion]), tlInfo);
  end;

  if FhVista = nil then
  begin
    FhVista := MapViewOfFile(
                      FhProyeccion,         // el objeto proyección que hemos creado
                      FILE_MAP_WRITE,       // lectura escritura
                      0, 0,                 // desplazamiento: desde el principio
                      1024 * sizeof(char)); // longitud: hasta el final

    if FhVista = nil then
      raise Exception.CreateRes(@SErrorCreandoVista);

    //
    // informar en el log
    //
    FLog.Add(Format('Vista ($%p) creada sobre la proyección.', [Pointer(FhVista)]), tlInfo);
  end;
end;


procedure TProyeccion.Cerrar;
begin
  if UnMapViewOfFile(FhVista) then
  begin
    FLog.Add(Format('Vista ($%p) cerrada', [Pointer(FhVista)]), tlInfo);
    FhVista := nil;
  end;

  if FhProyeccion <> 0 then
  begin
    CloseHandle(FhProyeccion);
    FhProyeccion := 0;
    FLog.Add(Format('Descriptor del objeto Proyección "%s" (%d) cerrado.',
                [MAP_NAME, FhProyeccion]), tlInfo);
  end;
end;


procedure TProyeccion.Actualizar(const Memo: TMemo);
begin
  //
  // copiar en la vista el contenido del memo
  //
  StrPCopy(FhVista, Memo.Text);
  //
  // Informar en el log
  //
  FLog.Add(Format('Valor de la vista actualizado: "%s"', [FhVista]), tlAviso);
end;



//
// Clase TMainForm
//
procedure TMainForm.SubClassWndProc(var msg: TMessage);
begin
  //
  // Se gestiona el mensaje especial (msgContenido) o llama al procedimiento
  // por defecto.
  //
  if (FNotificacion <> nil) and (msg.Msg = FNotificacion.msgContenido) then
  begin
    //
    // Notificar sólo si lo envían desde otra ventana
    //
    if HWND(msg.WParam) <> Self.handle then
    begin

      //
      // Se desactiva el evento para no re-enviar los cambios.
      //
      Memo1.OnChange := nil;
      try
        FNotificacion.Recibir(msg, Memo1, FProyeccion);
      finally
        Memo1.OnChange := CambioContenido;
      end;

    end;
  end
  else
    //
    // Se llama al prodecimiento de ventana normal
    //
    WndProc(msg);
end;



procedure TMainForm.ActivarSincronismo(activar: boolean);
begin
  if activar then
  begin
    //
    // Establecer la subclasificación del procedimiento de ventana.
    // Esto es uno de los sistemas para interceptar ciertos mensajes especiales
    // (en nuestro caso el mensaje de notificación)
    //
    Self.WindowProc := SubClassWndProc;
    //
    // Se crea y abre la protección
    //
    FProyeccion.Abrir;
    //
    // nos enviamos a nosotros mismos una notificación de que leamos el valor de la vista.
    //
    SendMessage(self.handle, FNotificacion.msgContenido, 0, 0);
  end
  else
  begin
    //
    // Establecer la subclasificación por defecto
    //
    Self.WindowProc := WndProc;
    //
    // Se cierra la proteyección
    //
    FProyeccion.Cerrar;
  end;
end;


procedure TMainForm.AbrirNuevaInstancia;
begin
  //
  // Crear un nuevo proceso independiente.
  //
  // Se utiliza ShellExecute para que el proceso sea independiente, poeque
  // si utilizásemos CreateProcess, estaríamos creando un proceso hijo, y este
  // no sería independiente.
  //
  ShellExecute(0, nil, PChar(Application.ExeName), nil, nil, SW_SHOWDEFAULT);
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  //
  // Crear los objetos asociados
  //
  FLog          := TLog.Create(lv_log);
  FNotificacion := TNotificacion.Create(FLog);
  FProyeccion   := TProyeccion.Create(FLog);
  //
  // Comenzamos con el sincronismo activo
  //
  ActivarSincronismo(true);

  Self.Caption := Format(LoadResString(@SCaption), [handle]);
end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  // Liberar los objetos asociados
  //
  FreeAndNil(FProyeccion);
  FreeAndNil(FNotificacion);
  FreeAndNil(FLog);
end;


procedure TMainForm.cbx_sincronizadoClick(Sender: TObject);
begin
  ActivarSincronismo(cbx_sincronizado.checked);
end;


procedure TMainForm.cambioContenido(Sender: TObject);
begin
  if cbx_sincronizado.checked and (FProyeccion.hVista <> nil) then
  begin
    FLog.BeginUpdate;
    try
      FProyeccion.Actualizar(Memo1);
      FNotificacion.Enviar(self.handle);
    finally
      FLog.EndUpdate;
    end;
  end;
end;


procedure TMainForm.p_splitterMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (p_splitter.top + y <> p_splitter.top) then
  begin
    p_splitter.top := p_splitter.top + y;
    memo1.height   := p_splitter.top - 3;
    lv_log.SetBounds(lv_log.left, p_splitter.top + 5,
                     lv_log.width, height - p_splitter.top - 62);
  end;

end;


procedure TMainForm.Vaciar1Click(Sender: TObject);
begin
  FLog.Clear;
end;


//
// Función Callback para el EnumWindows
//
function ContarInstanciasProc(hWin: HWND; lp: LPARAM): boolean; stdcall;
const
  MAX_CLASSNAME = 255;
var
  param: PEnumProcParam;
  classname: array[0..MAX_CLASSNAME] of char;
begin
  param := PEnumProcParam(lp);

  result := true;
  if param^.handle <> hWin then
  begin
    GetClassName(hWin, classname, MAX_CLASSNAME);

    if StrComp(classname, param^.classname) = 0 then
    begin
      Inc(param^.NumInstancias);
      result := false;
    end;
  end;
end;


procedure TMainForm.FormShow(Sender: TObject);

var
  param: PEnumProcParam;
begin
  param := AllocMem(sizeof(TEnumProcParam));
  try
    //
    // Inicializamos los valores del parámetro, y enumeramos todas las ventanas.
    // Por cada ventana que esté abierta en el sistema, se lanzará una vez la función ,
    //
    param^.handle    := self.handle;
    StrPCopy(param^.classname, self.ClassName);

    EnumWindows(@ContarInstanciasProc, Integer(param));

    if param^.NumInstancias = 0 then
      AbrirNuevaInstancia;

  finally
    FreeMem(param, sizeof(TEnumProcParam));
  end;
end;


end.
