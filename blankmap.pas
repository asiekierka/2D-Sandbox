program blankmap;
uses crt,paszlib;

var
 i,mx,my,md,px,py,pd:longint;
 fn: pchar;
 fmap: gzFile;
 fn2:ansistring;

begin
 while (mx<3) or (mx>1024) do begin
 Write('X size?: ');
 readln(mx);
 end;
 while (my<3) or (my>1024) do begin
 Write('Y size?: ');
 readln(my);
 end;
 while (md<1) or (md>255) do begin
 Write('How many maps?: ');
 readln(md);
 end;
 px := -1;
 py := -1;
 pd := -1;
 while (px<0) or (px>=mx) do begin
 Write('Player X position? (0-',(mx-1),'): ');
 readln(px);
 end;
 while (py<0) or (py>=my) do begin
 Write('Player Y position? (0-',(my-1),'): ');
 readln(py);
 end;
 while (pd<0) or (pd>=md) do begin
 Write('Map to start in? (0-',(md-1),'): ');
 readln(pd);
 end;
 Write('Filename?: ');
 readln(fn2);
 Write('Saving ',fn,'...');
 fn := PChar(fn2);
 fmap := gzopen(fn,pchar('wb5'));
 if fmap=nil then begin
  WriteLN('ERR: Cannot open ',fn2,'.');
  Halt;
 end;
 gzrewind(fmap);
 gzputc(fmap,Char(2));
 gzputc(fmap,Char(mx mod 256));
 gzputc(fmap,Char(my mod 256));
 gzputc(fmap,Char(mx>>8));
 gzputc(fmap,Char(my>>8));
 gzputc(fmap,Char(md));
 gzputc(fmap,Char(px));
 gzputc(fmap,Char(py));
 gzputc(fmap,Char(pd));
 for i := 0 to (mx*my*md) do
 begin
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
  gzputc(fmap,Char(0));
 end;
 gzclose(fmap);
 WriteLN(' done!');
end.