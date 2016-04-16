
		ADDI    $6,$0,1
		ADDI	$7,$0,2
EQ2:	BNEQ	$6,$7,EQ1
		ADD		$8,$2,$3
		MULT	$6,$5
		MFLO	$10
		J		END
EQ1:	ADDI	$7,$0,1
		BNEQ	$6,$7,DEF
		SUB		$8,$2,$3
		MULT	$8,$9
		MFLO	$10
		J		END
DEF:	ADDI	$6,$0,0
		ADDI	$8,$0,0
		ADDI	$10,$0,0
END:    ADDI	$15, $0, 15