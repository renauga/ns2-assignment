#Creation of the simulator object
set ns [new Simulator]
#Enabling tracing of all events of the simulation
set simtime 5.0
set f [open out2.nam w]
$ns namtrace-all $f
#Defining a finish procedure
proc finish {} {
 global ns f
 $ns flush-trace
 close $f
 exec nam out2.nam &
 exit 0
} 
#Creation of the nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
#Creation of the links
$ns duplex-link $n0 $n1 3Mb 1ms DropTail
$ns duplex-link $n2 $n1 1Mb 15ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Scheduling the events
$ns at 0.0 "$ftp start"
$ns at $simtime "$ftp stop"
$ns at $simtime "finish"
$ns run 