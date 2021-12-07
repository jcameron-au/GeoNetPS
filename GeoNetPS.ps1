function Invoke-GeoPing {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$IPAddress
    )
    
    begin {
        
        $baseUri = 'https://geonet.shodan.io/api/geoping'

    }
    
    process {

        $restParams = @{
            Method = 'Get'
            Uri = $baseUri,$IPAddress -join '/'
            ErrorAction = 'Stop'
        }

        $response = Invoke-RestMethod @restParams

        foreach ($answer in $response)
        {
            [PSCustomObject]@{
                IPAddress = $answer.ip
                IsAlive = $answer.is_alive
                MinRTT = $answer.min_rtt
                AvgRTT = $answer.avg_rtt
                MaxRTT = $answer.max_rtt
                RTT = $answer.rtts
                PacketsSent = $answer.packets_sent
                PacketsReceived = $answer.packets_received
                PacketLoss = $answer.packet_loss
                City = $answer.from_loc.city
                Country = $answer.from_loc.country
                LatLong = $answer.from_loc.latlon
            }
        }
    }
    
    end {
        
    }
}

function Invoke-GeoDns {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$HostName,

        [Parameter()]
        [string]$RecordType = 'A'
    )
    
    begin {
        
        $baseUri = 'https://geonet.shodan.io/api/geodns'

    }
    
    process {

        $restParams = @{
            Method = 'Get'
            Uri = "{0}/{1}?rtype={2}" -f $baseUri,$HostName,$RecordType
            ErrorAction = 'Stop'
        }

        $response = Invoke-RestMethod @restParams

        foreach ($answer in $response)
        {
            foreach ($record in $answer.answers)
            {
                [PSCustomObject]@{
                    RecordType = $record.type
                    RecordValue = $record.value
                    City = $answer.from_loc.city
                    Country = $answer.from_loc.country
                    LatLong = $answer.from_loc.latlon
                }
            }
        }
    }
    
    end {
        
    }
}