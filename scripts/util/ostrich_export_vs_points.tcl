# This script was written and developed by ABKGroup students at UCSD. However, the underlying commands and reports are copyrighted by Cadence.
# We thank Cadence for granting permission to share our research to help promote and foster the next generation of innovators.

proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        puts stderr "ERROR: missing environment variable: $name"
        exit 2
    }
    return $::env($name)
}

proc get_env_or_default {name default} {
    if {[info exists ::env($name)] && $::env($name) ne ""} {
        return $::env($name)
    }
    return $default
}

proc dump_vs_points_csv {plotname datatype outfile} {
    set fp [open $outfile "w"]
    puts $fp "x,y,position"
    foreach position {over under excluded} {
        set pts [get_plot_points -plotname $plotname -datatype $datatype -position $position -increment 1]
        foreach p $pts {
            if {[llength $p] < 2} {
                continue
            }
            lassign $p x y
            puts $fp "${x},${y},${position}"
        }
    }
    close $fp
}

set spef1 [get_env_or_default OSTRICH_SPEF1 [get_env_or_default OSTRICH_GOLDEN_SPEF ""]]
set spef2 [get_env_or_default OSTRICH_SPEF2 [get_env_or_default OSTRICH_TARGET_SPEF ""]]
if {$spef1 eq ""} {
    set spef1 [require_env OSTRICH_SPEF1]
}
if {$spef2 eq ""} {
    set spef2 [require_env OSTRICH_SPEF2]
}
set set1_name [get_env_or_default OSTRICH_SET1_NAME [get_env_or_default OSTRICH_GOLDEN_NAME "set1"]]
set set2_name [get_env_or_default OSTRICH_SET2_NAME [get_env_or_default OSTRICH_TARGET_NAME "set2"]]
set outdir [get_env_or_default OSTRICH_OUTPUT_DIR "."]

file mkdir $outdir

set golden_name $set1_name
set target_name $set2_name
set golden_spef $spef1
set target_spef $spef2
set plotname "${set1_name}_vs_${set2_name}"

puts "Reading SPEF: $golden_spef as $golden_name"
read_spef -setname $golden_name -filename $golden_spef
puts "Reading SPEF: $target_spef as $target_name"
read_spef -setname $target_name -filename $target_spef

foreach datatype {tcap res} {
    puts "Building plot: $datatype"
    build_plot -plotname $plotname -golden $golden_name -target $target_name -datatype $datatype

    set appl [get_scale_factor -plotname $plotname -datatype $datatype -applied]
    set rec [get_scale_factor -plotname $plotname -datatype $datatype -recommended]
    set stats [get_plot_statistics -plotname $plotname -datatype $datatype -tcl_list]

    set sfile [open [file join $outdir "${datatype}_stats.txt"] "w"]
    puts $sfile "plotname=$plotname"
    puts $sfile "datatype=$datatype"
    puts $sfile "golden=$golden_name"
    puts $sfile "target=$target_name"
    puts $sfile "applied_scale_factor=$appl"
    puts $sfile "recommended_scale_factor=$rec"
    puts $sfile "statistics=$stats"
    close $sfile

    set csvfile [file join $outdir "${datatype}_vs_points.csv"]
    dump_vs_points_csv $plotname $datatype $csvfile
    puts "Wrote: $csvfile"
}

puts "Done."
catch {exit}
