unit maps;

interface

uses paszlib;

const
	MAX_TYPES=2;
        typnames: array[0..1] of ansistring = ('Solid','Water');

type
	maprec=packed record
		id : word;
		typ: byte;
		r,g,b: byte;
		br,bg,bb: byte
	end;
var
 currb:maprec;
 gamemap: array of array of array of maprec;
 mw,mh,md,currd:word;
 tmlen: longint;
 px,py: word;
 framecnt: word;
 doUpdate:boolean;
 isPaused:byte; 
 gamemapold:array of array of array of maprec;

procedure save_map(fn: ansistring);
procedure init_maps(mapfn: string);
procedure load_map(fn: ansistring);
procedure clear_map;
procedure do_random_map;
procedure process_map;

implementation

procedure do_random_map;
var
 i,j,k: shortint;
begin
 for k := 0 to md-1 do
 for j := 0 to mh-1 do
 for i := 0 to mw-1 do begin
  gamemap[i,j,k].id := random((tmlen-1));
  gamemap[i,j,k].typ := 0;
  gamemap[i,j,k].r := random(255);
  gamemap[i,j,k].g := random(255);
  gamemap[i,j,k].b := random(255);
  gamemap[i,j,k].br := random(255);
  gamemap[i,j,k].bg := random(255);
  gamemap[i,j,k].bb := random(255);
 end;
end;


procedure save_map(fn: ansistring);
var
 fmap: gzFile;
 i,j,k: dword;
begin
 Write('Saving test map...   ');
 fmap := gzopen(pchar(fn),pchar('wb5'));
 gzrewind(fmap);
 gzputc(fmap,Char(2));
 gzputc(fmap,Char(mw mod 256));
 gzputc(fmap,Char(mh mod 256));
 gzputc(fmap,Char(mw>>8));
 gzputc(fmap,Char(mh>>8));
 gzputc(fmap,Char(md));
 gzputc(fmap,Char(px));
 gzputc(fmap,Char(py));
 gzputc(fmap,Char(currd));
 for k := 0 to md-1 do
 for j := 0 to mh-1 do
 for i := 0 to mw-1 do
 begin
   gzputc(fmap,Char((gamemap[i,j,k].id) mod 256)); //low bit
   gzputc(fmap,Char((gamemap[i,j,k].id)>>8)); //high bit
   gzputc(fmap,Char(gamemap[i,j,k].typ));
   gzputc(fmap,Char(gamemap[i,j,k].r));
   gzputc(fmap,Char(gamemap[i,j,k].g));
   gzputc(fmap,Char(gamemap[i,j,k].b));
   gzputc(fmap,Char(gamemap[i,j,k].br));
   gzputc(fmap,Char(gamemap[i,j,k].bg));
   gzputc(fmap,Char(gamemap[i,j,k].bb));
 end;
 gzclose(fmap);
 WriteLN('done');
end;

procedure load_map(fn: ansistring);
var
 mt,mt2,mt3: char;
 fmap: gzFile;
 i,j,k: dword;
begin
 Write('Loading ',fn,'...   ');
 fmap := gzopen(pchar(fn),pchar('rb'));
 gzrewind(fmap);
 mt := gzgetc(fmap);
 if LongInt(mt) < 2 then
 begin
 WriteLn('ERROR: Wrong version!');
 Halt;
 end;
 mt := gzgetc(fmap);
 mt2 := gzgetc(fmap);
 mt3 := gzgetc(fmap);
 mw := (LongInt(mt)+(LongInt(mt3)<<8));
 mt3 := gzgetc(fmap);
 mh := (LongInt(mt2)+(LongInt(mt3)<<8));
 mt := gzgetc(fmap);
 md := LongInt(mt);
 mt := gzgetc(fmap);
 px := LongInt(mt);
 mt := gzgetc(fmap);
 py := LongInt(mt);
 mt := gzgetc(fmap);
 currd := LongInt(mt);
 SetLength(gamemap,mw,mh,md);
 SetLength(gamemapold,mw,mh,md);
 GetMem((mw*mh*md*9));
 for k := 0 to md-1 do
 for j := 0 to mh-1 do
 for i := 0 to mw-1 do
 begin
  mt := gzgetc(fmap);
  mt2 := gzgetc(fmap);
  gamemap[i,j,k].id := (LongInt(mt) + (LongInt(mt2)<<8));
  gamemap[i,j,k].typ := LongInt(gzgetc(fmap));
  gamemap[i,j,k].r := LongInt(gzgetc(fmap));
  gamemap[i,j,k].g := LongInt(gzgetc(fmap));
  gamemap[i,j,k].b := LongInt(gzgetc(fmap));
  gamemap[i,j,k].br := LongInt(gzgetc(fmap));
  gamemap[i,j,k].bg := LongInt(gzgetc(fmap));
  gamemap[i,j,k].bb := LongInt(gzgetc(fmap));
 end;
 gzclose(fmap);
 WriteLN('done');
