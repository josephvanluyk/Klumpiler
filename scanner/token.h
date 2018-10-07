#ifndef TOKEN_H
#define TOKEN_H
#include<string>
class token{
public:
	std::string tokenName;
	std::string lexeme;
	int lineNumber;
	token(int n, std::string tn, std::string l):tokenName(tn), lexeme(l), lineNumber(n){};
};
#endif
