#include "scanner.h"
token tok(0, "", "");
bool pal_program();
bool dcl_definitions();
bool procedure();
bool dcl_list();
bool statement_list();
bool statement();
bool assignment_statement();
bool write_statement();
bool expression();
bool term();
bool more_expression();
bool factor();
bool more_term();
bool mulop();
bool addop();
void error();
int main(){
	sym = nextSym();
	tok = getNext();
	bool parses = pal_program();

	if(parses){
		std::cout << "Successfully parsed." << std::endl;
	}else{
		error();
	}
}

bool pal_program(){
		if(dcl_definitions()){
			if(procedure()){
				return true;
			}
		}
		return false;
}

bool dcl_definitions(){
	if(tok.lexeme == "dcl"){
		tok = getNext();
		if(dcl_list()){
			return true;
		}
	}else{
		return true;
	}

	return false;
}

bool procedure(){
	if(tok.lexeme == "begin"){
		tok = getNext();
		if(statement_list()){
			if(tok.lexeme == "end"){
				tok = getNext();
				if(tok.lexeme == "."){
					tok = getNext();
					return true;
				}
			}
		}
	}
	return false;
}

bool dcl_list(){
	if(tok.tokenName == "Identifier"){
		tok = getNext();
		if(tok.lexeme == ":"){
			tok = getNext();
			if(tok.lexeme == "int"){
				tok = getNext();
				if(tok.lexeme == ";"){
					tok = getNext();
					if(dcl_list()){
						return true;
					}
				}
			}
		}
	}else{
		return true;
	}

	return false;
}


bool statement_list(){
	if(statement()){
		if(statement_list()){
			return true;
		}
	}else{
		return true;
	}

	return false;

}


bool statement(){
	if(assignment_statement()){
		return true;
	}else if(write_statement()){
		return true;
	}else{
		return false;
	}
}

bool assignment_statement(){
	if(tok.tokenName == "Identifier"){
		tok = getNext();
		if(tok.lexeme == ":="){
			tok = getNext();
			if(expression()){
				if(tok.lexeme == ";"){
					tok = getNext();
					return true;
				}
			}
		}
	}

	return false;
}


bool write_statement(){
	if(tok.lexeme == "writeln"){
		tok = getNext();
		if(tok.lexeme == "("){
			tok = getNext();
			if(tok.tokenName == "Identifier"){
				tok = getNext();
				if(tok.lexeme == ")"){
					tok = getNext();
					if(tok.lexeme == ";"){
						tok = getNext();
						return true;
					}
				}
			}
		}
	}

	return false;
}


bool expression(){
	if(term()){
		if(more_expression()){
			return true;
		}
	}

	return false;
}

bool more_expression(){
	if(addop()){
		if(term()){
			if(more_expression()){
				return true;
			}
		}

		return false;
	}

	return true;
}
bool term(){
	if(factor()){
		if(more_term()){
			return true;
		}
	}
	return false;
}

bool more_term(){
	if(mulop()){
		if(factor()){
			if(more_term()){
				return true;
			}
		}
		return false;
	}

	return true;
}

bool factor(){
	if(tok.tokenName == "Identifier"){
		tok = getNext();
		return true;
	}else if(tok.tokenName == "integer"){
		tok = getNext();
		return true;
	}else if(tok.lexeme == "("){
		tok = getNext();
		if(expression()){
			if(tok.lexeme == ")"){
				tok = getNext();
				return true;
			}
		}
	}

	return false;
}

bool addop(){
	if(tok.lexeme == "+"){
		tok = getNext();
		return true;
	}else if(tok.lexeme == "-"){
		tok = getNext();
		return true;
	}

	return false;
}

bool mulop(){
	if(tok.lexeme == "*"){
		tok = getNext();
		return true;
	}else if(tok.lexeme == "/"){
		tok = getNext();
		return true;
	}
	return false;
}
void error(){
	std::cout << "Error on line " << tok.lineNumber << std::endl;
	std::cout << "Unexpected token: " << tok.lexeme << std::endl;
}
