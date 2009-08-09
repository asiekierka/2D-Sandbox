unit misc;

interface

procedure SwapByte(v1,v2:byte);

implementation

procedure SwapByte(v1,v2:byte);
var v3:byte;
begin
v3 := v1;
v1 := v2;
v2 := v3;
end;

end.