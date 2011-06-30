unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TMainForm = class(TForm)
    rb_prueba_1: TRadioButton;
    rb_prueba_2: TRadioButton;
    rb_prueba_3: TRadioButton;
    b_ejecutar: TButton;
    l_info: TLabel;
    m_info: TMemo;
    bv_1: TBevel;
    b_salir: TButton;
    lb_log: TListBox;
    l_log: TLabel;
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    l_jm: TLabel;
    procedure rb_prueba_1Click(Sender: TObject);
    procedure rb_prueba_2Click(Sender: TObject);
    procedure rb_prueba_3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure b_salirClick(Sender: TObject);
    procedure l_jmClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    procedure Prueba_1(Sender: TObject);
    procedure Prueba_2(Sender: TObject);
    procedure Prueba_3(Sender: TObject);

    procedure Log(const str: string; const cabecera: boolean = true);

  end;

var
  MainForm: TMainForm;

implementation
{$R *.DFM}

uses ShellAPI;

type
  PMiEstructura = ^MiEstructura;
  MiEstructura = record
    Dato1: array[0..2047] of char;    { 2048 * 1     = 2048 bytes	}
    Dato2: integer;                   { 32 bits			 =    4 bytes }
    Dato3: array[1..100] of integer;  { 100 * 4      =  400 bytes	}
    Dato4: array[1..100] of Pointer;  { 100 * 4      =  400 bytes	}
    Dato5: array[0..1023] of PChar;   { 1024 * 4     = 4096 bytes	}
  end;                                { Tamaño total = 6948 bytes	}

const
  MSG_PRUEBAS: array[1..3] of PChar =
    ('En esta prueba se reserva un bloque de 34.740 bytes, pero no se compromete. ' +
     'Al intentar almacenar datos en este bloque se producirá una violación de acceso ya ' +
     'que es obligatorio comprometer espacio físico.',

     'En esta prueba se reserva un bloque de 34.740 bytes y se compromete espacio para la ' +
     'primera estructura del este bloque (los primeros 6.948 bytes).'#13#10 +
     'Al intentar acceder a la primera estructura no habrá ningún problema, pero al acceder '+
     'a la tercera se producirá una violación de acceso porque aún no hemos comprometido '+
     'almacenamiento físico para esa región.',

     'En esta última prueba reservamos la misma región de memoria (de 34.740 bytes) y ' +
     'pedimos compromiso físico para la primera estructura. Después hacemos las operación de ' +
     'limpieza: des-compromiso (MEM_DECOMMIT) y liberación (MEM_RELEASE)');


//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.Prueba_1(Sender: TObject);
var
  P: PMiEstructura;
begin
  Log(' - Inicio de Prueba 1 -', false);

  p := PMiEstructura(VirtualAlloc(nil, 5 * sizeof(MiEstructura), MEM_RESERVE, PAGE_NOACCESS));
  Log('Reservado bloque de ' + FormatFloat('#', 5 * sizeof(MiEstructura)) + ' bytes.');

  MessageBox(GetActiveWindow,
             PChar('El bloque de ' + IntToStr(sizeof(MiEstructura) * 5) + 'bytes ha sido ' +
             'reservado a partir de la posición de memoria ' + Format('0x%p', [p]) + '.'#13 +
             'La siguiente línea ejecutada producirá un Acces Violation, ya que el bloque ' +
             'de memoria ha sido reservado pero no comprometido.'),
             'Prueba 1: VirtualAlloc', MB_ICONINFORMATION);

  try
    Log(Format('Intento de escribir en la posición 0x%p.', [p]));
    StrPCopy(p^.Dato1, 'este es el primer dato en Pascal');
  except

    on e: EAccessViolation do
    begin
      Log('Excepción: ' + e.message);
      MessageBox(GetActiveWindow, PChar(e.message), 'Excepción capturada', MB_ICONSTOP);
    end;

  end;

  rb_prueba_2.checked := true;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.Prueba_2(Sender: TObject);
var
  P: PMiEstructura;
  PInicial: PMiEstructura;
