program Lexer;

uses
  Character,
  SysUtils,
  TypInfo;
(* ********************* *)
// TYPES
// The lexer returns tokens [0-255]
// if it is an unknown character, otherwise one
// of these for known things.
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
// GLOBAL VARS
var
  identifierStr: string = '';
  numVal: double = 0;
  token: integer = ord(TOK_BASE);

(* ******************** *)
// FUNCTIONS
// gettok - Return the next token
// from standard input
function gettok: integer;

var
  lastChar: char = ' ';
  numStr: string = '';
  thisChar: char = ' ';

begin
  // Skip any whitespace
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
      'def': exit(ord(TOK_DEF));
      'extern': exit(ord(TOK_EXTERN));
      otherwise exit(ord(TOK_IDENTIFIER));
    end;
  end;

  // lastChar Number: [0-9.]+
  if TCharacter.IsDigit(lastChar) then begin
    repeat
      numStr := numStr + lastChar;
      read(lastChar);
    until ((TCharacter.IsDigit(lastChar) = false) or (lastChar = '.'));
    numVal := StrToFloat(numStr);
    exit(ord(TOK_NUMBER));
  end;

  // Comment until eol
  if lastChar = '#' then begin
    repeat
      read(lastChar)
    until (Eof or EoLn);

    if not Eof then
      exit(gettok);
  end;

  if Eof then
    exit(ord(TOK_EOF));

  // Otherwise just return the
  // character as it's ascii value
  thisChar := lastChar;
  read(lastChar);
  exit(ord(thisChar));

end; // gettok

(* ******************** *)
begin // Main
  write(StdErr, 'Ready > ');
  while token <> ord(TOK_EOF) do begin
    token := gettok;
    if token <> ord(TOK_BASE) then begin
      writeln;
      writeln(StdErr, 'The token is: ', GetEnumName(TypeInfo(TTOKEN), ord(token)));
      writeln(StdErr, 'The dentifier is: ', identifierStr);
      writeln(StdErr, 'The number is: ', numVal);
    end;
  end;
end. // Main
