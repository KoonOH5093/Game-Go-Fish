	.data
	/*** Start Game (input Number of Player) ***/
sGame: .asciz "Start Game: Set Number of Players (2 3 or 4) - "
NofPlayer: 	.word 0			@Number of Players
aPlayer:	.word 0			@index of Active Player

	/*** Show Status on Table and Data for each Players ***/
sTable: 	.asciz "Table: Number of Cards = %d\n"			@Show data on Table
sPlayer:	.asciz ":	Point = %d	Number of Cards = %d\n"	@Show data of Player
sHand:		.asciz "	In Your Hand: "						@Show Card in Player's Hand

Hand:		.asciz "    "
Hand2:		.asciz "    "
enter:		.asciz "\n"
enter2:		.asciz "--------------------------------------------------\n"
tab:		.asciz "	"

hPlayer:	.space  26		@cards in your hand	
hCom1:		.space	26		@cards in Mike's hand
hCom2:		.space	26		@cards in Bill's hand
hCom3:		.space	26		@cards in Lisa's hand
askCard:	.space	2		@for get index 2 player

	/*** Name for each Players ***/
nPlayer:	.asciz "You "		@You
nCom1:		.asciz "Mike"		@Com1
nCom2: 		.asciz "Bill"		@Com2
nCom3: 		.asciz "Lisa"		@Com3

	/*** Show Game Play ***/
	/* Player's turn */
tPlayer:	.asciz "	Your turn:\n"
PlayerC:	.asciz "	Choose the player you want to ask - "	@Choose Player for ask
PlayerA:	.asciz "	What rank do you want to ask %s - "		@Choose Card Number
ChosenP:	.asciz "Mike"
ChosenN:	.asciz "  "

	/* Mike's turn */
tCom1:		.asciz "	Mike's turn:"
	
	/* Bill's turn */
tCom2:		.asciz "	Bill's turn:"
	
	/* Lisa's turn */
tCom3:		.asciz "	Lisa's turn:"
	
	/* Bot Play */
botPlay:	.asciz "	%s asks %s for %s\n"

	/* The opposite has card */
hasCard:	.asciz ":	I have %s - %s got %d card(s)\n"
	 
	/* The opposite hasn't card */
noCard:		.asciz ":	Go Fish!!! - %s drew 1 card\n"

	/*	Get set of rank card */
get4card:	.asciz	"	%s finish set of %s - %s got 1 point\n"

	/*	winner */
win:		.asciz	"---------- The winner ----------\n"

	/* Check Error */
eNumofPlayer:	.asciz "\n	----- Error!!! Please input key number (2,3,or 4). -----\n\n"
eChoose4Player:	.asciz "\n	----- Error!!! Please Choose Mike, Bill, or Lisa. -----\n\n"
eChoose3Player:	.asciz "\n	----- Error!!! Please Choose Mike, or Bill. -----\n\n"
eChooseNumberKey:	.asciz "\n	----- Error!!! Please input key (A,2,3,4,5,6,7,8,9,10,J,Q,or K).-----\n\n"
eChooseNumber:	.asciz "\n	----- Error!!! You don't have card %s.-----\n\n"

int: 		.asciz "%d"
string:		.asciz "%s"
nPoint:		.space	4		@Point for earn Players
nCard:		.space	4		@Number of Cards for earn Players
cardFile:	.asciz "As  2s  3s  4s  5s  6s  7s  8s  9s  10s Js  Qs  Ks  Ah  2h  3h  4h  5h  6h  7h  8h  9h  10h Jh  Qh  Kh  Ad  2d  3d  4d  5d  6d  7d  8d  9d  10d Jd  Qd  Kd  Ac  2c  3c  4c  5c  6c  7c  8c  9c  10c Jc  Qc  Kc  "

	.bss
t:	.zero			@for random

	.text
	.global main
	.func main
main:
	sub		sp, sp, #52
	mov		r2, #0		@index for set card
	
setCard:
	/* Set of Cards */
	bl		Rand		@Random card's number (output: r1)
	bl		Rand
	bl		Rand
	bl		Rand
	mov		r3, #0		
next:					@loop for check if same card
	ldrb	r4, [sp, r3]	
	cmp		r4, r1		@check if same card re random
	beq		setCard
	add		r3, r3, #1
	cmp		r3, r2		@latest index for check
	blo		next		
	
	strb	r1, [sp, r2]	@set card
	add		r2, r2, #1
	CMP		r2, #52			
	BNE		setCard	
	
