set ns [new Simulator]
set nssim $ns
set simstart 0.1
set simend 1000.0
set rng [new RNG]

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf fmon_bn
    puts "FINISHED"
    $ns flush-trace
    #Close the NAM trace file
    close $nf
    #Execute NAM on the trace file
    exec nam out.nam &
    exit 0
}

source helper.tcl

set r [$ns node]
set d [$ns node]

#create bottleneck
$ns duplex-link $r $d 10mb 10ms DropTail
$ns queue-limit $r $d 1000
$ns duplex-link-op $r $d orient right

#create loss module
set loss_random_variable [new RandomVariable/Uniform]
$loss_random_variable set min_ 0 
$loss_random_variable set max_ 100

set loss_module [new ErrorModel] 
$loss_module drop-target [new Agent/Null] 
$loss_module set rate_ 10 
$loss_module ranvar $loss_random_variable 

$ns lossmodel $loss_module $r $d

#monitor for bottleneck
set fmon_bn [$ns makeflowmon Fid]
$ns attach-fmon [$ns link $r $d] $fmon_bn

for {set i 0} {$i<$nof_classes} {incr i} {
    set s($i) [$ns node]
    $ns duplex-link $s($i) $r 100mb [expr 10+30*$i]ms DropTail
    $ns queue-limit $s($i) $r 1000

    set tcp_s($i,0) [new Agent/TCP/Reno]
    $tcp_s($i,0) set packetSize_ 1460
    $tcp_s($i,0) set window_ 1000
    $tcp_s($i,0) set fid_ 0
    $ns attach-agent $s($i) $tcp_s($i,0)

    set tcp_d($i,0) [new Agent/TCPSink]
    $ns attach-agent $d $tcp_d($i,0)
    $ns connect $tcp_s($i,0) $tcp_d($i,0)

    set ftp($i,0) [new Application/FTP]
    $ftp($i,0) attach-agent $tcp_s($i,0)
    $ftp($i,0) set type_ FTP
}

$ns at $simstart "record_start"
for {set i 0} {$i<$nof_classes} {incr i} {
    $ns at $simstart "start_flow $i"
}
$ns at $simend "record_end"
$ns at $simend "finish"

$ns run
