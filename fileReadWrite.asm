; /*
;  * ;Description: DOS 文件创建读取写入
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-19 10:36:30
;  * ;FileName: 
;  */

.MODEL SMALL
.STACK 100H
.DATA
FNAME DB 'readFromFile.txt',0    
SFNAME DB 'writeToFile.txt',0
HANDLE DW ?  

MSG DB 'HERE IS A TEXT TO BE COPIED TO THE writeToFile.txt FILE '    ;56
SECONDMSG DB 'THERE IS SOME TEXT IN THIS FILE '   ;32

BUFFER DB 25 DUP(?)
COUNT DB 10
.CODE 

.startup
MOV AX,@DATA
MOV DS,AX

;***************MAKING A NEW FILE***************;

MOV AH,3CH
MOV DX,OFFSET(FNAME)
MOV CL,1
INT 21H
MOV HANDLE,AX


;***************CLOSEING A FILE***************;
MOV AH,3EH
MOV DX,HANDLE
INT 21H       


;;***************MAKING A NEW SECOND FILE***************; 

MOV AH,3CH
MOV DX,OFFSET(SFNAME)
MOV CL,1
INT 21H
MOV HANDLE,AX


;***************CLOSEING A FILE***************;
MOV AH,3EH
MOV DX,HANDLE
INT 21H


;***************OPEING AN EXISTING FIRST FILE AND WRITTING ON IT***************;

MOV AH,3DH
MOV DX,OFFSET(FNAME)
MOV AL,1  ; 1 MEAN FOR WRITING PURPOSE             ;OPEN
INT 21H
MOV HANDLE,AX

MOV AH,40H
MOV BX,HANDLE
MOV CX,56                                         ;WRITE
MOV DX, OFFSET(MSG)
INT 21H

MOV AH,3EH
MOV DX,HANDLE                                      ;CLOSE
INT 21H                                                  





;***************OPEING AN EXISTING SECOND FILE AND WRITTING ON IT***************;

MOV AH,3DH
MOV DX,OFFSET(SFNAME)
MOV AL,1  ; 1 MEAN FOR WRITING PURPOSE             ;OPEN
INT 21H
MOV HANDLE,AX

MOV AH,40H
MOV BX,HANDLE
MOV CX,32                                         ;WRITE
MOV DX, OFFSET(SECONDMSG)
INT 21H

MOV AH,3EH
MOV DX,HANDLE                                      ;CLOSE
INT 21H
            
;***************OPEING FOR READING FIRST FILE***************;


MOV AH,3DH
MOV DX,OFFSET(FNAME)
MOV AL,0  ; 0 MEAN FOR READING PURPOSE             ;OPEN
INT 21H
MOV HANDLE,AX 
  
MOV AH,3FH
MOV BX,HANDLE
MOV DX,OFFSET(BUFFER)                            ;READ
MOV CX,56
INT 21H
          
MOV AH,3EH
MOV DX,HANDLE                                     ;CLOSE
INT 21H        
          
   
;***************WRITTING CONTENT ON THE SECOND FILE***************; 
  
                                                                    
MOV AH,3DH
MOV DX,OFFSET(SFNAME)
MOV AL,1  ; 1 MEAN FOR WRITING PURPOSE          ;OPEN
INT 21H
MOV HANDLE,AX   


    ;*****************************************************************  
    
    
MOV AH,42H
MOV BX,HANDLE                                   ;SEEK TO THE END OF THE FILE
XOR CX,CX
XOR DX,DX
MOV AL,2
int 21H


    ;******************************************************************
    
    
MOV AH,40H 
MOV BX,HANDLE
MOV CX,56
MOV DX, OFFSET(BUFFER)                          ;WRITE
INT 21H


    ;****************************************************************** 
    
    
MOV AH,3EH
MOV DX,HANDLE                                    ;CLOSE
INT 21H


.exit 0
end