program Example(input,output);

var
    i, j, k : Integer;
    result  : Integer;

function Func(a, b, c: Integer): Integer;
    begin
        Func := a + b - c;
    end;

begin
    i := 1;
    j := 2;
    k := 3;

    result := Func(i, j, k);

    WriteLn(output, 'Result: ', result);
end.
