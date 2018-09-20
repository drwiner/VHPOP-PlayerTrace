using System;
using System.Collections.Generic;
using BoltFreezer.CacheTools;
using BoltFreezer.Enums;
using BoltFreezer.FileIO;
using BoltFreezer.Interfaces;
using BoltFreezer.PlanSpace;
using BoltFreezer.PlanTools;

namespace TestVHPOP
{
    class TestAll
    {

        public static void RunPlanner(IPlan initPi, ISearch SearchMethod, ISelection SelectMethod, int k, float cutoff, string directoryToSaveTo, int problem)
        {
            // Create a planner object to run this instance
            var POP = new PlanSpacePlanner(initPi, SelectMethod, SearchMethod, true)
            {
                directory = directoryToSaveTo,
                problemNumber = problem,
            };

            // Return a list of k solutions
            var Solutions = POP.Solve(k, cutoff);

            // Print the first solution to console
            if (Solutions != null)
            {
                Console.Write(Solutions[0].ToStringOrdered());
            }
        }



        static void Main(string[] args)
        {

            Console.Write("hello world\n");
           
            ///////////////////////
            //// Set path variables
            ///////////////////////

            Parser.path = @"D:\Documents\Frostbow\VHPOP-PlayTrace\Benchmarks\Rogelio_POCL_compilation";

            // Where the Results will be inserted
            var directory = Parser.path + @"\Results";
            System.IO.Directory.CreateDirectory(directory);

            // Where the ground operator instances will be cached
            var problemFreezeDirectory = Parser.path + @"\Cached\";
            System.IO.Directory.CreateDirectory(problemFreezeDirectory);

            // Where to read the domain and problem
            var domainDirectory = Parser.path + @"\domain.pddl";
            var problemDirectory = Parser.path + @"\prob01.pddl";

            // Where to read the player trace
            var playerTraceDirectory  = Parser.path + @"\chronology_arthur156.pddl";

            /////////////////////
            //// Read Domain ////
            /////////////////////

            var domain = Parser.GetDomain(domainDirectory, PlanType.PlanSpace);
            var problem = Parser.GetProblem(problemDirectory);

            // Create Operators
            Console.WriteLine("Creating Ground Operators");
            GroundActionFactory.Reset();

            /*
             * For compiling the player trace, we only need just those ground instances of steps that appear in the trace
             * Whereas typically one can follow the following code to Serialize and Deserialize all ground action instances as follows...
             * 
             *  /*
             *  
             *  // To Serialize: it's a large problem, so we only want to read this once.
             *  ProblemFreezer.Serialize(domain, problem, problemFreezeDirectory);
             *  
             *  //// To Deserialize, if we're already read it and serialized
             *  ////ProblemFreezer.Deserialize(problemFreezeDirectory);
             *  
             *  //// If you want to avoid serialization/deserialization, you've got to do this every time.
             *  ////GroundActionFactory.PopulateGroundActions(domain, problem);
             *  /*
             *  
             *  Here instead we read the player trace and compile just those action instances that appear. Note then that this removes the functionality of considering "what-if" actions
             */

            //////////////////////////////////////////////////////
            //// Read Player trace ///////////////////////////////
            //////////////////////////////////////////////////////

            // Needs to be set manually because we aren't running standard "Populate" method
            GroundActionFactory.CreateTypeDict(domain, problem);

            // playerTraceDirectory
            var PlanStepList = PlayerTraceUtilities.ReadPlayerTrace(playerTraceDirectory, domain, problem);

            // Remove those that aren't any good
            PlanStepList = PlayerTraceUtilities.RemoveUseless(PlanStepList);

            // Find Quests completed to create goal conditions.
            var goals = PlayerTraceUtilities.CreateGoalDisjunctions(problem.Initial, PlanStepList);
            problem.Goal = goals;

            /////////////////////////////////////////////////////////////////////////////////
            // Create Causal Maps (using just those gorund actions found in the plan trace
            /////////////////////////////////////////////////////////////////////////////////

            CacheMaps.Reset();
            CacheMaps.CacheLinks(GroundActionFactory.GroundActions);
            CacheMaps.CacheGoalLinks(GroundActionFactory.GroundActions, problem.Goal);

            //////////////////////////////////////////////////////
            // Create Initial State ///////////////////////////
            //////////////////////////////////////////////////////

            var iniTstate = new State(problem.Initial) as IState;

            // Use Initial State to Cache effort values VHPOP style
            CacheMaps.CacheAddReuseHeuristic(iniTstate);

            //////////////////////////////////////////////////////
            // Create Initial Plan///////////////////////////
            //////////////////////////////////////////////////////

            // Need to modify goal state
            var initPlan = PlanSpacePlanner.CreateInitialPlan(problem);

            var lastInsertedStep = initPlan.InitialStep;
            foreach(var step in PlanStepList)
            {
                initPlan.Insert(step);
                initPlan.Orderings.Insert(lastInsertedStep, step);
                lastInsertedStep = step;
            }


            ////////////////////////////////////////////////
            //// Run Planner ///////////////////////////////
            ////////////////////////////////////////////////

            // Time limit in milliseconds for search
            var cutoff = 600000f;

            // Number of plans to return
            var k = 1;

            // Static method called
            RunPlanner(initPlan.Clone() as IPlan, new ADstar(), new E0(new AddReuseHeuristic()), k, cutoff, directory, 1);

            /*
             *  ************************************************************
             *  *************** Other ways to run the planner **************
             *  ************************************************************
             *  RunPlanner(initPlan.Clone() as IPlan, new ADstar(), new E0(new NumOpenConditionsHeuristic()), k, cutoff, directory, 1);
             *  RunPlanner(initPlan.Clone() as IPlan, new DFS(), new Nada(new ZeroHeuristic()), k, cutoff, directory, 1);
             *  RunPlanner(initPlan.Clone() as IPlan, new BFS(), new Nada(new ZeroHeuristic()), k, cutoff, directory, 1);
            */
        }
    }

}
