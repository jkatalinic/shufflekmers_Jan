using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Collections;
using Bio;
using Bio.Algorithms.Alignment;
using Bio.SimilarityMatrices;
using Bio.IO;

namespace mapback
{
    public class Refmaker
    {

        public List<ISequence> sequences;
        public List<ISequence> kmers;
        public List<string> output;

        public Refmaker()
        {
            Console.WriteLine("Reading reference..");
            const string Filename = @"/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/cDNA/NLS-splicedarray-ADH1term.fasta";
            ISequenceParser parser = new Bio.IO.FastA.FastAParser();

            if (parser == null)
            {
                Console.WriteLine("Unable to locate parser for {0}", Filename);
                return;
            }

            using (parser.Open(Filename))
            {
                sequences = parser.Parse().ToList();
            }


            Console.WriteLine("Reading kmers..");
            const string Filename2 = @"/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/cDNA/dumps.fa";
            ISequenceParser parser2 = new Bio.IO.FastA.FastAParser();

            if (parser2 == null)
            {
                Console.WriteLine("Unable to locate parser for {0}", Filename2);
                return;
            }

            using (parser2.Open(Filename2))
            {
                kmers = parser2.Parse().ToList();
            }



        }


        public bool MakeRef(Ranger R1, int kmerlength, int step)
        {
            output = new List<string>();

            for (int i = 0; i < (this.sequences[0].Count - kmerlength); i += step)
            {
                for (int a = 0; a < kmers.Count; a++)
                {
                    var subseq = this.sequences[0].GetSubSequence(i, kmerlength);

                    //Console.WriteLine(subseq.ToString() + " compared to " + this.rawkmers[a].ToString());

                    if (subseq.ToString() == this.kmers[a].ToString())
                    {
                        Console.WriteLine(subseq.ToString() + " matches " + this.kmers[a].ToString());
                        this.kmers[a].ID = R1.WhatModule(i);
                        continue;

                    }
                    //Console.WriteLine("No match between " + i + " and " + (i + kmerlength));
                }
            }


            for (int a = 0; a < kmers.Count;)
            {
                if (this.kmers[a].ID.ToString() == "1")
                {
                    kmers.RemoveAt(a);
                }
                else
                a++;
            }

                const string filename3 = "/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/cDNA/mappedkmers.fasta";

            ISequenceFormatter formatter3 = new Bio.IO.FastA.FastAFormatter();

            if (formatter3 == null) return false;

            using (formatter3.Open(filename3))
            {
                formatter3.Format(kmers);
            }

            return true;


        }
    }
}