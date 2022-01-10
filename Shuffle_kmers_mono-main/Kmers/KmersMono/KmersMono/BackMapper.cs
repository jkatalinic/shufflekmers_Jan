using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Collections;
using Bio;
using Bio.Algorithms.Alignment;
using Bio.SimilarityMatrices;
using Bio.IO;

using System.Threading;
using System.Threading.Tasks;

namespace mapback
{
    public class BackMapper
    {

        public List<ISequence> ONTreads;
        public List<ISequence> Ukmers;

        public BackMapper()
        {

            Console.WriteLine("Reading ONT fasta file..");
            const string Filename = @"/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Pre-filter/testreads.fasta";
            ISequenceParser parser = new Bio.IO.FastA.FastAParser();

            if (parser == null)
            {
                Console.WriteLine("Unable to locate parser for {0}", Filename);
                return;
            }

            using (parser.Open(Filename))
            {
                ONTreads = parser.Parse().ToList();
            }

            Console.WriteLine("Loaded " + ONTreads.Count.ToString() + " reads.");

            //-----------------------------------

            Console.WriteLine("Reading kmer file..");
            const string Filename2 = @"/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Step_2/outputkmers3.fasta";
            ISequenceParser parser2 = new Bio.IO.FastA.FastAParser();

            if (parser2 == null)
            {
                Console.WriteLine("Unable to locate parser for {0}", Filename2);
                return;
            }

            using (parser2.Open(Filename2))
            {
                Ukmers = parser2.Parse().ToList();
            }

            Console.WriteLine("Loaded " + Ukmers.Count.ToString() + " kmers.");




        }

        public List<String> AnalyzeRead(Sequence Read, int kmerlength, int step)
        {
            List<String> Output = new List<string>();

            for (int i = 0; i < (Read.Count - kmerlength); i += step)
            {
                for (int a = 0; a < Ukmers.Count; a++)
                {

                    var subseq = Read.GetSubSequence(i, kmerlength);
                    //Console.WriteLine(subseq.ToString() + " compared to " + this.rawkmers[a].ToString());

                    if (subseq.ToString() == this.Ukmers[a].ToString())
                    {
                        Output.Add(Ukmers[a].ID);
                        continue;
                    }
                    else if (subseq.ToString() == this.Ukmers[a].GetReverseComplementedSequence().ToString())
                    {
                        Output.Add(Ukmers[a].ID + "r");
                        continue;
                    }
                }
            }

            return Output;
        }

        public bool AnalyzeReads()
        {
            for (int i = 0; i < ONTreads.Count; i++)
            {
                List<String> ToFile = new List<string>();

                ToFile = ListSimplifier.Simplify(AnalyzeRead((Sequence)ONTreads[i], 12, 3), 3);

                if (ToFile.Count > 5)
                {
                    string filename3 = "/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Output/" + ONTreads[i].ID + ".txt";

                    System.IO.File.WriteAllLines(filename3, ToFile);
                }
                Console.WriteLine("Done with read " + i.ToString() + " of " + ONTreads.Count.ToString() + ".");
            }
            return true;
        }
        public bool AnalyzeReadsP()
        {


            int limit = ONTreads.Count;

            Parallel.For(0, limit, count =>
            {

                List<String> ToFile = new List<string>();

                ToFile = ListSimplifier.Simplify(AnalyzeRead((Sequence)ONTreads[count], 12, 3), 3);

                if (ToFile.Count > 5)
                {
                    string filename3 = "/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Output/" + ONTreads[count].ID + ".txt";

                    System.IO.File.WriteAllLines(filename3, ToFile);
                }
                Console.WriteLine("Done with read " + count.ToString() + " of " + ONTreads.Count.ToString() + ".");

            });

            return true;
        }
    }
}