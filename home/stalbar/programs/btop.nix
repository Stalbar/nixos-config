{ nord, ... }:

{
  xdg.configFile."btop/btop.conf".text = ''
    color_theme = "~/.config/btop/themes/nord-minimal.theme"
    theme_background = false
    truecolor = true

    vim_keys = true
    rounded_corners = true
    graph_symbol = "block"

    shown_boxes = "cpu mem proc"
    update_ms = 1500

    proc_sorting = "cpu lazy"
    proc_reversed = false
    proc_tree = false
    proc_colors = true
    proc_gradient = false
    proc_per_core = false
    proc_mem_bytes = true
    proc_cpu_graphs = false

    cpu_single_graph = true
    show_coretemp = false
    show_cpu_freq = false
    show_cpu_watts = false

    mem_graphs = true
    show_disks = false
    show_swap = true
    swap_disk = false

    net_auto = true
    show_battery = true
    show_battery_watts = false

    clock_format = "%H:%M"
    background_update = false
    log_level = "WARNING"
    save_config_on_exit = true
  '';

  xdg.configFile."btop/themes/nord-minimal.theme".text = ''
    theme[main_bg]="#${nord.nord0}"
    theme[main_fg]="#${nord.nord4}"
    theme[title]="#${nord.nord8}"
    theme[hi_fg]="#${nord.nord10}"
    theme[selected_bg]="#${nord.nord3}"
    theme[selected_fg]="#${nord.nord6}"
    theme[inactive_fg]="#${nord.nord3}"
    theme[proc_misc]="#${nord.nord9}"

    theme[cpu_box]="#${nord.nord3}"
    theme[mem_box]="#${nord.nord3}"
    theme[net_box]="#${nord.nord3}"
    theme[proc_box]="#${nord.nord3}"
    theme[div_line]="#${nord.nord3}"

    theme[temp_start]="#${nord.nord13}"
    theme[temp_mid]="#${nord.nord13}"
    theme[temp_end]="#${nord.nord13}"

    theme[cpu_start]="#${nord.nord8}"
    theme[cpu_mid]="#${nord.nord8}"
    theme[cpu_end]="#${nord.nord8}"

    theme[free_start]="#${nord.nord14}"
    theme[free_mid]="#${nord.nord14}"
    theme[free_end]="#${nord.nord14}"

    theme[cached_start]="#${nord.nord9}"
    theme[cached_mid]="#${nord.nord9}"
    theme[cached_end]="#${nord.nord9}"

    theme[available_start]="#${nord.nord7}"
    theme[available_mid]="#${nord.nord7}"
    theme[available_end]="#${nord.nord7}"

    theme[used_start]="#${nord.nord10}"
    theme[used_mid]="#${nord.nord10}"
    theme[used_end]="#${nord.nord10}"

    theme[download_start]="#${nord.nord8}"
    theme[download_mid]="#${nord.nord8}"
    theme[download_end]="#${nord.nord8}"

    theme[upload_start]="#${nord.nord10}"
    theme[upload_mid]="#${nord.nord10}"
    theme[upload_end]="#${nord.nord10}"
  '';
}
