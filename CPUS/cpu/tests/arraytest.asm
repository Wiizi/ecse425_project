# store in memory an array with values 1,2,3,4,5,6,7,8,9,10
addi $10, $0, 100  	# array pointer address # 0
add $1, $10, $0  	# array pointer address # 4 
addi $2, $0, 1		# value to store # 8
addi $3, $0, 200 	# max array address to loop until # 12 

loop: sw $2, 0($1) # 16 
addi $1, $1, 1 			# increment address # 20
addi $2, $2, 1 			# increment value of value to store # 24
bne $1, $3, loop # 28 

addi $1, $10, 0 		# reset array pointer address # 32

loop2: lw $5, 0($1) 		# read from memory # 36
addi $1, $1, 1 #40
bne $1, $3, loop2 # 44