{ ... }:

{
  xdg.configFile."btop/btop.conf".text = ''
    color_theme = "~/.config/btop/themes/current.theme"
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
}
