// Constant definitions
const M: int;
axiom M == 5;

// Constant constraints
const N: int;
axiom N > 0;

const A, B: int;
axiom A + B == 5;

const C, D: int;
axiom C == D; // It used to be the case that if D is evaluated first, the first definition failed and as a result C was initialized to 0 instead of 5
axiom D == 5;

// Cyclic definition: a value has to be chosen
const E, F, G: int;
axiom E == F;
axiom F == G;
axiom G == E;

// Map definitions and constraints
const m: [int] int;
axiom (forall i: int :: (i > 0 ==> m[i] == i) && (i <= 0 ==> m[i] != 0));

// Function definitions and constraints
function f(int): int;
axiom (forall x: int :: x >= 0 ==> f(x)*f(x) == 16);
axiom (forall x: int :: x < 0 ==> f(x) == -x);

// Constraints with type guards
function g<a>(x: a): a;
axiom (forall i: int :: g(i) >= i); // This one should only apply for integer arguments
axiom (forall <b> x: b :: g(x) != x); // This one should apply for all arguments

// Where clauses
var x: int where x > 0;
var y: int where y != x;
var n: [int] int where (forall i: int :: n[i] != i);

// Local where clauses
procedure p(x: int) returns (y: int where y == x)
{
  var n: [int] int where (forall i: int :: n[i] != 1);
  havoc y, n;
  assert y == x;
  y := n[x];
  assert y != 1;
}

procedure Test() returns ()
  modifies x, y, n;
{
  var m1: [int] int;
  
  assert N > 0;  
  assert M == 5;  
  assert A + B == 5;
  
  assert D == 5;
  assert C == 5;
  
  assume G == 3;
  assert E == 3 && F == 3;
  
  assert m[5] == 5 && m[5000] == 5000;
  assert m[-1] != 0 && m[-5000] != 0;
  
  // m1 inherits constraints from m
  m1 := m[5 := 3][-1 := 0][-2 := 0];
  assert m1[5] == 3 && m1[5000] == 5000;
  assert m1[-1] == 0 && m1[-2] == 0 && m1[-5000] != 0;

  assert f(1000) == 4 || f(1000) == -4;
  assert f(-1000) == 1000;
  
  assert g(3) > 3;
  assert !g(true);  
  
  call y := p(0);
  
  havoc x, y, n;
  assert x > 0;
  assert y != x;
  assert n[0] != 0;
}