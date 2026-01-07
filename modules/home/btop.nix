{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "rose-pine-dark-hc"; 
      theme_background = true; 
      vim_keys = true;         
      update_ms = 1000;        
    };
  };

  xdg.configFile."btop/themes/rose-pine-dark-hc.theme".text = ''
    
    theme[main_bg]="#191724"        
    theme[main_fg]="#e0def4"       
    theme[selected_bg]="#26233a"   
    theme[inactive_fg]="#6e6a86"   
    theme[hi_fg]="#f6c177"         

    theme[title]="#f6c177"
    theme[selected_fg]="#f6c177"
    
    theme[cpu_box]="#ebbcba"        
    theme[mem_box]="#31748f"       
    theme[net_box]="#c4a7e7"       
    theme[proc_box]="#eb6f92"      

    theme[graph_text]="#9ccfd8"     
    theme[meter_bg]="#26233a"       
    theme[div_line]="#6e6a86"       

   
    theme[temp_start]="#ebbcba"
    theme[temp_mid]="#f6c177"       
    theme[temp_end]="#eb6f92"

    theme[cpu_start]="#f6c177"
    theme[cpu_mid]="#ebbcba"
    theme[cpu_end]="#eb6f92"

    theme[download_start]="#31748f"
    theme[download_mid]="#9ccfd8"
    theme[download_end]="#9ccfd8"
    theme[upload_start]="#ebbcba"
    theme[upload_mid]="#eb6f92"
    theme[upload_end]="#eb6f92"
  '';
}

