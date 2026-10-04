
{           Copyright (c) 1985, 87 by Borland International, Inc.            }

unit AuxInOut;
{ AUX example from P-373 of the Owner's Handbook. Use this
  example instead of the one in the manual.
}

interface

uses Dos;

procedure AssignAux(var F: Text; Port,Params: Word);

implementation

{$R-,S-}

type
  AuxRec = record
             Port,Params: Word;
             Unused: array[1..12] of Byte;
           end;

procedure AuxInit(Port,Params: Word);
inline(
  $58/          { POP   AX      ;Pop parameters         }
  $5A/          { POP   DX      ;Pop port number        }
  $B4/$00/      { MOV   AH,0    ;Code for initialize    }
  $CD/$14);     { INT   14H     ;Call BIOS              }

function AuxInChar(Port: Word): Char;
inline(
  $5A/          { POP   DX      ;Pop port number        }
  $B4/$02/      { MOV   AH,2    ;Code for input         }
  $CD/$14);     { INT   14H     ;Call BIOS              }

procedure AuxOutChar(Port: Word; Ch: Char);
inline(
  $58/          { POP   AX      ;Pop character          }
  $5A/          { POP   DX      ;Pop port number        }
  $B4/$01/      { MOV   AH,1    ;Code for output        }
  $CD/$14);     { INT   14H     ;Call BIOS              }

function AuxInReady(Port: Word): Boolean;
inline(
  $5A/          { POP   DX      ;Pop port number        }
  $B4/$03/      { MOV   AH,3    ;Code for status        }
  $CD/$14/      { INT   14H     ;Call BIOS              }
  $88/$E0/      { MOV   AL,AH   ;Get line status in AH  }
  $24/$01);     { AND   AL,1    ;Isolate Data Ready bit }

{$F+}

function AuxInput(var F: TextRec): Integer;
var
  P: Word;
begin
  with F,AuxRec(UserData) do
  begin
    P:=0;
    while AuxInReady(Port) and (P<BufSize) do
    begin
      BufPtr^[P]:=AuxInChar(Port); Inc(P);
    end;
    BufPos:=0; BufEnd:=P;
  end;
  AuxInput:=0;
end;

function AuxOutput(var F: TextRec): Integer;
var
  P: Word;
begin
  with F,AuxRec(UserData) do
  begin
    P:=0;
    while P<BufPos do
    begin
      AuxOutChar(Port,BufPtr^[P]); Inc(P);
    end;
    BufPos:=0;
  end;
  AuxOutput:=0;
end;

function AuxIgnore(var F: TextRec): Integer;
begin
  AuxIgnore:=0;
end;

function AuxOpen(var F: TextRec): Integer;
begin
  with F,AuxRec(UserData) do
  begin
    AuxInit(Port,Params);
    if Mode=fmInput then
    begin
      InOutFunc:=@AuxInput;
      FlushFunc:=@AuxIgnore;
    end else
    begin
      Mode:=fmOutput;
      InOutFunc:=@AuxOutput;
      FlushFunc:=@AuxOutput;
    end;
    CloseFunc:=@AuxIgnore;
  end;
  AuxOpen:=0;
end;

{$F-}

procedure AssignAux;
begin
  with TextRec(F) do
  begin
    Handle:=$FFFF;
    Mode:=fmClosed;
    BufSize:=SizeOf(Buffer);
    BufPtr:=@Buffer;
    OpenFunc:=@AuxOpen;
    AuxRec(UserData).Port:=Port;
    AuxRec(UserData).Params:=Params;
    Name[0]:=#0;
  end;
end;

end.
