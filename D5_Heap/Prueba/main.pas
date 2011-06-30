//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: main.pas
//
// Propósito:
//    Formulario principal del proyecto de pruebas con montones.
//    Hace uso de las clases definidas en Heap.pas.
//
// Autor:          José Manuel Navarro (jose_manuel_navarro@yahoo.es)
// Fecha:          01/12/2002
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 12 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type

  TMainForm = class(TForm)
    l_info: TLabel;
    l_log: TLabel;
    i_icono: TImage;
    l_jm: TLabel;
    rb_THeap: TRadioButton;
    rb_heapAPI: TRadioButton;
    rb_THeapList: TRadioButton;
    b_ejecutar: TButton;
    m_info: TMemo;
    b_salir: TButton;
    lb_log: TListBox;
    bv: TBevel;
    b_montones: TButton;
    b_InfoMem: TButton;
    procedure l_jmClick(Sender: TObject);
    procedure rb_heapAPIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rb_THeapClick(Sender: TObject);
    procedure rb_THeapListClick(Sender: TObject);
    procedure b_salirClick(Sender: TObject);
    procedure b_montonesClick(Sender: TObject);
    procedure b_InfoMemClick(Sender: TObject);
  private
    procedure Info(const str: PChar);
    procedure Log(const str: string; const cabecera: boolean = false);
    procedure LogMontonesProceso(indentacion: integer);

    procedure PruebaAPI(sender: TObject);
    procedure PruebaTHeap(sender: TObject);
    procedure PruebaTHeapList(sender: TObject);
  end;

implementation

{$R *.DFM}

uses Heap, ShellAPI;

type
  PDatos = ^TDatos;
  TDatos = record
    nombre:    ShortString;
    apellidos: ShortString;
    edad:      integer;
  end;

const
  MSG_PRUEBAS: array[1..3] of PChar =
    ('Se hace uso de la funciones del API Win32 para crear un montón, reservar un bloque de ' +
     'memoria y almacenar datos en él.' + #13 +
     'Los pasos que se dan son: ' + #13 +
     '    1.- Crear un montón a través de la función HeapCreate.' + #13 +
     '    2.- Reservar un bloque de memoria dentro de ese montón, a través de la función HeapAlloc.' + #13 +
     '    3.- Almacenar un registro de tipo TDatos en el bloque reservado (a través de un puntero).' + #13 +
     '    4.- Mostrar los datos del registro almacenado.' + #13 +
     '    5.- Liberar el bloque del montón a través de la función HeapFree.' + #13 +
     '    6.- Destruir el montón a través de la función HeapDestroy.',

     'Se hace uso de las clase THeap y THeapBlock para crear un montón, reservar bloque de memoria y almacenar datos en él.' + #13 +
     'Los pasos que se dan son: ' + #13 +
     '    1.- Crear un objeto de tipo THeap, que crea un nuevo montón a través de la función HeapCreate.' + #13 +
     '    2.- Reservar un bloque de memoria creando un objeto de tipo THeapBlock.' + #13 +
     '    3.- Almacenar un registro de tipo TDatos en el bloque reservado (a través del puntero THeapBlock.Memory).' + #13 +
     '    4.- Mostrar los datos del registro almacenado.' + #13 +
     '    5.- Destruir el objeto THeap, liberando así el montón y todos los objetos de tipo THeapBlock que contenga.',

     'Se hace una demostración del uso de la clase THeapList, que almacena variables de tipo Pointer en un montón dedicado.' + #13 +
     '    1.- Crear una lista de tipo THeapList.' + #13 +
     '    2.- Reservar dos bloques de memoria dentro del mismo montón de la lista.' + #13 +
     '    3.- Almacenar dos registro de tipo TDatos en los bloques reservados.' + #13 +
     '    4.- Mostrar los datos de los registros almacenados.' + #13 +
     '    5.- Destruir la lista.');


