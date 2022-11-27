#Creation of the simulator object
set ns [new Simulator]
#Enabling tracing of all events of the simulation
set f [open out.all w]
$ns trace-all $f
#Defining a finish procedure
proc finish {} {
 global ns f
 $ns flush-trace
 close $f
 exit 0
}
#Creation of the nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
#Creation of the links
$ns duplex-link $n0 $n1 3Mb 1ms DropTail
$ns duplex-link $n0 $n1 1Mb 15ms DropTail
#Creation of a cbr-connection using UDP
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packet_size_ 1000
$udp0 set packet_size_ 1000
$cbr0 set rate_ 1000000
$udp0 set class_ 0
set null0 [new Agent/Null]
$ns attach-agent $n2 $null0
$ns connect $udp0 $null0
#Scheduling the events
$ns at 0.0 “$cbr0 start”
$ns at $simtime “$cbr0 stop”
$ns at $simtime “finish”
$ns run 