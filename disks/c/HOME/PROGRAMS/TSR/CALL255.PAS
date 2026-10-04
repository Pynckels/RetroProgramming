Program Call255;

Uses
  Dos;

Var
  I, C : Integer;
  R    : Registers;

Begin
  WriteLn ('Interrupt 255 test program');
  WriteLn ('Copyright (c) 1989 by Pynckels');
  WriteLn;

  If ParamCount <> 2 Then
    Begin
      WriteLn ('Format : Call255 <Param1> <Param2>');
      Halt
    End;

  Val (ParamStr(1), I, C);
  R.AH := I;
  Val (ParamStr(2), I, C);
  R.AL := I;

  Intr (255, R);
  WriteLn ('Resultaat : ', R.AH)
End.