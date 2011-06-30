//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: PruebasHeap.dpr
//
// Propósito:
//    Proyecto para demostrar el uso de montones a través de las funciones de API Win32, y de
//    clases de la unidad Heap.pas
//
// Autor:          José Manuel Navarro (jose_manuel_navarro@yahoo.es)
// Fecha:          01/12/2002
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 12 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

program PruebasHeap;

uses
  Forms,
  main in 'main.pas' {MainForm},
  Heap in '..\clases\Heap.pas';

{$R *.RES}

var
  MainForm: TMainForm;

begin
  Application.Initialize;
  Application.Title := 'Pruebas con montones';

  Application.CreateForm(TMainForm, MainForm);
  
  Application.Run;
end.
