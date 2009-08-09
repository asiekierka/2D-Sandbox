program sdltest;
uses crt, sdl,
	video in 'video.pas',
        maps in 'maps.pas',
	player in 'player.pas';

var
 event: PSDL_Event;
 m1,m2: longint;
 mousex,mousey:longint;
 SDL_LMB_HELD:boolean;
 mapfn: string;

procedure ExitApp;
begin
	WriteLN('exiting...');
	quit_SDL;
	Halt;
end;

begin
 Randomize;
 if ParamCount > 0 then 
  mapfn := ParamStr(1)
 else
  mapfn := 'testmap.dat';
 init_maps(mapfn);
 init_SDL;
 init_player(1);
 currb.typ := 0;
 new(event);
 blit_map;
 scrrun:=0;
 doUpdate := true;
 SDL_LMB_HELD := false;
 while 1=1 do begin
  process_map;
  render_map;
  doUpdate := false;
  Delay(16);
  framecnt := framecnt+1;
  SDL_GetMouseState(mousex,mousey);
   if SDL_LMB_HELD = true then
   begin
       if scrrun = 0 then begin
        if (mousex<(SCR_WIDTH-21)) or (mousey<(SCR_HEIGHT-21)) then begin
        m1 := mousex div 16+offx div 16;
        m2 := mousey div 16+offy div 16;
        gamemap[m1,m2,currd].br := currb.br;
        gamemap[m1,m2,currd].bg := currb.bg;
        gamemap[m1,m2,currd].bb := currb.bb;
        gamemap[m1,m2,currd].r := currb.r;
        gamemap[m1,m2,currd].g := currb.g;
        gamemap[m1,m2,currd].b := currb.b;
        gamemap[m1,m2,currd].typ := currb.typ;
        gamemap[m1,m2,currd].id := currb.id;
        update_sector((m1+(offx div 16)),(m2+(offx div 16)));
        render_tilebox;
        SDL_Flip(scr);
        end;
       end;
       if scrrun = 1 then begin
        for m1 := 0 to 5 do
        if ( (mousex > 63) and (mousex < 576) and (mousey > (166+(m1*24))) and (mousey < (168+18+(m1*24))) ) then
        begin
         sliderx[m1] := (mousex-5);
         case m1 of
         0: currb.br := ((mousex-64) div 2);
         1: currb.bg := ((mousex-64) div 2);
         2: currb.bb := ((mousex-64) div 2);
         3: currb.r := ((mousex-64) div 2);
         4: currb.g := ((mousex-64) div 2);
         5: currb.b := ((mousex-64) div 2);
	 end;
        end;
       end;
      end;
  while(SDL_PollEvent(event) = 1) do begin
   case event^.type_ of
    SDL_MOUSEBUTTONDOWN:
    begin
     case event^.button.button of
      SDL_BUTTON_WHEELUP:
      begin
       if currb.id=0 then
        currb.id := tmlen-1
       else
        currb.id := currb.id - 1;
       doUpdate := true;
      end;
      SDL_BUTTON_WHEELDOWN:
      begin
       currb.id := ((currb.id + 1) mod tmlen);
       doUpdate := true;
      end;
      SDL_BUTTON_LEFT: SDL_LMB_HELD := true;
     end;
    end;
    SDL_MOUSEBUTTONUP:
    begin
    case event^.button.button of
     SDL_BUTTON_LEFT: SDL_LMB_HELD := false;
    end;
    end;
    SDL_KEYDOWN:
    begin
     //Write(event^.key.keysym.sym,', ');
     if scrrun=0 then begin
     case event^.key.keysym.sym of
     99, 67:
     begin
      scrrun := (1-scrrun);
      doUpdate := true;
     end;
     122:
     begin
      clear_map;
      doUpdate := true;
      offx := 0;
      offy := 0; 
     end;
     100:
     begin
     if currd = (md-1) then
     currd := 0
     else
     currd := currd + 1;
     blit_map;
     render_tilebox;
     SDL_Flip(scr);
     end;
     108:
     begin
      load_map(mapfn);
      doUpdate := true;
      offx := 0;
      offy := 0; 
     end;
     115: save_map(mapfn);
     114:
     begin
      Write('Randomizing map...   ');
      do_random_map;
      doUpdate := true;
      offx := 0;
      offy := 0; 
      WriteLn('done!');
     end;
     112: begin
      isPaused := (1-isPaused);
      doUpdate := true;
     end;
     273: 
     begin
      if (offy>0) then offy:=offy-16;
      doUpdate := true;
     end;
     274:
     begin
      if (offy<((mh*16)-SCR_HEIGHT)) then offy:=offy+16;
      doUpdate := true;
     end;
     276: 
     begin
      if (offx>0) then offx:=offx-16;
      doUpdate := true;
     end;
     275:
     begin
      if (offx<((mw*16)-SCR_WIDTH)) then offx:=offx+16;
      doUpdate := true;
     end;
     end;
     end else begin
     //WriteLN('key: ',(event^.key.keysym.sym));
     case event^.key.keysym.sym of
     99, 67:
     begin
      scrrun := (1-scrrun);
      doUpdate := true;
     end;
     115:
     begin
      m1 := currb.br; 
      currb.br := currb.r;
      currb.r := m1;
      m1 := currb.bg; 
      currb.bg := currb.g;
      currb.g := m1;
      m1 := currb.bb; 
      currb.bb := currb.b;
      currb.b := m1;
      init_slider;
     end;
     114:
     begin
      currb.br := 0;
      currb.bg := 0;
      currb.bb := 0;
      currb.r := 255;
      currb.g := 255;
      currb.b := 255;
      init_slider;
     end;
     49: storecol(0);
     50: storecol(1);
     51: storecol(2);
     52: storecol(3);
     53: storecol(4);
     54: storecol(5);
     282: loadcol(0);
     283: loadcol(1);
     284: loadcol(2);
     285: loadcol(3);
     286: loadcol(4);
     287: loadcol(5);
     273: begin
     if currb.typ > 0 then
      currb.typ := currb.typ - 1
     else
      currb.typ := MAX_TYPES - 1;
     end;
     274: begin
      currb.typ := (currb.typ + 1) mod MAX_TYPES;
     end;
     end;
     end;
    end;
    SDL_QUITEV: ExitApp;
   end;
 end;
 end;
 quit_SDL;
end.
