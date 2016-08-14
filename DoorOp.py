import time
import onionGpio

#Pin6 controls Relay 1
gpio06 	= onionGpio.OnionGpio(6)
status = gpio14.setOutputDirection()

#Pin6 controls Relay 2
gpio07  = onionGpio.OnionGpio(7)
status = gpio14.setOutputDirection()

#Pin23 senses the door in OPEN position
gpio23  = onionGpio.OnionGpio(23)
status = gpio23.setInputDirection()

#Pin23 senses the door in CLOSED position
gpio26  = onionGpio.OnionGpio(26)
status = gpio26.setInputDirection()

#Hide door details here...

class Door                                                      
                                                                                   
    def self.check_state( )                    
                
		doorOpenState = self.OpenCheck()
		doorClosedState = self.ClosedCheck()                             
        case                                                             
            when ( doorOpenState == "0") && ( doorClosedState == "1")  
                return "OPEN"                                      
            when ( doorOpenState == "1") && ( doorClosedState == "0")
                return "CLOSED"     
            else
                return "ERROR"         
            end                              
                                                                                                  
    end                                                                        
                                                                                   
    def self.OpenCheck()                                         
        doorOpenState = %x{fast-gpio read 23}.split.last                     
    end
                                                                                   
    def self.ClosedCheck()                                       
        doorOpenState = %x{fast-gpio read 26}.split.last                                  
    end                                                                                       
                                                                                   
    def self.Open()                                                            
        puts "Opening Door"

		elapsed = 0  #put an outer limit on door motor operation
                                                               
		#set relays
		doorState = %x{ fast-gpio set 6 1 }
				
		#loop - check operation
		while ( Door.check_state() != "OPEN" ) && ( elapsed < 5 )
			elapsed += elapsed
			sleep 0.25
		end
		doorState = %x{ fast-gpio set 6 0 }
    end                                                                                       
                                                                         
    def self.Close()                                                 
        puts "Closing Door"
        elapsed = 0  #put an outer limit on door motor operation
                                                                        
        #set relays                  
        doorState = %x{ fast-gpio set 7 1 }
                                                 
        #loop - check operation      
        while ( Door.check_state() != "CLOSED" ) && ( elapsed < 5 )
                elapsed += elapsed   
                sleep 0.25           
        end                          
		
		doorState = %x{ fast-gpio set 7 0 }                                                               
    end 
end               


while true:
    
    #get the current time
    currSecond = time.second
	puts "Current time is: #{time}"

    #where is the door currently?
    doorOpenState = Door.OpenCheck()
	doorClosedState = Door.ClosedCheck()
	print "TEST - DoorOpen #{ doorOpenState } and DoorClosed #{doorClosedState}"
    
    #is it time to do something?
    if (currSecond >= 0) && (currSecond <= 10)
		print "Opening"
		Door.Open()
 	end


	if (currSecond >= 30) && (currSecond <= 40)
		print "Closing"
		Door.Close()
        end

    #sleep
    time.sleep(5)

end
    

