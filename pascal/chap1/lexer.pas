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
      // start me up
      TOK_BASE = 0,
      // oh, no!
      TOK_ERROR = 1
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
  numStr: string = '';

begin
  while TCharacter.IsWhiteSpace(lastChar) do begin
    read(lastChar);
  end;

  // identifier: [a-zA-Z][a-zA-Z0-9]*
  if TCharacter.IsLetter(lastChar) then begin
    identifierStr := lastChar;
    read(lastChar);
    while TCharacter.IsLetterOrDigit(lastChar) do begin
      identifierStr := identifierStr + lastChar;
      read(lastChar);
    end;

    case identifierStr of
      'def': exit(TOK_DEF);
      'extern': exit(TOK_EXTERN);
      otherwise exit(TOK_IDENTIFIER)
    end;
  end;

  // lastChar Number: [0-9.]+
  if TCharacter.IsDigit(lastChar) then begin
    repeat
      numStr := numStr + lastChar;
      read(lastChar);
    until ((TCharacter.IsDigit(lastChar) = false) or (lastChar = '.'));
    numVal := StrToFloat(numStr);
    exit(TOK_NUMBER);
  end;

  if Eof then
    exit(TOK_EOF);
  // Whacha talkin about Willis?
  exit(TOK_ERROR);
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
