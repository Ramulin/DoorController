
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

# ========  Main Operation Loop =============

openTime = "30"
closeTime = "00"
currState = 0
doorOpenSensor = 23
doorClosedSensor = 26

#Setup door sensors

# Set door "open" sensor
dooropen = %x{ fast-gpio set-input #{ doorOpenSensor} } 
puts "Set #{doorOpenSensor} to input"

# Set door "closed" sensor
doorclosed = %x{ fast-gpio set-input 26 }
puts "Set 26 to input"

# Setup the relays that control motor direction
%x{ fast-gpio set-output 6 }
%x{ fast-gpio set 6 0 }
motor0 = %x{ fast-gpio read 6 }
puts "Pin 6 is set to #{motor0}"
%x{ fast-gpio set-output 7 }
%x{ fast-gpio set 7 0 }
motor1 = %x{ fast-gpio read 7 }
puts "Pin 7 is set to #{motor1}"

time = Time.new

while true do

	currSecond = time.sec
	puts "Current time is: #{time}" 
	doorOpenState = Door.OpenCheck()
	doorClosedState = Door.ClosedCheck()
	puts "TEST - DoorOpen #{ doorOpenState } and DoorClosed #{doorClosedState}"
        if (currSecond >= 0) & (currSecond <= 10)
		puts "Opening"
		Door.Open()
 	end
        
	currStcurrState = !currState
        puts "currState = #{currState}"

	if (currSecond >= 30) & (currSecond <= 40)
		puts "Closing"
		Door.Close()
        end

        currState = !currState
        puts "currState = #{currState}"

	sleep 5

end


#Check time to determine action
#DetermineActionForTime( time )
class ActionDecision
    def ActionDecision.determine_action( curTime ) #accepts a time
        #make a decision about what action should be taken
    end
    def ActionDecision.return_date
    end
end


