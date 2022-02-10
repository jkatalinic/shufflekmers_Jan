using System;
using System.IO;
using System.Collections.Generic;

namespace mapback
{
    public class Ranger
    {

        public List<string> listMod = new List<string>();
        public List<int> listS = new List<int>();
        public List<int> listE = new List<int>();

        public Ranger()
        {
            
            using (var reader = new StreamReader(@"/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/cDNA/cDNAref_ranges.csv"))
            {
              

                while (!reader.EndOfStream)
                {
                    var line = reader.ReadLine();
                    var values = line.Split(',');

                    listMod.Add(values[0]);
                    listS.Add(Convert.ToInt32(values[1]));
                    listE.Add(Convert.ToInt32(values[2]));

                    Console.WriteLine(values[0] + " " + Convert.ToInt32(values[1]) + " " + Convert.ToInt32(values[2]));
                }
            }
        }

        public string WhatModule(int index)
        {
            for (int i = 0; i < listMod.Count; i++)
            {
                if (index >= listS[i] && index <= listE[i])
                {
                    return listMod[i];
                }
            }

            return "gap";
        }

    }
}
