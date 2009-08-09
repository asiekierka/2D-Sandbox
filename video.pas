unit video;

interface

uses sdl, sdl_image, sysutils,
     maps in 'maps.pas',
     player in 'player.pas';
const
	SCR_WIDTH = 640;
	SCR_HEIGHT = 480;
	arrow: array[0..7] of byte = (64,96,80,72,68,126,24,12);
	arrowmask: array[0..7] of byte = (64,96,112,120,124,126,24,12);

type
	colrec=record
		r,g,b:byte;
		br,bg,bb: byte
	end;

var
 scr: PSDL_Surface; // Our main screen
 tilemap,slidermap,fontmap: PSDL_Surface; // Our tilemap
 srcrect,dstrect: PSDL_Rect;
 offx,offy: word;
 tilecol: array[0..1] of TSDL_Color;
 event: PSDL_Event;
 mapblit,maskmap: PSDL_Surface; // Our full map
 curs: PSDL_Cursor;
 scrrun:longint;
 sliderx: array[0..5] of longint;
 storcol: array[0..5] of colrec;

function init_rect(x,y,w,h:word): PSDL_Rect;
function get_tile(gtID:word): PSDL_Rect;
procedure init_slider;
procedure loadcol(cn:byte);
procedure storecol(cn:byte);
procedure drawfont(fx,fy:longint; fscr: PSDL_Surface; ftext: PChar);
procedure drawfontadv(fx,fy:longint; fscr: PSDL_Surface; ftext: PChar; fr,fg,fb:byte);
procedure update_sector(ix,iy:word);
procedure blit_map;
procedure render_tilebox;
procedure render_map;
procedure init_SDL;
procedure quit_SDL;

implementation

function init_rect(x,y,w,h:word): PSDL_Rect;
begin
 NEW(init_rect);
 init_rect^.x := x;
 init_rect^.y := y;
 init_rect^.w := w;
 init_rect^.h := h;
end;

function get_tile(gtID:word): PSDL_Rect;
begin
 get_tile := init_rect((gtID*16),0,16,16);
end;

procedure drawfont(fx,fy:longint; fscr: PSDL_Surface; ftext: PChar);
begin
 drawfontadv(fx,fy,fscr,ftext,255,255,255);
end;

procedure drawfontadv(fx,fy:longint; fscr: PSDL_Surface; ftext: PChar; fr,fg,fb:byte);
var i,fnx:longint;
    frect,frect2:PSDL_Rect;
begin
 fnx := fx;
 tilecol[0].r := 0;
 tilecol[0].g := 0;
 tilecol[0].b := 0;
 tilecol[1].r := fr;
 tilecol[1].g := fg;
 tilecol[1].b := fb;
 SDL_SetColors(fontmap,tilecol,0,2);
 for i := 0 to (strlen(ftext)-1) do
 begin
  frect := init_rect((LongWord(ftext[i])*8),0,8,8);
  frect2 := init_rect(fnx,fy,8,8);
  SDL_BlitSurface(fontmap,frect,fscr,frect2);
  fnx := fnx + 8;
 end;
end;

procedure update_sector(ix,iy:word);
begin
   if (((ix*16)-(offx)) < SCR_WIDTH) or (((iy*16)-(offy)) < SCR_HEIGHT) then
   begin
   dstrect := init_rect(((ix*16)-offx),((iy*16)-offy),16,16);
   tilecol[0].r := gamemap[ix,iy,currd].br;
   tilecol[0].g := gamemap[ix,iy,currd].bg;
   tilecol[0].b := gamemap[ix,iy,currd].bb;
   tilecol[1].r := gamemap[ix,iy,currd].r;
   tilecol[1].g := gamemap[ix,iy,currd].g;
   tilecol[1].b := gamemap[ix,iy,currd].b;
   SDL_SetColors(tilemap,tilecol,0,2);
   SDL_BlitSurface(tilemap,get_tile(gamemap[ix,iy,currd].ID),scr,dstrect);
   tilecol[0].r := 0;
   tilecol[0].g := 0;
   tilecol[0].b := 0;
   tilecol[1].r := 255;
   tilecol[1].g := 255;
   tilecol[1].b := 255;
   SDL_SetColors(tilemap,tilecol,0,2);
   SDL_BlitSurface(tilemap,get_tile(gamemap[ix,iy,currd].ID),maskmap,dstrect);
   end;
end;

procedure blit_map;
var i,j:word;
begin
 for j := (offy div 16) to mw-1 do
  for i := (offx div 16) to mh-1 do
   update_sector(i,j);
end;

procedure render_tilebox;
begin
 dstrect := init_rect((SCR_WIDTH-21),(SCR_HEIGHT-21),21,21);
 SDL_FillRect(scr,dstrect,SDL_MapRGBA((scr^.format),0,0,0,0));
 dstrect := init_rect((SCR_WIDTH-20),(SCR_HEIGHT-20),20,20);
 SDL_FillRect(scr,dstrect,SDL_MapRGBA((scr^.format),128,128,128,0));
 tilecol[0].r := currb.br;
 tilecol[0].g := currb.bg;
 tilecol[0].b := currb.bb;
 tilecol[1].r := currb.r;
 tilecol[1].g := currb.g;
 tilecol[1].b := currb.b;
 SDL_SetColors(tilemap,tilecol,0,2);
 dstrect := init_rect((SCR_WIDTH-18),(SCR_HEIGHT-18),16,16);
 SDL_BlitSurface(tilemap,get_tile(currb.id),scr,dstrect);
end;

procedure render_player;
var tp,i:byte;
begin
 for i := 0 to (playaop-1) do begin
  tp := players[i].emot*16;
  if players[i].face = true then tp := tp+8;
 end;
end;

procedure render_map;
var j:dword;
    pt1: PChar;
