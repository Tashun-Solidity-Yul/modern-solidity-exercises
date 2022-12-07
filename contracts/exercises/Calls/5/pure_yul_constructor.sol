 /**
    Pure Yul contracts
    outer object is considered as the contract 
    outer object code is considered as the constructor code 

    inner object is considered as the object where the code is available
    inner object code contains the function calls, using a switch statement can separate functions

    
 
 **/
 
 object "FirstContract" {
     code {
         datacopy(0,dataoffset("FirstCode"), datasize("FirstCode"))
         return(0x0, datasize("FirstCode"))
     }

     object "FirstCode" {
         code {
             mstore(0x0, 2)
             return(0x0,0x20)

         }
     }
 } 