begin
  Log(' - Inicio de Prueba 2 -', false);

  p := PMiEstructura(VirtualAlloc(nil, 5 * sizeof(MiEstructura), MEM_RESERVE, PAGE_NOACCESS));
  Log('Reservado bloque de ' + FormatFloat('#', 5 * sizeof(MiEstructura)) + ' bytes.');

  VirtualAlloc(p, sizeof(MiEstructura), MEM_COMMIT, PAGE_READWRITE);
  Log('Comprometido bloque de ' + FormatFloat('#', sizeof(MiEstructura)) + ' bytes a partir '+
      'de la dirección ' + Format('0x%p', [p]) + '.');

  MessageBox(GetActiveWindow,
             PChar('Ahora el acceso al bloque de memoria funcionará correctamente porque se ' +
             'ha comprometido espacio para la primera de las estructuras reservadas (' +
             IntToStr(sizeof(MiEstructura)) + ' bytes).'),
             'Prueba 2: VirtualAlloc', MB_ICONINFORMATION);

  StrPCopy(p^.Dato1, 'este es el primer dato en Pascal');
  Log(Format('Grabado dato en la posición 0x%p.', [p]));

  MessageBox(GetActiveWindow, p^.Dato1, 'Prueba 2: Dato grabado', MB_ICONINFORMATION);

  // guardamos un puntero al inicio del bloque
  PInicial := p;

  // nos desplazamos dos estructuras más adelante (hasta apuntar a la tercera)
  Inc(p, 2);

  MessageBox(GetActiveWindow,
             PChar('Sin embargo si intentamos grabar en la tercera estructura (la que se ' +
             'sitúa a partir de la posición de memoria ' + Format('0x%p', [p]) + '), se ' +
             'producirá de nuevo la violación de acceso porque sólo hemos comprometido el ' +
             'rango de memoria de la primera estructura (desde ' + Format('0x%p', [PInicial]) +
             ' hasta ' + Format('0x%p', [Pointer(Integer(p)-1)]) + '.'),
             'Prueba 2: VirtualAlloc', MB_ICONINFORMATION);

  try
    Log(Format('Intento de escribir en la posición 0x%p (tercera estructura).', [p]));
    StrPCopy(p^.Dato1, 'intentamos grabar un dato');

  except
    on e: EAccessViolation do
    begin
      Log('Excepción: ' + e.message);
      MessageBox(GetActiveWindow, PChar(e.message), 'Excepción capturada', MB_ICONSTOP);
    end;

  end;

  rb_prueba_3.checked := true;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.Prueba_3(Sender: TObject);
var
  P: PMiEstructura;
begin
  Log(' - Inicio de Prueba 2 -', false);

  p := PMiEstructura(VirtualAlloc(nil, 5 * sizeof(MiEstructura), MEM_RESERVE, PAGE_NOACCESS));
  Log('Reservado bloque de ' + FormatFloat('#', 5 * sizeof(MiEstructura)) + ' bytes.');

  try
    VirtualAlloc(p, sizeof(MiEstructura), MEM_COMMIT, PAGE_READWRITE);
    Log('Comprometido bloque de ' + FormatFloat('#', sizeof(MiEstructura)) + ' bytes a partir '+
        'de la dirección ' + Format('0x%p', [p]) + '.');

    try
      StrPCopy(p^.Dato1, 'este es el primer dato en Pascal');
      Log(Format('Grabado dato en la posición 0x%p.', [p]));

      MessageBox(GetActiveWindow, p^.Dato1, 'Prueba 3: Dato grabado', MB_ICONINFORMATION);

    finally

      if VirtualFree(p, sizeof(MiEstructura), MEM_DECOMMIT) then
      begin
        Log('Des-comprometido bloque de ' + FormatFloat('#', sizeof(MiEstructura)) +
            ' bytes a partir de la dirección ' + Format('0x%p', [p]) + '.');

        MessageBox(GetActiveWindow,
                   'La primera de las estructuras ha sido des-comprometida correctamente.',
                   'Prueba 3: VirtualFree', MB_ICONINFORMATION);
      end;
    end;

  finally

    if VirtualFree(p, sizeof(MiEstructura), MEM_DECOMMIT) then
    begin
      Log('Liberado bloque de ' + FormatFloat('#', 5 * sizeof(MiEstructura)) +
          ' bytes a partir de la dirección ' + Format('0x%p', [p]) + '.');

      MessageBox(GetActiveWindow,
                 PChar('El bloque completo de memoria (' + IntToStr(5 * sizeof(MiEstructura)) +
                 ' bytes) ha sido liberado.'),
                 'Prueba 3: VirtualFree', MB_ICONINFORMATION);
    end;

  end;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.rb_prueba_1Click(Sender: TObject);
begin
  m_info.text        := MSG_PRUEBAS[1];
  l_info.caption     := TRadioButton(Sender).Caption;
  b_ejecutar.OnClick := Prueba_1;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.rb_prueba_2Click(Sender: TObject);
begin
  m_info.text        := MSG_PRUEBAS[2];
  l_info.caption     := TRadioButton(Sender).Caption;
  b_ejecutar.OnClick := Prueba_2;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.rb_prueba_3Click(Sender: TObject);
begin
  m_info.text        := MSG_PRUEBAS[3];
  l_info.caption     := TRadioButton(Sender).Caption;
  b_ejecutar.OnClick := Prueba_3;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.FormCreate(Sender: TObject);
begin
  rb_prueba_1.Checked := true;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.b_salirClick(Sender: TObject);
begin
  Self.Close;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.Log(const str: string; const cabecera: boolean = true);
begin
  if cabecera then
    lb_log.Items.Add(Format('%d.- (%s) %s', [lb_log.Items.Count + 1, FormatFloat('#,', GetTickCount), str]))
  else
    lb_log.Items.Add(Format('%s', [str]));

  lb_log.TopIndex  := lb_log.Items.Count - 1;
  lb_log.ItemIndex := lb_log.Items.Count - 1;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.l_jmClick(Sender: TObject);
begin
  ShellExecute(GetActiveWindow, nil, 'mailto:jose.manuel@iespana.es', nil, nil, SW_NORMAL);
  l_jm.Font.Color := clPurple;
end;

procedure TMainForm.Label2Click(Sender: TObject);
begin
  ShellExecute(GetActiveWindow, nil, 'http://www.lawebdejm.com', nil, nil, SW_NORMAL);
  Label2.Font.Color := clPurple;
end;

end.
