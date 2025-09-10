program Lexer;

uses
  Character,
  SysUtils;

type
  TToken = (
      // primary
      TOK_NUMBER = -5,
      TOK_IDENTIFIER = -4,
      // commands
      TOK_EXTERN = -3,
      TOK_DEF = -2,
      // EOF
      TOK_EOF = -1,
      TOK_BASE = 0
  );

(* ******************** *)
var // global vars
  identifierStr: string = '';
  numVal: double = 0;
  token: TToken = TOK_BASE;

(* ******************** *)
function gettok: TToken;

var
  lastChar: char = ' ';

begin
  while TCharacter.IsWhiteSpace(lastChar) do begin
    read(lastChar);
  end;

  if TCharacter.IsLetter(lastChar) then begin
    identifierStr := lastChar;
    read(lastChar);
    while TCharacter.IsLetterOrDigit(lastChar) do begin
      identifierStr := identifierStr + lastChar;
      read(lastChar);
    end;

    if identifierStr = 'def' then
      exit(TOK_DEF);

    if identifierStr = 'extern' then
      exit(TOK_EXTERN);

    exit(TOK_IDENTIFIER);
  end;

  if Eof then
    exit(TOK_EOF);

  exit(TOK_EOF);
end;

(* ******************** *)
begin // Main
  write(StdErr, 'Ready > ');

  while token <> TOK_EOF do begin
    token := gettok;

    writeln;
    writeln(StdErr, 'The token is: ', token);
    writeln(StdErr, 'The dentifier is: ', identifierStr);
    writeln(StdErr, 'The number is: ', numVal);
  end;

end. // Main
