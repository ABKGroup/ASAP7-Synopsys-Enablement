# This script was written and developed by ABKGroup students at UCSD. However, the underlying commands and reports are copyrighted by Cadence. 
# We thank Cadence for granting permission to share our research to help promote and foster the next generation of innovators.


proc save_cap_file { CAP_EX_DIR } {
    if { ![file exists ${CAP_EX_DIR}] } { file mkdir ${CAP_EX_DIR} }

    set nets [get_nets -hierarchical]
    set fileId [open "${CAP_EX_DIR}/net_parasitics.csv" "w"]
    puts $fileId "net_name,cap,res"
    foreach_in_collection net $nets {
        set name [get_db $net .name]
        set cap [get_db $net .wire_capacitance_max]
        set res [get_db $net .resistance_max]

		if { $cap != "" } {
			set cap [expr $cap*1000]
        	puts $fileId "$name,$cap,$res"
		}
    }
    close $fileId
}


proc save_timing_file { TIMING_EX_DIR NWORST } {
    if { ![file exists ${TIMING_EX_DIR}] } { file mkdir ${TIMING_EX_DIR} }

    set fileId [open "${TIMING_EX_DIR}/timing_details.csv" "w"]
    puts $fileId "points,tran_type,slews,delays,arrival,required,slack"

#    set timing_path1 [report_timing -collection -from [all_inputs] -to [all_registers -data_pins] -max_paths 1000000 -nworst $NWORST]
    set timing_path2 [report_timing -collection -from [all_registers -clock_pins] -to [all_registers -data_pins] -max_paths 1000000 -nworst $NWORST]
 #   set timing_path3 [report_timing -collection -from [all_registers -clock_pins] -to [all_outputs] -max_paths 1000000 -nworst $NWORST]
 #   set timing_path4 [report_timing -collection -from [all_inputs] -to [all_outputs] -max_paths 1000000 -nworst $NWORST]
 #   set timing_paths [list $timing_path1 $timing_path2 $timing_path3 $timing_path4]
    set timing_paths [list $timing_path2]

    foreach timing_path $timing_paths {
        foreach_in_collection timing_path $timing_paths {
            set timing_pin_names [get_db $timing_path .timing_points.pin.name]
            set tran_type [get_db $timing_path .timing_points.transition_type]
            set slews [get_db $timing_path .timing_points.slew]
            set delays [get_db $timing_path .timing_points.delay]
            set arrival [get_db $timing_path .arrival]
            set required [get_db $timing_path .required_time]
            set slack [get_db $timing_path .slack]

            puts $fileId "$timing_pin_names,$tran_type,$slews,$delays,$arrival,$required,$slack"
        }
    }
    close $fileId
}


proc _safe_get_db_list { obj attr } {
    set values {}
    if { [catch {set raw [get_db $obj $attr]}] } {
        return $values
    }
    foreach v $raw {
        if { $v ne "" } {
            lappend values $v
        }
    }
    return $values
}


proc save_net_layer_file { LAYER_EX_DIR } {
    if { ![file exists ${LAYER_EX_DIR}] } { file mkdir ${LAYER_EX_DIR} }

    set nets [get_nets -hierarchical]
    set fileId [open "${LAYER_EX_DIR}/net_layers.csv" "w"]
    puts $fileId "net_name,layer_count,layers"

    foreach_in_collection net $nets {
        set name [get_db $net .name]
        set layers {}

        # Try multiple db access paths for routed wire layers.
        set layers [concat $layers [_safe_get_db_list $net ".wires.layer.name"]]

        # Fallback: query layer names from wire objects directly.
        if { [llength $layers] == 0 } {
            if { ![catch {set wires [get_db $net .wires]}] } {
                if { [llength $wires] > 0 } {
                    set layers [concat $layers [_safe_get_db_list $wires ".layer.name"]]
                }
            }
        }

        # Keep layer list unique and deterministic.
        if { [llength $layers] > 0 } {
            set uniq_layers [lsort -unique $layers]
            set layer_count [llength $uniq_layers]
            set layer_text [join $uniq_layers "|"]
            puts $fileId "$name,$layer_count,$layer_text"
        } else {
            puts $fileId "$name,0,"
        }
    }

    close $fileId
}


proc _dict_incr { dict_var key {delta 1.0} } {
    upvar 1 $dict_var d
    if { [dict exists $d $key] } {
        dict set d $key [expr {[dict get $d $key] + $delta}]
    } else {
        dict set d $key $delta
    }
}


proc _get_layer_number { layer_name } {
    if { [regexp {([0-9]+)} $layer_name -> layer_num] } {
        return $layer_num
    }
    return ""
}


proc _get_via_name { via_obj } {
    foreach attr {".via_def.name" ".name"} {
        if { ![catch {set v [get_db $via_obj $attr]}] && $v ne "" } {
            return $v
        }
    }
    return "UNKNOWN_VIA"
}


proc save_net_metal_via_features { OUT_DIR } {
    if { ![file exists ${OUT_DIR}] } { file mkdir ${OUT_DIR} }

    set metal_fp [open "${OUT_DIR}/net_metal_lengths.csv" "w"]
    puts $metal_fp "net_name,layer_name,layer_num,total_length_um,segment_count"

    set via_fp [open "${OUT_DIR}/net_via_counts.csv" "w"]
    puts $via_fp "net_name,via_name,count"

    set layer_length_dict {}
    set layer_segment_dict {}
    set via_count_dict {}

    # Regular nets only (.wires/.vias). Special-net DB objects are intentionally
    # excluded because their root/attribute names vary by Innovus build.
    set nets [get_nets -hierarchical]
    foreach_in_collection net $nets {
        set net_name [get_db $net .name]

        foreach wire_attr {".wires"} {
            if { [catch {set wire_objs [get_db $net $wire_attr]}] } { continue }
            foreach wire $wire_objs {
                if { [catch {set layer_name [get_db $wire .layer.name]}] || $layer_name eq "" } { continue }
                if { ![catch {set length_um [get_db $wire .length]}] && $length_um ne "" } {
                    # In this Innovus flow, get_db .length is in design length units (typically micron).
                } else {
                    set length_um 0.0
                }
                set k "$net_name,$layer_name"
                _dict_incr layer_length_dict $k $length_um
                _dict_incr layer_segment_dict $k 1
            }
        }

        foreach via_attr {".vias"} {
            if { [catch {set via_objs [get_db $net $via_attr]}] } { continue }
            foreach via $via_objs {
                set via_name [_get_via_name $via]
                set k "$net_name,$via_name"
                _dict_incr via_count_dict $k 1
            }
        }
    }

    # Emit metal totals per net/layer.
    foreach k [lsort [dict keys $layer_length_dict]] {
        lassign [split $k ","] net_name layer_name
        set total_length_um [dict get $layer_length_dict $k]
        set seg_count [dict get $layer_segment_dict $k]
        set layer_num [_get_layer_number $layer_name]

        puts $metal_fp "$net_name,$layer_name,$layer_num,$total_length_um,$seg_count"
    }

    # Emit via counts per net/via type.
    foreach k [lsort [dict keys $via_count_dict]] {
        lassign [split $k ","] net_name via_name
        set via_count [dict get $via_count_dict $k]
        puts $via_fp "$net_name,$via_name,$via_count"
    }

    close $metal_fp
    close $via_fp
}
