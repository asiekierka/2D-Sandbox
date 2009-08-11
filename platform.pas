unit platform;

interface

uses
 sysutils;

function platform_path(path: pchar): pchar; overload;
function platform_path(path: string): pchar; overload;
implementation
function platform_path(path: string): pchar; overload;
var tmp: ansistring;
begin
 tmp := ansistring(path);
 dodirseparators(tmp);
 platform_path := pchar(tmp);
end;
function platform_path(path: pchar): pchar; overload;
begin
 platform_path := platform_path(string(path));
end;

end.
