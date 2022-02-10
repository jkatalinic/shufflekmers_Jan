using System;
using Bio;
using Bio.Algorithms.Alignment;
using Bio.SimilarityMatrices;

namespace mapback
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Loading ranges...");

            Ranger R1 = new Ranger();

            Refmaker Ref1 = new Refmaker();


            //Console.WriteLine(Ref1.sequences[0].ID);

            //for (int i = 0; i < Ref1.rawkmers.Count; i++)
            //{
            //    Console.WriteLine("kmer " + i.ToString());
            //    Console.WriteLine(Ref1.rawkmers[i].ToString());
            //}

            Ref1.MakeRef(R1, 12, 4);

            Console.WriteLine("Done !");

        }
    }
}
