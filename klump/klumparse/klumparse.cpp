#include "../../scanner/scanner.h"
#include "stdlib.h"
const int FOUND = 1;
const int DOES_NOT_MATCH = 0;
const int FAILED = -1;
token tok(0, "", "");
int klump_program();
int global_definitions();
int const_definitions();
int const_list();
int _const();
int type_definitions();
int type_list();
int struct_type();
int array_type();
int record_type();
int fld_list();
int dcl_definitions();
int dcl_list();
int dcl_type();
int atomic_type();
int proc_declarations();
int signature_list();
int proc_signature();
int formal_args();
int formal_arg_list();
int formal_arg();
int call_by();
int return_type();
int actual_args();
int actual_arg_list();
int actual_arg();
int procedure_list();
int procedure();
int proc_head();
int proc_body();
int statement_list();
int statement();
int label();
int exec_statement();
int read_statement();
int write_statement();
int assign_statement();
int call_statement();
int return_statement();
int goto_statement();
int empty_statement();
int compound_statement();
int if_statement();
int else_clause();
int while_statement();
int case_statement();
int case_list();
int for_statement();
int next_statement();
int break_statement();
int expression();
int comparison();
int simple_expression();
int term();
int factor();
int compop();
int addop();
int mulop();
int unary();
int lval();
int func_ref();
int qualifier();
bool match_token(std::string a, std::string b);
void error();

void error(){
	std::cerr << "Error on line " << tok.lineNumber << std::endl;
	std::cerr << tok.lineNumber - 1 << ": " << lineOne;
	if(tok.lineNumber == 0){
		std::cerr << std::endl;
	}
	std::cerr << tok.lineNumber << ": " << lineTwo << std::endl;
	std::cerr << "Unexpected token: " << tok.lexeme << std::endl;
	std::cerr << "TokenName: " << tok.tokenName << std::endl;
	exit(EXIT_FAILURE);
}

bool match_token(std::string a, std::string b){
	if(a == b){
		tok = getNext();
		return true;
	}
	return false;
}

int main(){
	sym = nextSym();
	tok = getNext();
	int parses = klump_program();
	if(parses == FOUND){
		std::cout << "Parsed Successfully" << std::endl;
	}else{
		error();
	}
}

