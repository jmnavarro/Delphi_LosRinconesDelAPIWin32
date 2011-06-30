//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Proyecto: MultiMemo
//
// Propósito:
//    Se trata de un pequeño editor de textos que se sincroniza con todas las instancia
//    del mismo programa. Cada vez que cambia el contenido, el resto de instancias reciben
//    una notificación y leen el nuevo contenido de una zona de memoria compartida (a través
//    de archivos proyectados en memoria).
//
// Autor:          José Manuel Navarro (jose_manuel_navarro@yahoo.es)
// Fecha:          01/02/2003
// Observaciones:  Unidad creada en Delphi 5 para Síntesis nº 13 (http://www.grupoalbor.com)
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

program MultiMemo;

uses
  Forms,
  main in 'main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
