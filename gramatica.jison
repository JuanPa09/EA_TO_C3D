
//Analisis Léxico
%lex
%options case-insensitive
%%

"evaluar"               return 'evaluar'

//Simbolos
"("                     return 'parizq';
")"                     return 'parder';
"["                     return 'corizq';
"]"                     return 'corder';    
"+"                     return 'mas';
"-"                     return 'menos';
"*"                     return 'por';
"/"                     return 'div';

//Valores
([a-zA-Z])[a-zA-Z0-9_]*	return 'id';
[0-9]+("."[0-9]+)?\b  	return 'decimal';
[0-9]+\b				return 'entero';

<<EOF>>				return 'EOF';

.					{ console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

%{
    const instruccionesApi = require('./instrucciones').instruccionesApi
%}

/* Precedencia y Asociacion de operadores*/

%left 'mas' 'menos'
%left 'por' 'div'

%start ini

//Empieza analisis sintactico
%%

ini
            : INSTRUCCIONES EOF {}
            ;

INSTRUCCIONES
            : INSTRUCCION INSTRUCCIONES             {}
            | INSTRUCCION                           {console.log("\n---------------Nueva Operacion---------------\n"+$1.c3d);}
            | error                                 { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
            ;

INSTRUCCION
            : evaluar corizq OPERACION corder {$$ = {c3d:$3.c3d}}
            ;


OPERACION   
            : OPERACION mas OPERACION           {$$ = {tmp: instruccionesApi.newTemp()};
                                                 $$ = {tmp: $$.tmp, c3d:$1.c3d + $3.c3d + $$.tmp + "=" + $1.tmp + "+" + $3.tmp+"\n"}}
            | OPERACION menos OPERACION         {$$ = {tmp: instruccionesApi.newTemp()};
                                                 $$ = {tmp: $$.tmp, c3d:$1.c3d + $3.c3d + $$.tmp + "=" + $1.tmp + "-" + $3.tmp+"\n"}}
            | OPERACION por OPERACION           {$$ = {tmp: instruccionesApi.newTemp()};
                                                 $$ = {tmp: $$.tmp, c3d:$1.c3d + $3.c3d + $$.tmp + "=" + $1.tmp + "*" + $3.tmp+"\n"}}
            | OPERACION div OPERACION           {$$ = {tmp: instruccionesApi.newTemp()};
                                                 $$ = {tmp: $$.tmp, c3d:$1.c3d + $3.c3d + $$.tmp + "=" + $1.tmp + "/" + $3.tmp+"\n"}}
            | parizq OPERACION parder           {$$ = {tmp:$2.tmp, c3d:$2.c3d}}
            | id                                {$$ = {tmp: $1, c3d: ""}}
            | entero                            {$$ = {tmp: $1, c3d: ""}}
            | decimal                           {$$ = {tmp: $1, c3d: ""}}
            ;
