import nmi.assayoptimization.*;
import nmi.data.*;
import nmi.gui.*;
import nmi.tools.*;
import scpsolver.constraints.*;
import scpsolver.graph.*;
import scpsolver.infeas.*;
import scpsolver.lpsolver.*;
import scpsolver.problems.*;
import scpsolver.qpsolver.*;
import scpsolver.util.*;
import scpsolver.util.debugging.*;

void setup() {
  LinearProgram lp = new LinearProgram(new double[]{5.0,10.0});
  lp.addConstraint(new LinearBiggerThanEqualsConstraint(new double[]{3.0,1.0}, 8.0, "c1"));
  lp.addConstraint(new LinearBiggerThanEqualsConstraint(new double[]{0.0,4.0}, 4.0, "c2"));
  lp.addConstraint(new LinearSmallerThanEqualsConstraint(new double[]{2.0,0.0}, 2.0, "c3"));
  lp.setMinProblem(true);
  LinearProgramSolver solver  = SolverFactory.newDefault();
  double[] sol = new double[2];
  solver.solve(lp);
  print("sol");
  //print(sol[0]);
}

void draw(){
}