//<klump_program> -> <global_definitions><procedure_list>.
int klump_program(){
	if(global_definitions() == FOUND){
		if(procedure_list() == FOUND){
			if(match_token(tok.lexeme, ".")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<global_definitions> -> GLOBAL <const_definitions> <type_definitons> <dcl_definitions> <proc_declarations> | ""
int global_definitions(){
	if(match_token(tok.lexeme, "global")){
		if(const_definitions() == FOUND && type_definitions() == FOUND && dcl_definitions() == FOUND && proc_declarations() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

//<const_definitions> -> CONST <const_list> | ""
int const_definitions(){
	if(match_token(tok.lexeme, "const")){
		if(const_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}


int const_list(){
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")
			&& _const() == FOUND
			&& match_token(tok.lexeme, ";"))
		{

		}else{
			error();
		}
	}
	return FOUND;
}


int _const(){
	if(match_token(tok.tokenName, "number") || match_token(tok.tokenName, "decimal") || match_token(tok.tokenName, "cstring")){
		return FOUND;
	}
	return DOES_NOT_MATCH;
}

int type_definitions(){
	if(match_token(tok.lexeme, "type")){
		if(type_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int type_list(){
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")
			&& struct_type() == FOUND
			&& match_token(tok.lexeme, ";")){

			}else{
				error();
			}
	}
	return FOUND;
}


int struct_type(){
	if(array_type() == DOES_NOT_MATCH){
		return record_type();
	}

	return FOUND;
}


int array_type(){
	if(match_token(tok.lexeme, "array")){
		if(match_token(tok.lexeme, "[")
		&& match_token(tok.tokenName, "number")
		&& match_token(tok.lexeme, "]")
		&& match_token(tok.lexeme, "of")
		&& dcl_type() == FOUND){
			return FOUND;
		}else{
			error();
		}
	}
	return DOES_NOT_MATCH;
}


int record_type(){
	if(match_token(tok.lexeme, "record")){
		if(fld_list() == FOUND && match_token(tok.lexeme, "end")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}


int fld_list(){
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")
			&& dcl_type() == FOUND
			&& match_token(tok.lexeme, ";")){

			}else{
				error();
			}
	}
	return FOUND;
}

int dcl_definitions(){
	if(match_token(tok.lexeme, "dcl")){
		if(dcl_list() == FOUND){
			return FOUND;
		}else{
			error();
		}
	}
	return FOUND;
}


int dcl_list(){
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")
			&& dcl_type() == FOUND
			&& match_token(tok.lexeme, ";")){

			}else{
				error();
			}
	}

	return FOUND;
}

int dcl_type(){
	if(atomic_type() == FOUND){
		return FOUND;
	}else{
		if(match_token(tok.tokenName, "Identifier")){
			return FOUND;
		}else{
			return DOES_NOT_MATCH;
		}
	}
}


int atomic_type(){
	if(match_token(tok.lexeme, "bool") || match_token(tok.lexeme, "real")
		|| match_token(tok.lexeme, "int") || match_token(tok.lexeme, "string")){
			return FOUND;
		}
	return DOES_NOT_MATCH;
}

int proc_declarations(){
	if(match_token(tok.lexeme, "proc")){
		if(signature_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int signature_list(){
	if(proc_signature() == FOUND){
		while(match_token(tok.lexeme, ";")){
			if(proc_signature() == FOUND){
			}else{
				return FOUND;
			}
		}

	}
	return FOUND;
}

int proc_signature(){
	if(match_token(tok.tokenName, "Identifier")){
		if(formal_args() == FOUND && return_type() == FOUND){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int formal_args(){
	if(match_token(tok.lexeme, "(")){
		if(formal_arg_list() == FOUND){
			if(match_token(tok.lexeme, ")")){
				return FOUND;
			}
		}
		error();

	}
	return FOUND;
}

int formal_arg_list(){

	if(formal_arg() == FOUND){
		while(match_token(tok.lexeme, ",")){
			if(formal_arg() == FOUND){

			}else{
				error();
			}
		}
		return FOUND;
	}
	return FOUND;

}

int formal_arg(){
	if(call_by() == FOUND){
		if(match_token(tok.tokenName, "Identifier") && match_token(tok.lexeme, ":") && dcl_type() == FOUND){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int call_by(){
	if(match_token(tok.lexeme, "var")){
		return FOUND;
	}

	return FOUND;
}

int return_type(){
	if(match_token(tok.lexeme, ":")){
		if(atomic_type() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int actual_args(){
	if(match_token(tok.lexeme, "(")){
		if(actual_arg_list() == FOUND){
			if(match_token(tok.lexeme, ")")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int actual_arg_list(){
	if(actual_arg() == FOUND){
		while(match_token(tok.lexeme, ",") ){
			if(actual_arg() == FOUND){
			}else{
				error();
			}
		}
		return FOUND;
	}
	return DOES_NOT_MATCH;

}

int actual_arg(){
	return expression();
}

int procedure_list(){
	while(procedure() == FOUND){
	}
	return FOUND;
}

int procedure(){
	if(proc_head() == FOUND){
		if(proc_body() == FOUND){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int proc_head(){
	if(match_token(tok.lexeme, "procedure")){
		if(match_token(tok.tokenName, "Identifier")){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int proc_body(){
	if(dcl_definitions() == FOUND){
		if(match_token(tok.lexeme, "begin")){
			if(statement_list() == FOUND){
				if(match_token(tok.lexeme, "end")){
					return FOUND;
				}
			}
		}
		error();
		}
	return DOES_NOT_MATCH;
}
int statement_list(){
	while(statement() == FOUND){

	}
	return FOUND;
}
int statement(){
	if(label() == FOUND){
		if(exec_statement() == FOUND){
			return FOUND;
		}
		return DOES_NOT_MATCH;
	}
	return DOES_NOT_MATCH;
}
int label(){
	if(match_token(tok.lexeme, "#")){
		if(match_token(tok.tokenName, "number")){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int exec_statement(){

	int result = read_statement();
	if(result == FOUND){
		return result;
	}

	result = write_statement();
	if(result == FOUND){
		return result;
	}
	result = assign_statement();
	if(result == FOUND){
		return result;
	}
	result = call_statement();
	if(result == FOUND){
		return result;
	}

	result = return_statement();
	if(result == FOUND){
		return result;
	}

	result = goto_statement();
	if(result == FOUND){
		return result;
	}

	result = empty_statement();
	if(result == FOUND){
		return result;
	}

	result = compound_statement();
	if(result == FOUND){
		return result;
	}

	result = if_statement();
	if(result == FOUND){
		return result;
	}

	result = while_statement();
	if(result == FOUND){
		return result;
	}

	result = case_statement();
	if(result == FOUND){
		return result;
	}
	result = for_statement();
	if(result == FOUND){
		return result;
	}
	result = next_statement();
	if(result == FOUND){
		return result;
	}


	result = break_statement();
	if(result == FOUND){
		return result;
	}
	return DOES_NOT_MATCH;
}


int read_statement(){
	if(match_token(tok.lexeme, "read") || match_token(tok.lexeme, "readln")){
		if(actual_args() == FOUND){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int write_statement(){
	if(match_token(tok.lexeme, "write") || match_token(tok.lexeme, "writeln")){
		if(actual_args() == FOUND){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}


int assign_statement(){
	if(match_token(tok.tokenName, "Identifier")){
		if(qualifier() == FOUND){
			if(match_token(tok.lexeme, ":=")){
				if(expression() == FOUND){
					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int call_statement(){
	if(match_token(tok.lexeme, "call")){
		if(match_token(tok.tokenName, "Identifier")){
			if(actual_args() == FOUND){
				if(match_token(tok.lexeme, ";")){
					return FOUND;
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int return_statement(){
	if(match_token(tok.lexeme, "return")){

			if(expression() == FOUND){

					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}

			}

		error();
	}
	return DOES_NOT_MATCH;
}

int goto_statement(){
	if(match_token(tok.lexeme, "goto")){
		if(label() == FOUND){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int empty_statement(){
	if(match_token(tok.lexeme, ";")){
		return FOUND;
	}
	return DOES_NOT_MATCH;
}
int compound_statement(){
	if(match_token(tok.lexeme, "do")){
		if(match_token(tok.lexeme, ";")){
			if(statement_list() == FOUND){
				if(match_token(tok.lexeme, "end")){
					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}
				}
			}
		}
		error();
	}

	return DOES_NOT_MATCH;
}


int if_statement(){
	if(match_token(tok.lexeme, "if")){
		if(match_token(tok.lexeme, "(")){
			if(comparison() == FOUND){
				if(match_token(tok.lexeme, ")")){
					if(match_token(tok.lexeme, "then")){
						if(statement() == FOUND){
							if(else_clause() == FOUND){
								return FOUND;
							}
						}
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int else_clause(){
	if(match_token(tok.lexeme, "else")){
		if(statement() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int while_statement(){
	if(match_token(tok.lexeme, "while")){
		if(match_token(tok.lexeme, "(")){
			if(comparison() == FOUND){
				if(match_token(tok.lexeme, ")")){
					if(compound_statement() == FOUND){
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int case_statement(){
	if(match_token(tok.lexeme, "case")){
		if(match_token(tok.lexeme, "(")){
			if(expression() == FOUND){
				if(match_token(tok.lexeme, ")")){
					if(case_list() == FOUND){
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int case_list(){
	bool pass = false;
	bool firstpass = false;
	while(unary() == FOUND){
		firstpass = true;
		if(match_token(tok.tokenName, "number")){
			if(match_token(tok.lexeme, ":")){
				if(statement() == FOUND){
					pass = true;
				}
			}
		}
		if(pass){
			pass = !pass;
		}else{
			error();
		}

	}

	if(match_token(tok.lexeme, "default")){
		if(match_token(tok.lexeme, ":")){
			if(statement() == FOUND){
				return FOUND;
			}
		}
		error();
	}
	if(firstpass){
		error();
	}
	return DOES_NOT_MATCH;

}

int for_statement(){
	if(match_token(tok.lexeme, "for")){
		if(match_token(tok.tokenName, "Identifier")){
			if(match_token(tok.lexeme, ":=")){
				if(expression() == FOUND){
					if(match_token(tok.lexeme, "to") || match_token(tok.lexeme, "downto")){
						if(expression() == FOUND){
							if(statement() == FOUND){
								return FOUND;
							}
						}
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int next_statement(){
	if(match_token(tok.lexeme, "next")){
		if(match_token(tok.lexeme, ";")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int break_statement(){
	if(match_token(tok.lexeme, "break")){
		if(match_token(tok.lexeme, ";")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int expression(){
	return comparison();
}

int comparison(){
	if(simple_expression() == FOUND){
		while(compop() == FOUND){
			if(simple_expression() == FOUND){

			}else{
				error();
			}
		}
		return FOUND;
	}
	return DOES_NOT_MATCH;

}

int simple_expression(){
	bool pass = false;
	if(unary() == FOUND){
		if(term() == FOUND){
			while(addop() == FOUND){
				if(term() == FOUND){
					pass = true;
				}else{
					error();
				}
			}
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int term(){

	if(factor() == FOUND){
		while(mulop() == FOUND){
			if(factor() == FOUND){
			}else{
				error();
			}
		}
		return FOUND;
	}
	return DOES_NOT_MATCH;
}

int factor(){
	int result;
	result = _const();
	if(result == FOUND || result == FAILED){
		return result;
	}
	if(match_token(tok.lexeme, "(")){
		if(expression() == FOUND){
			if(match_token(tok.lexeme, ")")){
				return FOUND;
			}
		}
		error();
	}

	if(match_token(tok.lexeme, "not")){
		if(factor() == FOUND){
			return FOUND;
		}
		error();
	}


	/* Lval or fun_ref? */
	/* First token is an Identifier...*/
	if(match_token(tok.tokenName, "Identifier")){
		/*If it's followed by a qualifier, we have an lval*/
		if(actual_args() == FOUND){
			return FOUND;
		}else if(qualifier() == FOUND){
			return FOUND;
		}
	}

	return DOES_NOT_MATCH;
}


int compop(){
	if(match_token(tok.lexeme, "=")){
		return FOUND;
	}else if(match_token(tok.lexeme, "<>")){
		return FOUND;
	}else if(match_token(tok.lexeme, "<")){
		return FOUND;
	}else if(match_token(tok.lexeme, ">")){
		return FOUND;
	}else if(match_token(tok.lexeme, ">=")){
		return FOUND;
	}else if(match_token(tok.lexeme, "<=")){
		return FOUND;
	}

	return DOES_NOT_MATCH;
}

int addop(){
	if(match_token(tok.lexeme, "+")){
		return FOUND;
	}else if(match_token(tok.lexeme, "-")){
		return FOUND;
	}else if(match_token(tok.lexeme, "or")){
		return FOUND;
	}

	return DOES_NOT_MATCH;
}

int mulop(){
	if(match_token(tok.lexeme, "*")){
		return FOUND;
	}else if(match_token(tok.lexeme, "/")){
		return FOUND;
	}else if(match_token(tok.lexeme, "%")){
		return FOUND;
	}else if(match_token(tok.lexeme, "and")){
		return FOUND;
	}

	return DOES_NOT_MATCH;
}

int unary(){
	if(match_token(tok.lexeme, "+")){
		return FOUND;
	}else if(match_token(tok.lexeme, "-")){
		return FOUND;
	}else{
		return FOUND;
	}
}


int qualifier(){
	if(match_token(tok.lexeme, "[")){
		if(expression() == FOUND){
			if(match_token(tok.lexeme, "]")){
				if(qualifier() == FOUND){
					return FOUND;
				}
			}
		}
		error();
	}

	if(match_token(tok.lexeme, ".")){
		if(match_token(tok.tokenName, "Identifier")){
			if(qualifier() == FOUND){
				return FOUND;
			}
		}
		error();
	}

	return FOUND;
}
