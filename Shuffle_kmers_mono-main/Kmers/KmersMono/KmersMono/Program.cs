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
            Console.WriteLine("Loading ONT reads...");

            BackMapper M1 = new BackMapper();

            //M1.AnalyzeReads();
            M1.AnalyzeReadsP();

            Console.WriteLine("DONE !");

        }
    }
}