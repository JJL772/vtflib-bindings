
using System;
using System.IO;
using VTFLib;

namespace Test
{
    class Test
    {
        public static int Main(string[] args)
        {
            Console.WriteLine("Hello! This is a C# VTFLib test program");
            if (args.Length < 2)
            {
                Console.WriteLine("Usage: test infile.vtf outfile.vtf");
                return 1;
            }
            
            var file = new CVTFFile();
            if (file.Load(args[0]) == false)
            {
                Console.WriteLine("Unable to load VTF file!");
                return 1;
            }

            file.SetAuxCompressionLevel(9);
            file.Save(args[1]);
            Console.WriteLine("Saved " + args[1]);
            return 0;
        }
    }
}