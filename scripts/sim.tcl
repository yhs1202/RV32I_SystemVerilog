# ============================================================
# Vivado Simulation Script
# - Project name = current directory name
# - Expects src/ and constr/ subdirectories
# ============================================================

# Use current directory name as project name
set proj_dir [file normalize [pwd]]
set proj_name [file tail $proj_dir]

# User settings -----------------------------
# Set top module from environment variable if exists
if {[info exists ::env(TOP)]} {
    set top $::env(TOP)
} else {
    # Top-level module name (edit this)
    set top "top"                    ;# Top-level module name (edit this)
}
set tb_top "tb_$top"                 ;# Testbench top module name (edit this)
set part "xc7a35ticsg324-1L"         ;# Device part (example: Basys-3)
set srcdir   "$proj_dir/src"
set simdir   "$proj_dir/sim"
set constrdir "$proj_dir/constr"
set outdir   "$proj_dir/out"
file mkdir $outdir
# -------------------------------------------

puts ">>> Building project: $proj_name"
puts ">>> Part: $part"
puts ">>> Top module: $top"
puts ">>> Testbench module: $tb_top"

# Create a non-project flow
create_project $proj_name $outdir -part $part -force
set_msg_config -id {Common 17-55} -new_severity {WARNING}

proc get_all_files {dir pattern} {
    set result {}

    # Get all files matching the pattern in the current directory
    foreach f [glob -nocomplain -directory $dir -types f $pattern] {
        lappend result [file normalize $f]
    }
    # Recursively search in subdirectories
    foreach d [glob -nocomplain -directory $dir -types d *] {
        set sub [get_all_files $d $pattern]
        if {[llength $sub] > 0} {
            set result [concat $result $sub]
        }
    }
    return $result
}

# Add RTL sources
set v_files [get_all_files $srcdir *.v]
if {[llength $v_files] > 0} {
    add_files -fileset sources_1 $v_files
}

set sv_files [get_all_files $srcdir *.sv]
if {[llength $sv_files] > 0} {
    add_files -fileset sources_1 $sv_files
}

# Set top module
set_property top $top [current_fileset]

# Add constraints
set xdc_files [get_all_files $constrdir *.xdc]
if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
}

# Add simulation files
set tb_files_v [get_all_files $simdir tb_*.v]
if {[llength $tb_files_v] > 0} {
    add_files -fileset sim_1 $tb_files_v
}
set tb_files_sv [get_all_files $simdir tb_*.sv]
if {[llength $tb_files_sv] > 0} {
    add_files -fileset sim_1 $tb_files_sv
}

# Set simulation top module
set_property top $tb_top [get_filesets sim_1]

# Run simulation (uncomment to run)
launch_simulation
# add_wave [get_objects *]
add_wave [get_objects -r /$tb_top/dut/*]
run all
puts ">>> Simulation completed."