#pragma once
#include <algorithm>
#include <list>
#include <unordered_map>
#include <utility>
#include <vector>
#include "Nodes.h"

// #define DSS_DEBUG

void DASS(std::vector<ENode*>* enode_dag, std::vector<BBNode*>* bbnode_dag, std::string fileName);

// call argument print
void callArgPrint(std::vector<ENode*>* enode_dag, std::vector<BBNode*>* bbnode_dag, std::string fileName);
void searchInstr(ENode* node);
std::string demangle(const char* name);
std::string printName(Value *I);

// memory operation print
void memOpPrint(std::vector<ENode*>* enode_dag, std::vector<BBNode*>* bbnode_dag, std::string fileName);
