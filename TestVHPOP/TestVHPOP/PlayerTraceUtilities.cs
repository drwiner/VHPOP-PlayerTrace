using BoltFreezer.Interfaces;
using BoltFreezer.PlanTools;
using BoltFreezer.Utilities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TestVHPOP
{
    public class PlayerTraceUtilities
    {

        public static List<IPlanStep> ReadPlayerTrace(string directory, Domain domain, Problem problem)
        {
            var planTrace = new List<IPlanStep>();

            string[] input = System.IO.File.ReadAllLines(directory);

            foreach (var line in input)
            {
                var opToken = PlayerTraceUtilities.CreateOperatorToken(line);
                var iopToken = PlayerTraceUtilities.AddPreconditionsAndEffects(opToken, domain);

                // make sure we don't accidentally use.... <_<, >_>
                opToken = null;

                var newStep = new PlanStep();

                if (GroundActionFactory.GroundActions.Contains(iopToken))
                {
                    var opIndex = GroundActionFactory.GroundActions.IndexOf(iopToken);
                    var existingOpToken = GroundActionFactory.GroundActions[opIndex];
                    newStep = new PlanStep(existingOpToken.Clone() as IOperator);

                }
                else
                {
                    GroundActionFactory.InsertOperator(iopToken);
                    newStep = new PlanStep(iopToken.Clone() as IOperator);
                }

                planTrace.Add(newStep);
            }

            return planTrace;
        }

        public static Operator CreateOperatorToken(string stringItem)
        {
            var splitInput = stringItem.Split(' ');
            var predName = splitInput[0].TrimStart('(');

            var terms = new List<ITerm>();
            foreach (string item in splitInput.Skip(1))
            {
                var cleanedItem = item.TrimEnd(')');
                var newTerm = new Term(cleanedItem, true) as ITerm;
                terms.Add(newTerm);
            }
            return new Operator(predName, terms, new Hashtable(), new List<IPredicate>(), new List<IPredicate>());
        }

        public static IOperator AddPreconditionsAndEffects(Operator opToken, Domain domain)
        {
            foreach(var op in domain.Operators)
            {
                if (!opToken.Name.Equals(op.Name))
                {
                    continue;
                }

                for (int i = 0; i < op.Terms.Count; i++)
                {
                    var term = opToken.Terms[i];
                    term.Variable = op.Terms[i].Variable;
                    opToken.AddBinding(term.Variable, term.Constant);
                }

                var groundOperator = new Operator(opToken.Name, opToken.Terms, opToken.Bindings, op.Preconditions.ToList(), op.Effects.ToList());
                groundOperator.UpdateBindings();
                // Check to see if bindings are propagated to preconditiosn and effects
                Console.Write(groundOperator);
                return groundOperator as IOperator;
            }
            return null;
        }

        public static List<IPlanStep> RemoveUseless(List<IPlanStep> trace)
        {
            var newSteps = new List<IPlanStep>();
            foreach (var step in trace)
            {

                var genericName = step.ToString().Split(new string[] { ")-" }, StringSplitOptions.None)[0] + ")";
                if (
                    // ...do not effect a state change
                    !step.Name.Equals("talk-to") &&
                    !step.Name.Equals("look-at") &&

                    // ...are just for flavor
                    (!genericName.Equals("(give alli ash arthur junkyard)")) &&
                    (!genericName.Equals("(drop arthur ash fort)")) &&
                    (!genericName.Equals("(drop arthur ash junkyard)")) &&

                    // ...cannot be used directly by the player
                    !step.Name.Equals("donothing") &&
                    !step.Name.Equals("win-the-game") &&

                    // ...are part of the tutorial
                    !genericName.Equals("(pickup arthur basementbucket storage)") &&
                    !genericName.Equals("(drop arthur basementbucket storage)") &&
                    !genericName.Equals("(pickup arthur basementbucket storage)") &&
                    !genericName.Equals("(give arthur basementbucket mel storage)") &&
                    !genericName.Equals("(give mel basementexitkey arthur storage)") &&
                    !genericName.Equals("(move-through-doorway arthur storage basement)") &&
                    !genericName.Equals("(unlock-entrance arthur basementexitkey basementexit basement)") &&
                    !genericName.Equals("(open arthur basementexit basement)") &&
                    !genericName.Equals("(move-through-entrance arthur basement basementexit bar)") &&
                    !genericName.Equals("(close arthur basemententrance bar)")
                    )
                    {
                        newSteps.Add(step);
                    }
            }
            return newSteps;
        }

        public static ITerm AsTerm(string name)
        {
            return new Term(name, true) as ITerm;
        }

        public static IPredicate BasicBitchTerm(IPredicate original)
        {

            return new Predicate(original.Name, original.Terms.Select(term => new Term(term.Constant, true) as ITerm).ToList(), original.Sign) as IPredicate;
        }

        public static List<IPredicate> CreateGoalDisjunctions(List<IPredicate> initial, List<IPlanStep> trace)
        {
            var goalConditions = new List<IPredicate>();

            List<List<IPredicate>> goalDisjunctions = new List<List<IPredicate>>();

            var EquipQuest = new List<IPredicate>();
            var ian = new Term("ian", true) as ITerm;
            var knightsword = new Term("knightsword", true) as ITerm;
            var knightshield = new Term("knightshield", true) as ITerm;
            EquipQuest.Add(new Predicate("has", new List<ITerm>() { ian, knightsword }, true) as IPredicate);
            EquipQuest.Add(new Predicate("has", new List<ITerm>() { ian, knightshield }, true) as IPredicate);
            goalDisjunctions.Add(EquipQuest);

            var PilgrimageQuest = new List<IPredicate>();
            var alli = AsTerm("alli");
            var tastycupcake = AsTerm("tastycupcake");
            PilgrimageQuest.Add(new Predicate("has", new List<ITerm>() { alli, tastycupcake }, true) as IPredicate);
            goalDisjunctions.Add(PilgrimageQuest);

            var WisdomQuest = new List<IPredicate>();
            var james = AsTerm("james");
            var coin = AsTerm("coin");
            var humanskull = AsTerm("humanskull");
            var candle = AsTerm("candle");
            WisdomQuest.Add(new Predicate("has", new List<ITerm>() { james, coin}, true) as IPredicate);
            WisdomQuest.Add(new Predicate("has", new List<ITerm>() { james, humanskull}, true) as IPredicate);
            WisdomQuest.Add(new Predicate("has", new List<ITerm>() { james, candle}, true) as IPredicate);
            goalDisjunctions.Add(WisdomQuest);

            var FetchQuest = new List<IPredicate>();
            var giovanna = AsTerm("giovanna");
            var hairtonic = AsTerm("hairtonic");
            FetchQuest.Add(new Predicate("has", new List<ITerm>() { giovanna, hairtonic }, true) as IPredicate);
            goalDisjunctions.Add(FetchQuest);

            var LoveQuest = new List<IPredicate>();
            var jordan = AsTerm("jordan");
            var loveletter = AsTerm("loveletter");
            var lovecontract = AsTerm("lovecontract");
            LoveQuest.Add(new Predicate("has", new List<ITerm>() { jordan, loveletter }, true) as IPredicate);
            LoveQuest.Add(new Predicate("has", new List<ITerm>() { jordan, lovecontract }, true) as IPredicate);
            goalDisjunctions.Add(LoveQuest);

            var OtherQuest = new List<IPredicate>();
            var arthur = AsTerm("arthur");
            var ash = AsTerm("ash");
            OtherQuest.Add(new Predicate("has", new List<ITerm>() { arthur, ash }, true) as IPredicate);
            goalDisjunctions.Add(OtherQuest);

            var supersetOfEffects = trace.SelectMany(step => step.Effects.Select(eff=> BasicBitchTerm(eff))).ToList();
            supersetOfEffects.AddRange(initial.Select(init => BasicBitchTerm(init)));
            // For each quest achieved, add constituent conditions as goals
            foreach(var quest in goalDisjunctions)
            {
                bool yes_maam = false;
                foreach(var q in quest)
                {
                    if (!supersetOfEffects.Contains(q))
                    {
                        yes_maam = false;
                        break;
                    }
                    yes_maam = true;

                }
                if (yes_maam)
                {
                    goalConditions.AddRange(quest);
                }
            }

            return goalConditions;
        }


    }

}
