---
VHPOP C# Player Trace
---

---
David R. Winer
---


			///////////////////////
            //// Set path variables
            ///////////////////////

            Parser.path = @"D:\Documents\Frostbow\VHPOP-PlayTrace\Benchmarks\Rogelio_POCL_compilation\";

            // Where the Results will be inserted
            var directory = @"D:\Documents\Frostbow\VHPOP-PlayTrace\Benchmarks\Rogelio_POCL_compilation\Results";
            System.IO.Directory.CreateDirectory(directory);

            var domainDirectory = @"D:\Documents\Frostbow\VHPOP-PlayTrace\Benchmarks\Rogelio_POCL_compilation\domain.pddl";
            var problemDirectory = @"D:\Documents\Frostbow\VHPOP-PlayTrace\Benchmarks\Rogelio_POCL_compilation\prob01.pddl";
            var playerTraceDirectory  = @"D:\Documents\Frostbow\VHPOP-PlayTrace\Benchmarks\Rogelio_POCL_compilation\prob01.pddl";

            /////////////////////
            //// Read Domain ////
            /////////////////////

            var domain = Parser.GetDomain(domainDirectory, PlanType.PlanSpace);
            var problem = Parser.GetProblem(problemDirectory);

            // TODO: Remove those actions that are useless from domain
            // TODO: Reset problem to have proper goal conditions

            // Create Operators
            Console.WriteLine("Creating Ground Operators");
            GroundActionFactory.Reset();
            GroundActionFactory.PopulateGroundActions(domain, problem);

            // Create Causal Maps
            CacheMaps.Reset();
            CacheMaps.CacheLinks(GroundActionFactory.GroundActions);
            CacheMaps.CacheGoalLinks(GroundActionFactory.GroundActions, problem.Goal);

            // Create Initial State
            var iniTstate = new State(problem.Initial) as IState;

            // Use Initial State to Cache effort values VHPOP style
            CacheMaps.CacheAddReuseHeuristic(iniTstate);

            // Create Initial Plan
            var initPlan = PlanSpacePlanner.CreateInitialPlan(problem);

            ///////////////////////////
            //// Read Player trace ////
            ///////////////////////////

            // TODO: Create Trace
            // playerTraceDirectory

            /////////////////////
            //// Run Planner ////
            /////////////////////

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