unit collision;

interface
uses sdl;

procedure COL_check_pixels(x,y,w,h:word; sur:PSDL_Surface);

implementation

procedure COL_check_pixels(x,y,w,h:word; sur:PSDL_Surface);
var i,j:longint;
    tr,tg,tb:PUint8;
    pxloc:^LONGWORD;

begin
 NEW(pxloc);
 for i := 0 to (w*h) do begin
  j := (x+(y*(sur^.w))+(i mod w)+((i div w)*(sur^.w)));
  pxloc := sur^.pixels+j;
  SDL_GetRGB(pxloc^,(sur^.format),tr,tg,tb);
  if ((tr^+tg^+tb^) / 3) > 128 then
  begin
   break;
  end;
 end;
 DISPOSE(pxloc);
end;

end.