//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.Info(const str: PChar);
  procedure SetPrimeraLinea(const str: PChar);
  var
    aux: PChar;
    buff: array[0..255] of char;
  begin
    aux := StrPos(str, #13);
    if aux = nil then
      m_info.Lines.Add(str)
    else
    begin
      StrLCopy(@buff, str, aux - str);
      SetPrimeraLinea(@buff);

      Inc(aux);
      SetPrimeraLinea(aux);
    end;
  end;
begin
  m_info.Lines.Clear;
  SetPrimeraLinea(str);
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.Log(const str: string; const cabecera: boolean);
begin
  if cabecera then
    lb_log.Items.Add(Format('%d.- (%s) %s', [lb_log.Items.Count + 1, FormatFloat('#,', GetTickCount), str]))
  else
    lb_log.Items.Add(Format('%s', [str]));

  lb_log.TopIndex  := lb_log.Items.Count - 1;
  lb_log.ItemIndex := lb_log.Items.Count - 1;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.LogMontonesProceso(indentacion: integer);
var
	vector:					PHandle;
	PtrIterar:			PHandle;
	i:							LongWord;
	NumeroMontones:	LongWord;
	DescMonton:			AnsiString;
  tab:            AnsiString;
begin
	// para evitar el warning
	vector := nil;

  // tab es la cadena de indentación
  tab := StringOfChar(' ', indentacion);

	// obtener el número total de montones
	NumeroMontones := GetProcessHeaps(0, vector^);

  Log(tab + 'Número de montones: ' + IntToStr(NumeroMontones));

	// crear un vector dinámico a través de punteros (al estilo C)
	// y se inicializa con ceros
	vector := AllocMem(sizeof(THandle) * NumeroMontones);

	// se obtienen la lista de descriptores
	GetProcessHeaps(NumeroMontones, vector^);

  tab := StringOfChar(' ', indentacion * 2 );

	PtrIterar := vector;
	for i := 0 to NumeroMontones - 1 do
	begin
		if i = 0 then
			DescMonton := Format('%s%s: $%x', [tab, 'Handle montón por defecto', PtrIterar^])
		else
			DescMonton := Format('%s%s %d: $%x', [tab, 'Handle montón número ', i, PtrIterar^]);

		Log(DescMonton);

		Inc(PtrIterar); // se incrementa el puntero al siguiente descriptor
	end;

	// se libera la memoria asignada dinámicamente (en el montón).
	FreeMem(vector);

end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.PruebaAPI(sender: TObject);
const
  HEAP_SIZE = 1024 * 64;

var
  hMonton: THandle;
  datos: PDatos;

begin
  if lb_log.Items.Count > 0 then
    Log('');
  Log('- Inicio de prueba con API -');
  Log('');

  LogMontonesProceso(4);

  Log('');
  Log('    Se crea un montón con HeapCreate');
  Log('');

  hMonton := HeapCreate(HEAP_NO_SERIALIZE, HEAP_SIZE, HEAP_SIZE);
  try
    LogMontonesProceso(4);
    Log('');

    Log('    Se crea un bloque de memoria con HeapAlloc');
    datos := HeapAlloc(hMonton,
                       HEAP_NO_SERIALIZE or HEAP_ZERO_MEMORY,
                       sizeof(TDatos));
    try
      Log(Format('    %s %x', ['La memoria del HeapBlock reside en $', Integer(datos)]));
      Log('');

      datos^.nombre    := 'Juancito';
      datos^.apellidos := 'Pérez Pí';
      datos^.edad      := 13;

      Log('    Datos en el montón:');
      Log('        Nombre = "' + datos.nombre + '"');
      Log('        Apellidos = "' + datos.apellidos + '"');
      Log('        Edad = ' + IntToStr(datos.edad));
      Log('');

    finally
      Log('    Se libera el bloque con HeapFree');
      Log('');
      HeapFree(hMonton, HEAP_NO_SERIALIZE, datos);
    end;

  finally
    Log('    Se destruye el montón con HeapDestroy');
    Log('');
    HeapDestroy(hMonton);

    LogMontonesProceso(4);
  end;

end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.PruebaTHeap(sender: TObject);
var
  monton: THeap;
  bloque: THeapBlock;
  datos: PDatos;
begin
  if lb_log.Items.Count > 0 then
    Log('');
  Log('- Inicio de prueba con THeap -');
  Log('');

  LogMontonesProceso(4);
  Log('');

  monton := THeap.Create;
  try
    Log(Format('    Se crea un objeto THeap (handle = $%x)', [monton.handle]));
    Log('');

    LogMontonesProceso(4);

    Log('');
    Log('    Se crea un objeto THeapBlock');
    bloque := monton.Allocate(sizeof(TDatos));
    Log(Format('    %s %x', ['La memoria del HeapBlock reside en $', Integer(bloque.Memory)]));
    Log('');

    datos  := bloque.Memory;

    datos^.nombre    := 'Juancito';
    datos^.apellidos := 'Pérez Pí';
    datos^.edad      := 13;

    Log('    Datos en el montón:');
    Log('        Nombre = "' + PDatos(bloque.Memory)^.nombre + '"');
    Log('        Apellidos = "' + PDatos(bloque.Memory)^.apellidos + '"');
    Log('        Edad = ' + IntToStr(PDatos(bloque.Memory)^.edad));
    Log('');

  finally
    Log('    Se libera el objeto THeap');
    Log('');
    monton.Free;

    LogMontonesProceso(4);
  end;

end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.PruebaTHeapList(sender: TObject);
var
  lista: THeapList;

  bloque_1: THeapBlock;
  bloque_2: THeapBlock;

  datos: PDatos;

  i: integer;

begin
  if lb_log.Items.Count > 0 then
    Log('');
  Log('- Inicio de prueba con THeapList -');
  Log('');

  LogMontonesProceso(4);
  Log('');

  Log('    Se crea una lista de tipo THeapList');
  Log('');

  lista := THeapList.Create;
  try
    Log(Format('    Montón de la lista: $%x', [lista.Heap.Handle]));
    Log('');

    LogMontonesProceso(4);
    Log('');

    Log('    Se crea un bloque de memoria en el montón de la lista.');
    bloque_1 := lista.Heap.Allocate(sizeof(TDatos));
    Log(Format('        Posicion = $%x  Tamaño = %d',
               [Integer(bloque_1.Memory), bloque_1.Size]));
    Log('');


    Log('    Se crea otro bloque de memoria en el montón de la lista.');
    bloque_2 := lista.Heap.Allocate(sizeof(TDatos));
    Log(Format('        Posicion = $%x  Tamaño = %d',
               [Integer(bloque_2.Memory), bloque_2.Size]));
    Log('');

    Log(Format('    Hay %d bloques en el montón de la lista:', [lista.Heap.Blocks.Count]));
    for i:=0 to lista.Heap.Blocks.Count - 1 do
      Log(Format('        Bloque %d: Posicion = $%x  Tamaño = %d',
                 [i+1, Integer(lista.Heap.Block[i].Memory), lista.Heap.Block[i].Size]));
    Log('');

    Log('    Datos en cada elemento de la lista:');
    datos := bloque_1.Memory;
    datos^.nombre    := 'Juancito';
    datos^.apellidos := 'Pérez Pí';
    datos^.edad      := 13;

    Log('        Elemento 1:');
    Log('            Nombre = "'    + datos^.nombre + '"'   );
    Log('            Apellidos = "' + datos^.apellidos + '"');
    Log('            Edad = '       + IntToStr(datos^.edad) );

    datos := bloque_2.Memory;
    datos^.nombre    := 'Monchito';
    datos^.apellidos := 'Mendez Mé';
    datos^.edad      := 11;

    Log('        Elemento 2:');
    Log('            Nombre = "'    + datos^.nombre + '"'   );
    Log('            Apellidos = "' + datos^.apellidos + '"');
    Log('            Edad = '       + IntToStr(datos^.edad) );
    Log('');

  finally
    Log('    Se libera la lista.');
    Log('');
    lista.Free;

    LogMontonesProceso(4);
  end;

end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.l_jmClick(Sender: TObject);
begin
  ShellExecute(GetActiveWindow, nil, 'mailto:jose_manuel_navarro@yahoo.es', nil, nil, SW_NORMAL);
  l_jm.Font.Color := clPurple;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.FormCreate(Sender: TObject);
var
  icono: HICON;
begin
  rb_HeapAPI.Checked := true;

  // truquillo para mostrar en un TImage el icono de la aplicación.
  icono := SendMessage(Self.handle, WM_GETICON, ICON_BIG, 0);
  i_icono.Picture.Icon.Handle :=  icono;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.b_salirClick(Sender: TObject);
begin
  Self.Close;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.rb_heapAPIClick(Sender: TObject);
begin
  Info(MSG_PRUEBAS[1]);
  l_info.caption     := TRadioButton(Sender).Caption;
  b_ejecutar.OnClick := PruebaAPI;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.rb_THeapClick(Sender: TObject);
begin
  Info(MSG_PRUEBAS[2]);
  l_info.caption     := TRadioButton(Sender).Caption;
  b_ejecutar.OnClick := PruebaTHeap;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.rb_THeapListClick(Sender: TObject);
begin
  Info(MSG_PRUEBAS[3]);
  l_info.caption     := TRadioButton(Sender).Caption;
  b_ejecutar.OnClick := PruebaTHeapList;
end;

//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
procedure TMainForm.b_montonesClick(Sender: TObject);
begin
  if lb_log.Items.Count > 0 then
    Log('');
  Log(Format('- Montones del proceso "%s" -', [ExtractFileName(application.ExeName)]));
  LogMontonesProceso(4);
end;

procedure TMainForm.b_InfoMemClick(Sender: TObject);
var
  ms: TMemoryStatus;
begin
  if lb_log.Items.Count > 0 then
    Log('');
  Log('- Información de la memoria -');

  ms.dwLength := sizeof(ms);
  GlobalMemoryStatus(ms);

  Log(Format('    %% memoria usada:'#9'%d%%',                          [ms.dwMemoryLoad]));
  Log(Format('    Memoria RAM física total:'#9'%s KB.',                [FormatFloat('#,0', ms.dwTotalPhys     div 1024)]));
  Log(Format('    Memoria RAM física libre:'#9'%s KB.',                [FormatFloat('#,0', ms.dwAvailPhys     div 1024)]));
  Log(Format('    Espacio total en archivo intercambio:'#9'%s KB.',    [FormatFloat('#,0', ms.dwTotalPageFile div 1024)]));
  Log(Format('    Espacio libre en archivo de intermcabio:'#9'%s KB.', [FormatFloat('#,0', ms.dwAvailPageFile div 1024)]));
  Log(Format('    Memoria virtual total:'#9'%s KB.',                   [FormatFloat('#,0', ms.dwTotalVirtual  div 1024)]));
  Log(Format('    Memoria virtual libre:'#9'%s KB.',                   [FormatFloat('#,0', ms.dwAvailVirtual  div 1024)]));
end;

end.
