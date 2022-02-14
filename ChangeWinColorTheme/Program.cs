using Microsoft.Win32;

namespace ChangeTheme
{
    class ChangeTheme
    {
        static void Main(String[] args)
        {
            // Getting the registry key
            RegistryKey themeKey = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", true);

            // Getting the key values
            string appTheme = themeKey.GetValue("AppsUseLightTheme").ToString();
            string systemTheme = themeKey.GetValue("SystemUsesLightTheme").ToString();
            
            try
            {
                if (Int32.Parse(appTheme) == 1 && Int32.Parse(systemTheme) == 1)
                {
                    // Change the registry key values
                    themeKey.SetValue("AppsUseLightTheme", 0);
                    themeKey.SetValue("SystemUsesLightTheme", 0);
                }
                else
                {
                    // Change the registry key values
                    themeKey.SetValue("AppsUseLightTheme", 1);
                    themeKey.SetValue("SystemUsesLightTheme", 1);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("Error: \n {0}", e));
            }

            themeKey.Close();
        }
    }
}