end; 

procedure init_maps(mapfn: string);
begin
 load_map(mapfn);
 currb.br := 0;
 currb.bg := 0;
 currb.bb := 0;
 currb.r := 255;
 currb.g := 255;
 currb.b := 255;
 currb.id := 2;
end;

procedure clear_map;
var i,j:word;
begin
 for j := 0 to mh-1 do
  for i := 0 to mw-1 do begin
   gamemap[i,j,currd].id := 0;
   gamemap[i,j,currd].typ := 0;
   gamemap[i,j,currd].r := 0;
   gamemap[i,j,currd].g := 0;
   gamemap[i,j,currd].b := 0;
   gamemap[i,j,currd].br := 0;
   gamemap[i,j,currd].bg := 0;
   gamemap[i,j,currd].bb := 0;
  end;
end;

procedure copyblock(x1,y1,z1,x2,y2,z2:longint);
begin
 gamemap[x1,y1,z1].id := gamemapold[x2,y2,z2].id;
 gamemap[x1,y1,z1].typ := gamemapold[x2,y2,z2].typ;
 gamemap[x1,y1,z1].r := gamemapold[x2,y2,z2].r;
 gamemap[x1,y1,z1].g := gamemapold[x2,y2,z2].g;
 gamemap[x1,y1,z1].b := gamemapold[x2,y2,z2].b;
 gamemap[x1,y1,z1].br := gamemapold[x2,y2,z2].br;
 gamemap[x1,y1,z1].bg := gamemapold[x2,y2,z2].bg;
 gamemap[x1,y1,z1].bb := gamemapold[x2,y2,z2].bb;
end;

procedure bgctoc(x1,y1,z1,x2,y2,z2,typz:longint);
begin
 if gamemap[x1,y1,z1].typ <> typz then begin
 gamemap[x1,y1,z1].br := gamemapold[x2,y2,z2].r;
 gamemap[x1,y1,z1].bg := gamemapold[x2,y2,z2].g;
 gamemap[x1,y1,z1].bb := gamemapold[x2,y2,z2].b;
 end;
end;

procedure process_map;
var i,j:longint;
    k: byte;
begin
if isPaused = 0 then begin
 for j := 0 to mh-1 do
  for i := 0 to mw-1 do
   gamemapold[i,j,currd] := gamemap[i,j,currd];

 for j := 0 to mh-1 do
  for i := 0 to mw-1 do begin
   if gamemapold[i,j,currd].id <> 0 then
   begin
   if (framecnt mod 12) = 0 then
   begin
   if gamemapold[i,j,currd].typ = 1 then
   begin
    if j < mh-1 then
     if gamemap[i,j+1,currd].id = 0 then copyblock(i,j+1,currd,i,j,currd)
     else bgctoc(i,j+1,currd,i,j,currd,1);
    k := random(3);
    case k of
    0: begin
    if i > 0 then
     if gamemap[i-1,j,currd].id = 0 then copyblock(i-1,j,currd,i,j,currd)
     else bgctoc(i-1,j,currd,i,j,currd,1);
    end;
    1: begin
    if i < mw-1 then
     if gamemap[i+1,j,currd].id = 0 then copyblock(i+1,j,currd,i,j,currd)
     else bgctoc(i+1,j,currd,i,j,currd,1);
    end;
    end;
    DoUpdate := true;
   end;
   end;
   end;
   end; 
end;
end;

end.