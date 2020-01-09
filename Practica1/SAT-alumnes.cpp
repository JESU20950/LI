#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;//modelo actual.
vector<int> modelStack;//pila de decision: las decisiones tienen un 0 delante.
uint indexOfNextLitToPropagate; //puntero a las cosas que tenemos que propagar.

uint decisionLevel;// si el decisionLevel es 0 y se encuentra un conflicto no hay solucion
vector<vector<int> > occurslistpositivo;//map con el literal y la lista de todas las clausulas que aparece el literal
vector<vector<int> > occurslistnegativo;

vector<int> frequencianegativos;
vector<int> frequenciapositivos;
vector<pair<int,int>> freq;
//Opcion 1
//cuantas veces aparece positivo y cuantas veces aparece negativo.
// variables+ variables- y coges el minimo. 
// a) estatica (variables+ variables- y coges el minimo) -> calcula 1 vez al principio
// b) dinamico (teniendo en cuenta solo las clausulas que no son ciertas-> ignorando las clausulas ya ciertas) y contando de mas las que son binarias
//Opcion 2
// 

bool comp(const pair<int,int>& a, const pair<int,int>& b){
    return a.second>b.second;
}
void readClauses( ){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }  
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);  
  occurslistnegativo.resize(numVars+1);
  occurslistpositivo.resize(numVars+1);
  
  frequencianegativos.resize(numVars+1);
  frequenciapositivos.resize(numVars+1);
  freq.resize(numVars);
  
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0){
        clauses[i].push_back(lit);
        if (lit>0){
        occurslistpositivo[lit].push_back(i);
        frequenciapositivos[lit]++;
        }
        else{
         occurslistnegativo[-lit].push_back(i);
         frequencianegativos[-lit]++;
        }
    }
  }
  
  for (uint i = 1; i<numVars+1; ++i){
   freq[i-1].first =  i;
   freq[i-1].second = min(frequenciapositivos[i],frequencianegativos[i]);
  }
  sort(freq.begin(),freq.end(),&comp);
}



int currentValueInModel(int lit){

  if (lit >= 0) return model[lit];

  else {

    if (model[-lit] == UNDEF) return UNDEF;

    else return 1 - model[-lit];

  }

}





void setLiteralToTrue(int lit){

  modelStack.push_back(lit);

  if (lit > 0) model[lit] = TRUE;

  else model[-lit] = FALSE;		

}



bool propagateGivesConflict () {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    int var = modelStack[indexOfNextLitToPropagate];
    ++indexOfNextLitToPropagate;
    if (var<0){
        for (uint i = 0; i < occurslistpositivo[-var].size(); ++i) {
            int clausula = occurslistpositivo[-var][i];
            bool someLitTrue = false;
            int numUndefs = 0;
            int lastLitUndef = 0;
            for (uint k = 0; not someLitTrue and k < clauses[clausula].size(); ++k){
                int val = currentValueInModel(clauses[clausula][k]);
                if (val == TRUE) someLitTrue = true;
                else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[clausula][k]; }
            }
            if (not someLitTrue and numUndefs == 0) return true; // conflict! all lits false
            else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);	
        }
    }else{
        for (uint i = 0; i < occurslistnegativo[var].size(); ++i) {
            int clausula = occurslistnegativo[var][i];
            bool someLitTrue = false;
            int numUndefs = 0;
            int lastLitUndef = 0;
            for (uint k = 0; not someLitTrue and k < clauses[clausula].size(); ++k){
                int val = currentValueInModel(clauses[clausula][k]);
                if (val == TRUE) someLitTrue = true;
                else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[clausula][k]; }
            }
            if (not someLitTrue and numUndefs == 0) return true; // conflict! all lits false
            else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);	
        }
    }
  }
  return false;
}


void backtrack(){

  uint i = modelStack.size() -1;

  int lit = 0;

  while (modelStack[i] != 0){ // 0 is the DL mark

    lit = modelStack[i];

    model[abs(lit)] = UNDEF;

    modelStack.pop_back();

    --i;

  }

  // at this point, lit is the last decision

  modelStack.pop_back(); // remove the DL mark

  --decisionLevel;

  indexOfNextLitToPropagate = modelStack.size();

  setLiteralToTrue(-lit);  // reverse last decision

}





// Heuristic for finding the next decision literal:

int getNextDecisionLiteral(){

  for (uint i = 1; i <= numVars; ++i) // stupid heuristic:

    if (model[freq[i].first] == UNDEF) return freq[i].first;  // returns first UNDEF var, positively

  return 0; // reurns 0 when all literals are defined
}

void checkmodel(){

  for (uint i = 0; i < numClauses; ++i){

    bool someTrue = false;

    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j)

      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);

    if (not someTrue) {

      cout << "Error in model, clause is not satisfied:";

      for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";

      cout << endl;

      exit(1);

    }

  }  

}

int main(){ 

  readClauses(); // reads numVars, numClauses and clauses

  model.resize(numVars+1,UNDEF);

  indexOfNextLitToPropagate = 0;  

  decisionLevel = 0;

  

  // Take care of initial unit clauses, if any

  for (uint i = 0; i < numClauses; ++i)

    if (clauses[i].size() == 1) {

      int lit = clauses[i][0];

      int val = currentValueInModel(lit);

      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}

      else if (val == UNDEF) setLiteralToTrue(lit);

    }

  

  // DPLL algorithm

  while (true) {

    while ( propagateGivesConflict() ) {

      if ( decisionLevel == 0) { cout << "UNSATISFIABLE" << endl; return 10; }

      backtrack();

    }

    int decisionLit = getNextDecisionLiteral();

    if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE" << endl; return 20; }

    // start new decision level:

    modelStack.push_back(0);  // push mark indicating new DL

    ++indexOfNextLitToPropagate;

    ++decisionLevel;

    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark

  }

}  
