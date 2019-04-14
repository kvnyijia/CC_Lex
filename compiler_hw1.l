/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>

	#define T_ID    300 
	#define T_INT   301
	#define T_SEMICOLON 302
	#define T_ASGN 303
    #define T_I_CONST 304
    
    #define T_FLOAT 306
    #define T_F_CONST 307
    #define T_BOOL 308
    #define T_FALSE 309
    #define T_STRING 310
    #define T_QUOTA 311
    #define T_STR_CONST 312

%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
all_char [\40-\176]
dot [\.]
eol [$]
space [ ]
quota ["]
slash [/]
newline [\n]
any_char_but_newline [.]

star [*]
lcom {slash}{star}
rcom {star}{slash}
non_rcom [^{rcom}]


id {letter}+({letter}|{digit})*
number {digit}+

i_const {digit}+
f_const {digit}+{dot}{digit}+
str_const {quota}{all_char}*{quota}
anything {any_char_but_newline}*

/* Rules section */
%x STR C_COMMENT CPP_COMMENT
%%

"+" 	 { printf("%s \t ADD\n", yytext); }
"-"		 { printf("%s \t SUB\n", yytext); }
"int"    { printf("%s \t INT\n", yytext); }
"float"  { printf("%s \t FLOAT\n", yytext); }
"bool"   { printf("%s \t BOOL\n", yytext); }
"string" { printf("%s \t STRING\n", yytext); }
";"      { printf("%s \t SEMICOLON\n", yytext); }
"="      { printf("%s \t ASGN\n", yytext); }
"false"  { printf("%s \t FALSE\n", yytext); }
"/*"     { printf("%s", yytext); BEGIN C_COMMENT; }
"//"     { printf("%s", yytext); BEGIN CPP_COMMENT; }

{id}	      { printf("%s \t ID\n", yytext); }
{i_const}     { printf("%s \t I_CONST\n", yytext); }
{f_const}     { printf("%s \t F_CONST\n", yytext); }
{quota}       { printf("%s \t QUOTA\n", yytext); BEGIN STR; }
{space}       {;}
<STR>{id}     { printf("%s \t STR_CONST\n", yytext); }
<STR>{quota}  { printf("%s \t QUOTA\n", yytext); BEGIN 0; }
<C_COMMENT>"*/"           { printf("%s \t C Comment\n", yytext); BEGIN 0; }
<CPP_COMMENT>{newline}    { printf("\t C++ Comment %s", yytext); BEGIN 0; }
\n			  {;}

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is 1.\n\n");
	printf("comment: 1 lines\n\n");

	return 0;
}
