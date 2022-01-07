using System;
using System.IO;
using System.Collections.Generic;

namespace mapback
{
    public class ListSimplifier
    {

        public List<string> listMod = new List<string>();


        public ListSimplifier()
        {


        }

        public static List<String> Simplify(List<String> Input, int noiselimit)
        {
            List<String> Output = new List<String>();
            int counter = 0;
            for (int i = 0; i < (Input.Count - 2); i++)
            {
                if (Input[i] == Input[i + 1])
                {
                    counter++;
                    continue;
                }
                else if (Input[i] == Input[i + 2])
                {
                    counter++;
                    i++;
                    continue;
                }
                else
                {
                    if (counter <= noiselimit)
                    { continue; }
                    else
                    {
                        Output.Add(Input[i] + ";" + counter.ToString());
                        counter = 0;
                        continue;
                    }
                }
            }
            return Output;
        }

    }
}