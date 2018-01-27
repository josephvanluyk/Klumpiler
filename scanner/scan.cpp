#include "scanner.h"
#include<iostream>


int main(){
	sym = nextSym();
	token tok = getNext();
	/*while(tok.lexeme != "."){
		tok = getNext();
	}*/
	while(tok.lexeme != "."){
		std::cout << tok.lineNumber << "\t" << tok.tokenName << "\t" << tok.lexeme << std::endl;
		tok = getNext();
	}
}
