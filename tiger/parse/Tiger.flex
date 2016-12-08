package tiger.parse;
import tiger.errormsg.ErrorMsg;
%%

%cup
%char
%state COMMENT


%{
public int comment = 0;

private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
	errorMsg.error(pos, s);
}

private void err(String s) {
	err(yychar, s);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
	return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

public Yylex(java.io.Reader r, ErrorMsg e) {
  this(r);
  errorMsg = e;
}

private ErrorMsg errorMsg;

%}

%eofval{
{
	return tok(sym.EOF, null);
}
%eofval}

LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t\f]


%%

<YYINITIAL> {
	{LineTerminator}	{ newline(); }
	{WhiteSpace}	{ /* do nothing */ }

	/* Token : Keywords */
  "array"  { return tok(sym.ARRAY, null); }
  "if"  { return tok(sym.IF, null); }
  "then"  { return tok(sym.THEN, null); }
  "else"  { return tok(sym.ELSE, null); }
  "while"  { return tok(sym.WHILE, null); }
  "for"  { return tok(sym.FOR, null); }
  "to"  { return tok(sym.TO, null); }
  "do"  { return tok(sym.DO, null); }
  "let"  { return tok(sym.LET, null); }
  "in"  { return tok(sym.IN, null); }
  "end"  { return tok(sym.END, null); }
  "of"  { return tok(sym.OF, null); }
  "break"  { return tok(sym.BREAK, null); }
  "nil"  { return tok(sym.NIL, null); }
  "function"  { return tok(sym.FUNCTION, null); }
  "var"  { return tok(sym.VAR, null); }
  "type"  { return tok(sym.TYPE, null); }
  /*"class"  { return tok(sym.CLASS, null); }*/


	/* Token : Identifiers */

  [a-zA-Z_][a-zA-Z0-9_]* { return tok(sym.ID, new String(yytext())); }
	/*
		{Identifier} { return tok(sym.ID, yytext()); }
	*/

	/* Token : Integer */

//	// should we check very long integer in there?
//	[0-9]+ { return tok(sym.INT, new Integer(yytext())); }
//
	// or not?
	[0-9]+ { return tok(sym.INT, new String(yytext())); }

	/* Token : String */
  	// TODO

  \"(\\.|[^\"])*\" { return tok(sym.STRING, new String(yytext())); }

  	/* Token : SEPARATORS AND OPERATORS */

	"," { return tok(sym.COMMA, null); }
	"."	{ return tok(sym.DOT, null); }
	";"	{ return tok(sym.SEMICOLON, null); }
	":"	{ return tok(sym.COLON, null); }
	"("	{ return tok(sym.LPAREN, null); }
	")"	{ return tok(sym.RPAREN, null); }
	"["	{ return tok(sym.LBRACK, null); }
	"]"	{ return tok(sym.RBRACK, null); }
	"{"	{ return tok(sym.LBRACE, null); }
	"}"	{ return tok(sym.RBRACE, null); }

	"+"	{ return tok(sym.PLUS, null); }
	"-"	{ return tok(sym.MINUS, null); }
	"*"	{ return tok(sym.TIMES, null); }
	"/"	{ return tok(sym.DIVIDE, null); }

	"="	{ return tok(sym.EQ, null); }
	"<>"	{ return tok(sym.NEQ, null); }
	"<"	{ return tok(sym.LT, null); }
	"<="	{ return tok(sym.LE, null); }
	">"	{ return tok(sym.GT, null); }
	">="	{ return tok(sym.GE, null); }

  ":=" { return tok(sym.ASSIGN, null); }

	"&"	{ return tok(sym.AND, null); }
	"|"	{ return tok(sym.OR, null); }



	"/*" { yybegin(COMMENT); ++comment;}


	[^] { return tok(sym.error, yytext()); }
}

<COMMENT>{
  "/*" {++comment;}
  "*/" {if(--comment == 0) {yybegin(YYINITIAL);} }
  [^] {}

}
