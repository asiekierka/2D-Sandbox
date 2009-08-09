unit player;

interface

uses sdl,
     maps in 'maps.pas';

const
	PLAYER_WIDTH = 8;
        PLAYER_HEIGHT = 14;
type
	playrec=record
		emot:byte;
		tx,ty:byte;
                face:boolean;
		r,g,b:byte;
		br,bg,bb: byte
        end;	
var
	players: array of playrec;
        playaop: integer;

procedure init_player(aop:byte);

implementation

procedure init_player(aop:byte);
var i:byte;
begin
 playaop := aop;
 SetLength(players,aop);
 for i := 0 to aop-1 do begin
  players[i].tx := (px*16);
  players[i].ty := (py*16);
 end;
 players[0].emot := 1;
 players[0].br := 128;
 players[0].r := 255;
 players[0].g := 255;
 players[0].b := 128;
end;

end.

	