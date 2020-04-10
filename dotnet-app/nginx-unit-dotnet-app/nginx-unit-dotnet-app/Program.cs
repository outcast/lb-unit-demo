using System;
using System.Collections;

namespace nginx_unit_dotnet_app
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Content-Type: text/plain");
            Console.WriteLine();
            Console.WriteLine("Envs: ");
            foreach (DictionaryEntry env in Environment.GetEnvironmentVariables())
                Console.WriteLine("  {0} = {1}", env.Key, env.Value);
            Console.WriteLine("Hello World!");
        }
    }
}