Shuffle:
	mov		r2, #0
next2:
	bl		Rand		@Random number (output: r1)
	bl		Rand
	bl		Rand
	bl		Rand
	sub		r1, r1, #1	@indax	of card
	
	/* shuffle card */
	ldrb	r3, [sp, #0]	
	ldrb	r4, [sp, r1]
	strb	r3, [sp, r1]
	strb	r4, [sp, #0]
	
	add		r2, r2, #1
	cmp		r2, #52		@times of shuffle
	bne		next2
	
	/* Number of Cards on Table */
	mov		r4, #52
	
	/* Number of Cards for earn Player */
	ldr		r5, =nCard
	
	/* Points for earn Player */
	ldr		r6, =nPoint
	
	/* Set Number of Player in Game */
	ldr 	r0, =sGame 	
	bl		printf
	ldr		r0, =int
	ldr		r1, =NofPlayer
	bl		scanf
	
	ldr		r1, =NofPlayer
	ldr		r1, [r1]
	
	CMP		r1, #2
	BEQ		Play2
	CMP		r1, #3
	BEQ		Play3
	CMP		r1, #4
	BEQ		Play4
	
	/**** Error no input 2 3 or 4 ****/
	ldr		r0, =eNumofPlayer
	bl		printf
	b		exit2
	
	/* 2 Players */
Play2: 
	mov		r8, #7
	ldr		r9, =hPlayer	@Your cards
	mov		r0, #0
	bl		drewCard
	
	mov		r8, #7
	ldr		r9, =hCom1		@Com1's cards (Mike)
	mov		r0, #1
	bl		drewCard
	
	mov		r8, #0
	strb	r8, [r6, #0]	@Your point
	strb	r8, [r6, #1]	@Com1's point (Mike)
	
	bl		findFPlayer		@set First Player
P2:	
	ldr		r5, =nCard
	ldr		r6, =nPoint
	
	LDR		r0, =sTable		@Table
	mov		r1, r4
	bl		printf

	ldr 	r0, =nPlayer 	@You
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #0]
	ldrb	r2, [r5, #0]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Your Cards
	bl		printf
	ldr		r9, =hPlayer
	mov		r6, #0
	bl		showCard
	
	ldr		r6, =nPoint		@Test

	ldr 	r0, =nCom1 		@Com1 (Mike)
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #1]
	ldrb	r2, [r5, #1]	
	bl		printf
	
	ldr 	r0, =sHand 		@Show Mike's Cards
//	bl		printf
	ldr		r9, =hCom1
	mov		r6, #1
//	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test

	b		gamePlay

	/* 3 Players */
Play3:
	mov		r8, #6
	ldr		r9, =hPlayer	@Your cards
	mov		r0, #0
	bl		drewCard
	
	mov		r8, #6
	ldr		r9, =hCom1		@Com1's cards (Mike)
	mov		r0, #1
	bl		drewCard
	
	mov		r8, #6
	ldr		r9, =hCom2		@Com2's cards (Bill)
	mov		r0, #2
	bl		drewCard
	
	mov		r8, #0
	strb	r8, [r6, #0]	@Your point
	strb	r8, [r6, #1]	@Com1's point (Mike)
	strb	r8, [r6, #2]	@Com2's point (Bill)
	
	bl		findFPlayer		@set First Player
	
P3:	
	ldr		r5, =nCard
	ldr		r6, =nPoint
	
	ldr		r0, =sTable		@Table
	mov		r1, r4
	bl		printf
	
	ldr 	r0, =nPlayer 	@You
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #0]
	ldrb	r2, [r5, #0]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Your Cards
	bl		printf
	ldr		r9, =hPlayer
	mov		r6, #0
	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test

	ldr 	r0, =nCom1 		@Com1 (Mike)
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #1]
	ldrb	r2, [r5, #1]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Mike's Cards
//	bl		printf
	ldr		r9, =hCom1
	mov		r6, #1
//	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test
	
	ldr 	r0, =nCom2		@Com2 (Bill)
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #2]
	ldrb	r2, [r5, #2]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Bill's Cards
//	bl		printf
	ldr		r9, =hCom2
	mov		r6, #2
//	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test
	
	b		gamePlay

	/* 4 Players */
Play4:
	mov		r8, #5
	ldr		r9, =hPlayer	@Your cards
	mov		r0, #0
	bl		drewCard
	
	mov		r8, #5
	ldr		r9, =hCom1		@Com1's cards (Mike)
	mov		r0, #1
	bl		drewCard
	
	mov		r8, #5
	ldr		r9, =hCom2		@Com2's cards (Bill)
	mov		r0, #2
	bl		drewCard
	
	mov		r8, #5
	ldr		r9, =hCom3		@Com3's cards (Lisa)
	mov		r0, #3
	bl		drewCard
	
	mov		r8, #0
	strb	r8, [r6, #0]	@Your point
	strb	r8, [r6, #1]	@Com1's point (Mike)
	strb	r8, [r6, #2]	@Com2's point (Bill)
	strb	r8, [r6, #3]	@Com3's point (Lisa)
	
	bl		findFPlayer		@set First Player
	
P4:	
	ldr		r5, =nCard
	ldr		r6, =nPoint
	
	ldr		r0, =sTable		@Table
	mov		r1, r4
	bl		printf
	
	ldr 	r0, =nPlayer 	@You
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #0]
	ldrb	r2, [r5, #0]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Your Cards
	bl		printf
	ldr		r9, =hPlayer
	mov		r6, #0
	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test
	
	ldr 	r0, =nCom1 		@Com1 (Mike)
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #1]
	ldrb	r2, [r5, #1]	
	bl		printf
	
	ldr 	r0, =sHand 		@Show Mike's Cards
//	bl		printf
	ldr		r9, =hCom1
	mov		r6, #1
//	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test
	
	ldr 	r0, =nCom2		@Com2 (Bill)
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #2]
	ldrb	r2, [r5, #2]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Bill's Cards
//	bl		printf
	ldr		r9, =hCom2
	mov		r6, #2
//	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test

	ldr 	r0, =nCom3 		@Com3 (Lisa)
	bl		printf
	ldr 	r0, =sPlayer
	ldrb	r1, [r6, #3]
	ldrb	r2, [r5, #3]
	bl		printf
	
	ldr 	r0, =sHand 		@Show Lisa's Cards
//	bl		printf
	ldr		r9, =hCom3
	mov		r6, #3
//	bl		showCard		@Test
	
	ldr		r6, =nPoint		@Test
	
	b		gamePlay
	
/* set first active player */
findFPlayer:
	mov		r11, lr
	bl		Rand			@Random Number (1 to 52)
	sub		r1, r1, #1		@(0 to 51)
	ldr		r3, =NofPlayer	@Number of Players
	ldr		r3, [r3]
setFPlayer:
	cmp		r1, r3
	blo		FPlayer
	sub		r1, r1, r3
	b		setFPlayer
FPlayer:
	ldr		r2, =aPlayer	@get active player
	str		r1, [r2]		@set First Player (index 0-1)
	bx		r11
	
	
showCard:
	mov		r11, lr

	ldr		r10, =cardFile	@String for ShowCard in Player's Hand
	
	mov		r8, #0			@index of card in Player's Hand
for:
	ldrb	r5, [r9, r8]
	cmp		r5, #0
	beq		endFor
	sub		r5, r5, #1
	lsl		r5, #2
	
	ldr		r1, [r10, r5]
	ldr		r0, =Hand
	str		r1, [r0]
	bl		printf			@print a card in your Hand
	
	ldr		r5, =nCard
	ldrb	r3, [r5, r6] @Test

	add		r8, r8, #1
	cmp		r8, r3
	blo		for
	
endFor:
	ldr		r5, =nCard
	ldr		r0, =enter	@print \n
	bl		printf
	
	bx		r11
	
	/*****	Control Game *****/
gamePlay:
	/*	end game if card in hand all player and on table = 0 */
	ldr		r5, =nCard
	ldrb	r3, [r5]
	ldrb	r2, [r5, #1]
	add		r3, r3, r2
	ldrb	r2, [r5, #2]
	add		r3, r3, r2
	ldrb	r2, [r5, #3]
	add		r3, r3, r2
	add		r3, r3, r4
	cmp		r3, #0		
	beq		exit
	
	ldr		r10, =cardFile		@ String for Show Card
	mov		r12, #0				@ index of Player
checkPoint:
	cmp		r12, #0
	bne		cYou
	ldr		r9, =hPlayer
	ldr		r6,	=nPlayer
cYou:
	cmp		r12, #1
	bne		cCom1
	ldr		r9, =hCom1
	ldr		r6, =nCom1
cCom1:
	cmp		r12, #2
	bne		cCom2
	ldr		r9, =hCom2
	ldr		r6, =nCom2
cCom2:
	cmp		r12, #3
	bne		cCom3
	ldr		r9, =hCom3
	ldr		r6, =nCom3
cCom3:
	/** check card in Player's Hand **/
	ldr		r5, =nCard
	ldrb	r3, [r5, r12]
	cmp		r3, #0
	bne		not0card
	cmp		r4, #0
	bne		getNewCard
	mov		r8, #0
	b		noPoint2
getNewCard:	
	/** drew card if no card in hand and on Table has cards **/
	mov		r8, #5
	mov		r0, r12
	bl		drewCard
	b		showTable
	
not0card:	
	mov		r8, #0
	mov		r11, #0
checkPoint2:
	/* read card in hand */
	ldrb	r5, [r9, r8]
	sub		r5, r5, #1
	lsl		r5, #2
	
	ldr		r1, =Hand
	ldr		r0, [r10, r5]
	str		r0, [r1]
	
	add		r8, r8, #1
	
	/* read next card in hand */
	ldrb	r5, [r9, r8]
	sub		r5, r5, #1
	lsl		r5, #2
	
	ldr		r2, =Hand2
	ldr		r0, [r10, r5]
	str		r0, [r2]
	
	ldr		r1, =Hand
	ldr		r2, =Hand2
	ldrb	r1, [r1]
	ldrb	r2, [r2]
	
	/** check if same rank card **/
	cmp		r1, r2
	bne		noPoint
	add		r11, r11, #1
	/** check if same rank card 3 times get 1 point and discard **/
	cmp		r11, #3
	bne		noPoint2
	
	/**	get set of rank card **/
	sub		r2, r8, #3
getPoint:
	mov		r10, r9				@card in player's hand
	mov		r1, r12				@index of Player
	bl		popCard				@discard
	add		r2, r2, #1			
	cmp		r2, r8 				@discard 4 cards
	bls		getPoint
	
	/** get 1 point **/
	ldr		r5, =nPoint
	ldrb	r3, [r5, r12]
	add		r3, r3, #1
	strb	r3, [r5, r12]
	
	/** check rank of same cards **/
	ldr		r1, =Hand
	ldr		r2, =ChosenN
	mov		r3, #32
	strb	r3, [r2, #1]
	ldrb	r1, [r1]
	strb	r1, [r2]
	cmp		r1, #49
	bne		noadd0
	mov		r3, #48
	strb	r3, [r2, #1]
noadd0:
	/** print get point **/
	ldr		r0, =enter2
	bl		printf

	ldr		r0, =get4card
	mov		r1, r6
	ldr		r2, =ChosenN
	mov		r3, r6
	bl		printf

	ldr		r0, =enter2
	bl		printf
	
	mov		r1, r12
	bl		sortCard
	
	b		showTable
	
noPoint:
	mov		r11, #0
noPoint2:
	ldr		r5, =nCard
	ldrb	r3, [r5, r12]
	cmp		r8, r3			@check Number of cards in Hand
	blo		checkPoint2
	ldr		r0, =NofPlayer
	ldr		r0, [r0]
	add		r12, r12, #1
	cmp		r12, r0			@check Number of Player for check point
	blo		checkPoint
	
	ldr		r0, =enter2
	bl		printf
	
	ldr		r2, =aPlayer	@get active player
	ldr		r1, [r2]

	ldr		r5, =nCard
	ldrb	r3, [r5, r1]
	cmp		r3, #0			@check if player no has card; skip his turn
	beq		noHave
	
	cmp		r1, #0
	beq		aYou			@Active Player is You
	cmp		r1, #1
	beq		aCom1			@Active Player is Mike
	cmp		r1, #2
	beq		aCom2			@Active Player is Bill
	cmp		r1, #3
	beq		aCom3			@Active Player is Lisa
	
	
aYou:	/* Your trun */
	ldr		r1, =askCard
	mov		r0, #0
	strb	r0, [r1]
	
	ldr		r0, =tPlayer		@print "Your turn:"
	bl		printf
	
	mov		r10, #1
	ldr		r3, =NofPlayer
	ldr		r3, [r3]
	cmp		r3, #2				@check if NofPlayer = 2. Don't choose player for asking
	bne		choosePlayer
	b		askRank
	
choosePlayer:	
	/* Choose the Player you want to ask */ 
	ldr		r0, =PlayerC
	bl		printf
	ldr		r0, =string
	ldr		r1, =ChosenP
	bl		scanf
	
	/*** Error if you no choose the Player in game ***/
	ldr		r1, =ChosenP
	ldr		r1, [r1]
	ldr		r2, =nCom1
	ldr		r2, [r2]
	cmp		r1, r2
	beq		askCom1			@change player's name to index 1
	
	ldr		r2, =nCom2
	ldr		r2, [r2]
	cmp		r1, r2
	beq		askCom2			@change player's name to index 2
	
	ldr		r2, =nCom3
	ldr		r2, [r2]
	ldr		r3, =NofPlayer
	ldr		r3, [r3]
	cmp		r3, #4			@check can't choose Lisa if NofPlayer = 4
	bne		errChoose3Player	
	cmp		r1, r2
	beq		askCom3			@change player's name to index 3
	b		errChoose4Player
	
askRank:
	/* Choose rank you want to ask */
	ldr		r0, =PlayerA
	ldr		r1, =ChosenP
	bl		printf
	ldr		r0, =string
	ldr		r1, =ChosenN
	bl		scanf
	
	/*** Error if the rank is not key (A,2,3,4,5,6,7,8,9,10,J,Q,or K)***/
	ldr		r2, =ChosenN
	ldrb	r1, [r2]
	
	/*** change key of rank card to index(1-13) ***/
	cmp		r1, #65				@A
	beq		getA
	cmp		r1, #49				@10
	beq		get10
	cmp		r1, #74				@J
	beq		getJ
	cmp		r1, #81				@Q
	beq		getQ
	cmp		r1, #75				@K
	beq		getK
	cmp		r1, #50				@2-9
	bhs		get2to9
	b		errChooseNumberKey
	
noErrorRank:
	/*** Error if the rank no has in your Hand ***/
	ldr		r9, =hPlayer		@Cards in your hand
	ldrb	r3, [r5, #0]		@Number of Card in your hand
	mov		r2, #0
	
checkRankCard:
	ldrb	r12, [r9, r2]		@Card Number (1-52)
	bl		mod13
	cmp		r1, r12
	beq		YouhaveCard
	add		r2, r2, #1
	cmp		r2, r3
	bne		checkRankCard
	b		errChooseNumber
YouhaveCard:
	ldr		r2, =askCard
	strb	r10, [r2, #1]
// 			r1				@card number for ask
//			r10 			@index of asked Player
	B		askedPlayer
	
aCom1:	/* Mike's trun */
	ldr		r1, =askCard
	mov		r0, #1
	strb	r0, [r1]
	
	ldr		r0, =tCom1
	bl		printf
	
	mov		r8, #1
	ldr		r2, =hCom1
	
	bl		Rand
	bl		modC
	ldrb	r12, [r2, r1]

	bl		mod13
	bl		comAsk
	
	ldr		r2, =NofPlayer
	ldr		r2, [r2]
	cmp		r2, #2
	beq		has2player
	
	bl		RandAskPlayer
	ldr		r2, =askCard
	strb	r1, [r2, #1]
	
	mov		r10, r6		
	b		not2player
has2player:
	mov		r10, #0
not2player:
	ldr		r2, =askCard
	strb	r10, [r2, #1]	@index of asked Player
	mov		r1, r12			@card number for ask
	
	B		askedPlayer
	
aCom2:	/* Bill's trun */
	ldr		r1, =askCard
	mov		r0, #2
	strb	r0, [r1]
	
	ldr		r0, =tCom2
	bl		printf
	
	mov		r8, #2
	ldr		r2, =hCom2
	
	bl		Rand
	bl		modC
	ldrb	r12, [r2, r1]
	
	bl		mod13
	bl		comAsk
	bl		RandAskPlayer
	ldr		r2, =askCard
	strb	r1, [r2, #1]
	
	mov		r10, r6
	mov		r1, r12			@card number for ask
	ldr		r2, =askCard	
	strb	r10, [r2, #1]	@index of asked Player
	
	B		askedPlayer
	
aCom3:	/* Lisa's trun */
	ldr		r1, =askCard
	mov		r0, #3
	strb	r0, [r1]
	
	ldr		r0, =tCom3
	bl		printf
	
	mov		r8, #3
	ldr		r2, =hCom3
	
	bl		Rand
	bl		modC
	ldrb	r12, [r2, r1]
	
	bl		mod13
	bl		comAsk
	bl		RandAskPlayer
	ldr		r2, =askCard
	strb	r1, [r2, #1]
	
	mov		r10, r6
	mov		r1, r12			@card number for ask
	ldr		r2, =askCard
	strb	r10, [r2, #1]	@index of asked Player
	
	B		askedPlayer
	
	/** Random Player for Ask Card (for Com play)**/
RandAskPlayer:
	mov		r11, lr
	ldr		r3, =NofPlayer
	ldr		r3, [r3]
reRand:
	bl		Rand
modP:
	cmp		r1, r8			@Check index of Player
	beq		reRand
	
	ldr		r5, =nCard		@Check card in Player's Hand
	ldrb	r2, [r5, r1]
	cmp		r2, #0
	beq		reRand
	
	cmp		r1, r3
	blo		RandAskPlayerend
	sub		r1, r1, r3
	b		modP
RandAskPlayerend:
	mov		r6, r1
	bx		r11
	
	/** for Random card(for Com play)**/
modC:
	ldr		r5, =nCard
	ldrb	r3, [r5, r8]
	cmp		r1, r3
	blo		modCEnd
	sub		r1, r1, r3
	b		modC
modCEnd:
	bx		lr

comAsk:
/***	set Rank for com play *****/
	ldr		r1, =ChosenN
	mov		r2, #32
	strb	r2, [r1,#1]
	cmp		r12, #1
	bne		notA
	mov		r2, #65
	strb	r2, [r1]
notA:
	cmp		r12, #10
	bne		not10
	mov		r2, #49
	strb	r2, [r1]
	mov		r2, #48
	strB	r2, [r1, #1]
not10:
	cmp		r12, #11
	bne		notJ
	mov		r2, #74
	strb	r2, [r1]
notJ:
	cmp		r12, #12
	bne		notQ
	mov		r2, #81
	strb	r2, [r1]

notQ:
	cmp		r12, #13
	bne		notK
	mov		r2, #75
	strb	r2, [r1]
	
notK:
	cmp		r12, #2		@more than 9 in ascii
	blo		not2to9
	cmp		r12, #10
	bhs		not2to9
	add		r2, r12, #48
	strb	r2, [r1]
not2to9:
	bx		lr
	
askedPlayer:
	mov		r6, r1		@Rank card
	
	/*	Asked Player	*/
	ldr		r1, =askCard
	ldrb	r1, [r1, #1]
	cmp		r1, #0			@You
	bne		noYou
	ldr		r8,	=nPlayer
	ldr		r10, =hPlayer
noYou:
	cmp		r1, #1			@Mike
	bne		noCom1
	ldr		r8, =nCom1
	ldr		r10, =hCom1
noCom1:
	cmp		r1, #2			@Bill
	bne		noCom2
	ldr		r8, =nCom2
	ldr		r10, =hCom2
noCom2:
	cmp		r1, #3			@Lisa
	bne		noCom3
	ldr		r8, =nCom3
	ldr		r10, =hCom3
noCom3:
	
	/*	Active Player	*/
	ldr		r1, =askCard
	ldrb	r1, [r1]
	cmp		r1, #0			@You
	bne		notYou
	ldr		r9, =hPlayer
	ldr		r11, =nPlayer
notYou:
	cmp		r1, #1			@Mike
	bne		notCom1
	ldr		r9, =hCom1
	ldr		r11, =nCom1
notCom1:
	cmp		r1, #2			@Bill
	bne		notCom2
	ldr		r9, =hCom2
	ldr		r11, =nCom2
notCom2:
	cmp		r1, #3			@Lisa
	bne		notCom3
	ldr		r9, =hCom3
	ldr		r11, =nCom3
notCom3:

	ldr		r0, =botPlay
	mov		r1, r11
	mov		r2, r8
	ldr		r3, =ChosenN
	bl		printf
	
	ldr		r0, =tab
	bl		printf
	
	mov		r0, r8
	bl		printf
	
	
	ldr		r5, =nCard
	
	ldr		r1, =askCard		@asked Player
	ldrb	r1, [r1, #1]
	ldrb	r3, [r5, r1]
	mov		r1, r6
	mov		r2, #0
RankCard:
	ldrb	r12, [r10, r2]		@Cards in asked Player
	bl		mod13
	cmp		r12, r1
	beq		haveCard
	add		r2, r2, #1
	cmp		r2, r3
	bne		RankCard
	
	/*	not have card */
	ldr		r0, =noCard
	mov		r1, r11
	bl		printf
	ldr		r0, =askCard
	ldrb	r0, [r0]
	mov		r8, #1
	bl		drewCard
	b		noHave
	
haveCard:
	
	/*	get card from other player */
	mov		r2, #0
	mov		r0, #0
search:
	ldrb	r12, [r10, r2]	@ Cards in asked Player
	bl		mod13
	cmp		r6, r12
	bne		noGet
	ldrb	r12, [r10, r2]
	ldr		r5, =nCard
	
	ldr		r1, =askCard
	ldrb	r1, [r1, #1]
	bl		popCard
	
	ldr		r1, =askCard
	ldrb	r1, [r1]
	ldrb	r3, [r5, r1]
	strb	r12, [r9, r3]	@ Cards in aPlayer
	add		r3, r3, #1
	strb	r3, [r5, r1]
	add		r0, r0, #1
	b		get
noGet:
	add		r2, r2, #1
get:
	ldr		r1, =askCard
	ldrb	r1, [r1, #1]
	ldrb	r3, [r5, r1]
	cmp		r2, r3
	bls		search
	
	ldr		r1, =askCard
	ldrb	r1, [r1]
	ldrb	r3, [r5, r1]
	bl		sortCard
	
	mov		r8, r9
	mov		r9, r10
	ldr		r1, =askCard
	ldrb	r1, [r1, #1]
	ldrb	r3, [r5, r1]
	bl		sortCard
	mov		r9, r8
	
	mov		r3, r0
	ldr		r0, =hasCard
	ldr		r1, =ChosenN
	mov		r2, r11
	bl		printf
	
	ldr		r0, =enter2
	bl		printf
	b		showTable
noHave:
	
	ldr		r0, =enter2
	bl		printf


	/*	Change active Player */
	ldr		r2, =aPlayer
	ldr		r1, [r2]
	add		r1, r1, #1
	ldr		r3, =NofPlayer
	ldr		r3, [r3]
	cmp		r1, r3
	bne		nextAPlayer
	mov		r1, #0		
nextAPlayer:
	str		r1, [r2]
	

showTable:
	ldr		r1, =NofPlayer
	ldr		r1, [r1]
	
	CMP		r1, #2
	BEQ		P2
	CMP		r1, #3
	BEQ		P3
	CMP		r1, #4
	BEQ		P4
	
exit:
	/** End Game **/
	/* Find Max Point */
	ldr		r6, =nPoint
	mov		r0, #0
	ldrb	r8, [r6, r0]
endPoint:
	ldrb	r2, [r6, r0]
	cmp		r2, r8
	blo		min
	mov		r8, r2		@max point
min:
	add		r0, r0, #1
	cmp		r0, #4
	blo		endPoint
	
	ldr		r0, =win
	bl		printf
	
	/* find Winner */
	mov		r9, #0
winner:
	ldrb	r2, [r6, r9]
	cmp		r2, r8
	bne		loser
	
	cmp		r9, #0			@You
	bne		wYou
	ldr		r0,	=nPlayer
wYou:
	cmp		r9, #1			@Mike
	bne		wCom1
	ldr		r0, =nCom1
wCom1:
	cmp		r9, #2			@Bill
	bne		wCom2
	ldr		r0, =nCom2
wCom2:
	cmp		r9, #3			@Lisa
	bne		wCom3
	ldr		r0, =nCom3
wCom3:
	bl		printf
	ldr		r0, =enter
	bl		printf
loser:	
	add		r9, r9, #1
	cmp		r9, #4
	blo		winner
exit2:
	add		sp, sp, #52	
	MOV 	R7, #1 		@ Exit Syscall
	SWI 	0

	
mod13:
	cmp		r12, #13
	bxls	lr
	sub		r12, r12, #13
	b		mod13
	
popCard:
	ldr		r5, =nCard
	ldrb	r3, [r5, r1]
	sub		r3, r3, #1			@index asked Player card
	strb	r3, [r5, r1]
	
	ldrb	r1, [r10, r3]
	strb	r1, [r10, r2]
	mov		r1, #0
	strb	r1, [r10, r3]
	bx		lr
	
drewCard:
	mov		r11, lr
	ldr		r5, =nCard
	ldrb	r3, [r5, r0]		@Number of Cards before drew 
	cmp		r8, #0				@times of drew
	bxeq	r11
	cmp		r4, #0				@if no card on the Table
	bxeq	r11
	
	mov		r12, #52			
	sub		r12, r12, r4		@index of card on the top
	ldrb	r1, [sp, r12]
	strb	r1, [r9, r3]
	add		r3, r3, #1
	mov		r1, r0
	bl		sortCard

	sub		r4, r4, #1			@Number of Cards on Table
	sub		r8, r8, #1
	strb	r3, [r5, r0]		@Number of Cards after drew
	mov		lr, r11
	b		drewCard
	
	/*** Random Number for drew Card from Table ***/
Rand:	
	mov		r7, #78		@get time
	ldr		r0, =t	
	mov		r1, #0
	svc		0
	
	ldr		r1, =t
	ldrb	r1, [r1, #4]	@microsec get 8 bit (0-127)
de:	
	cmp		r1, #51
	BLS		endRand
	sub		r1, r1, #52		@get 0-51
	B		de
endRand:
	add		r1, r1, #1
	BX		lr
	
	/**	Sort Rank Cards in Hand **/
sortCard:
	mov		r7, lr
	
	cmp		r1, #0
	bne		noP
	ldr		r9, =hPlayer
noP:cmp		r1, #1
	bne		noC1
	ldr		r9, =hCom1
noC1:cmp	r1, #2
	bne		noC2
	ldr		r9, =hCom2
noC2:cmp	r1, #3
	bne		noC3
	ldr		r9, =hCom3
noC3:

	mov		r1, #-1
sortR1:
	add		r1, r1, #1
	cmp		r1, r3
	bhs		endSortR
	mov		r2, r1
sortR2:
	add		r2, r2, #1
	cmp		r2, r3
	bhs		sortR1
	ldrb	r5, [r9, r1]
	ldrb	r6, [r9, r2]
	
	cmp		r5, r6
	blo		sortR2
	strb	r5, [r9, r2]
	strb	r6, [r9, r1]
	b		sortR2
endSortR:

	/**	Sort Cards in Hand **/
	mov		r1, #-1
sort1:
	add		r1, r1, #1
	cmp		r1, r3
	bhs		endSort
	mov		r2, r1
sort2:
	add		r2, r2, #1
	cmp		r2, r3
	bhs		sort1
	ldrb	r5, [r9, r1]
	ldrb	r6, [r9, r2]
	
	mov		r12, r5
	bl		mod13
	mov		r10, r12
	
	mov		r12, r6
	bl		mod13
	
	cmp		r10, r12
	bls		sort2
	strb	r5, [r9, r2]
	strb	r6, [r9, r1]
	b		sort2
endSort:
	ldr		r5, =nCard
	ldr		r6, =nPoint
	bx		r7

askCom1:
	mov		r10, #1		@ask Mike
	b		askRank
	
askCom2:
	mov		r10, #2		@ask Bill
	b		askRank
	
askCom3:
	mov		r10, #3		@ask Lisa
	b		askRank

getA:
	mov		r1, #1
	b		noErrorRank
	
get10:
	ldrb	r2, [r2, #1]	@chenk bit 2 in "10"
	cmp		r2, #48
	bne		errChooseNumberKey
	mov		r1, #10
	b		noErrorRank
	
getJ:
	mov		r1, #11
	b		noErrorRank

getQ:
	mov		r1, #12
	b		noErrorRank

getK:
	mov		r1, #13
	b		noErrorRank
	
get2to9:
	cmp		r1, #58		@more than 9 in ascii
	bhs		errChooseNumberKey
	sub		r1, r1, #48
	b		noErrorRank
	
	
	/**	Check ERROR msg **/
	
errChoose3Player:
	ldr		r0, =eChoose3Player
	bl		printf
	b		choosePlayer
	
errChoose4Player:
	ldr		r0, =eChoose4Player
	bl		printf
	b		choosePlayer
	
errChooseNumber:
	ldr		r0, =eChooseNumber
	ldr		r1, =ChosenN
	bl		printf
	b		askRank

errChooseNumberKey:
	ldr		r0, =eChooseNumberKey
	bl		printf
	b		askRank