begin
 if scrrun=0 then
 begin
  if doUpdate then begin
  blit_map;
  //render_player;
  if isPaused = 1 then drawfont(1,1,scr,'PAUSE');
  render_tilebox;
  SDL_Flip(scr);
  end;
 end;
 if scrrun=1 then
 begin
  dstrect := init_rect(0,0,640,480);
  SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),128,128,128));
  drawfontadv(312,160,scr,'BG',255,255,255);
  drawfontadv(312,(160+72),scr,'FG',255,255,255);
  drawfontadv(580,170,scr,PChar(IntToStr(currb.br)),255,255,255);
  drawfontadv(580,170+24,scr,PChar(IntToStr(currb.bg)),255,255,255);
  drawfontadv(580,170+48,scr,PChar(IntToStr(currb.bb)),255,255,255);
  drawfontadv(580,170+72,scr,PChar(IntToStr(currb.r)),255,255,255);
  drawfontadv(580,170+72+24,scr,PChar(IntToStr(currb.g)),255,255,255);
  drawfontadv(580,170+72+48,scr,PChar(IntToStr(currb.b)),255,255,255);
  drawfontadv(2,2,scr,'Color modification',255,255,255);
  drawfontadv((SCR_WIDTH-1-(strlen(PChar(typnames[currb.typ]))*8)),(SCR_Height-29),scr,PChar(typnames[currb.typ]),255,255,255);
  pt1 := PChar('X: ' + IntToStr((offx div 16)) + ', Y: ' + IntToStr((offy div 16)) + ', Map ' + IntToStr(currd));
  drawfont(2,460,scr,pt1);
  if md = 1 then
   pt1 := PChar(IntToStr(md) + ' map of size: ' + IntToStr(mw) + 'x' + IntToStr(mh))
  else
   pt1 := PChar(IntToStr(md) + ' maps of size: ' + IntToStr(mw) + 'x' + IntToStr(mh));
  drawfont(2,470,scr,pt1);
  SDL_FillRect(scr,init_rect(16,180,32,32),SDL_MapRGB((scr^.format),currb.br,currb.bg,currb.bb));
  SDL_FillRect(scr,init_rect(16,180+72,32,32),SDL_MapRGB((scr^.format),currb.r,currb.g,currb.b));
   for j := 0 to 255 do begin
   dstrect := init_rect((64+(j*2)),(168+72),2,12);
   SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),j,currb.g,currb.b));
   dstrect := init_rect((64+(j*2)),(168+72+24),2,12);
   SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),currb.r,j,currb.b));
   dstrect := init_rect((64+(j*2)),(168+72+48),2,12);
   SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),currb.r,currb.g,j));
   dstrect := init_rect((64+(j*2)),168,2,12);
   SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),j,currb.bg,currb.bb));
   dstrect := init_rect((64+(j*2)),(168+24),2,12);
   SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),currb.br,j,currb.bb));
   dstrect := init_rect((64+(j*2)),(168+48),2,12);
   SDL_FillRect(scr,dstrect,SDL_MapRGB((scr^.format),currb.br,currb.bg,j));
   end;
   for j := 0 to 5 do begin
   dstrect := init_rect(sliderx[j],(166+(j*24)),10,16);
   SDL_BlitSurface(slidermap,init_rect(0,0,10,16),scr,dstrect);
   end;
  render_tilebox;
  SDL_Flip(scr);
 end;
end;

procedure init_slider;
begin
 sliderx[0] := ((currb.br*2)+59);
 sliderx[1] := ((currb.bg*2)+59);
 sliderx[2] := ((currb.bb*2)+59);
 sliderx[3] := ((currb.r*2)+59);
 sliderx[4] := ((currb.g*2)+59);
 sliderx[5] := ((currb.b*2)+59);
end;

procedure loadcol(cn:byte);
begin
 currb.r := storcol[cn].r;
 currb.g := storcol[cn].g;
 currb.b := storcol[cn].b;
 currb.br := storcol[cn].br;
 currb.bg := storcol[cn].bg;
 currb.bb := storcol[cn].bb;
 init_slider;
end;

procedure storecol(cn:byte);
begin
 storcol[cn].r := currb.r;
 storcol[cn].g := currb.g;
 storcol[cn].b := currb.b;
 storcol[cn].br := currb.br;
 storcol[cn].bg := currb.bg;
 storcol[cn].bb := currb.bb;
end;

procedure init_SDL;
const
 pathmod = {$IFDEF WIN32}'\'{$ELSE}'/'{$ENDIF};
begin
 SDL_Init(SDL_INIT_VIDEO); // Initialize the video SDL subsystem
 scr:=SDL_SetVideoMode(SCR_WIDTH, SCR_HEIGHT, 24, SDL_HWSURFACE); // Create a software window of 640x480x8 and assign to scr
 tilemap := SDL_LoadBMP('gfx'+pathmod+'tilemap.bmp');
 slidermap := IMG_Load('gfx'+pathmod+'slider.gif');
 fontmap := IMG_Load('gfx'+pathmod+'font.gif');
 tmlen := (tilemap^.w div 16);
 maskmap := SDL_CreateRGBSurface(SDL_HWSURFACE, SCR_WIDTH, SCR_HEIGHT, 24,0,0,0,0);
 offx := 0;
 offy := 0;
 curs:=SDL_CreateCursor(arrow,arrowmask,8,8,0,0);
 init_slider;
end;

procedure quit_SDL;
begin
 SDL_FreeCursor(curs);
 SDL_FreeSurface(maskmap);
 SDL_FreeSurface(tilemap);
 SDL_FreeSurface(slidermap);
 SDL_FreeSurface(fontmap);
 SDL_Quit; // close the subsystems and SDL
end;

end.
