unit files;

{$mode objfpc} 

interface

uses paszlib,sysutils,classes,objects;

type EOpenException = Class(Exception);

function f_gzopen(path,mode:pchar): gzFile;

implementation

function f_gzopen(path,mode:pchar): gzFile;
begin
 f_gzopen := gzopen(path,mode);
 if f_gzopen=nil then Raise EOpenException.Create ('Could not open file');
end;

end.