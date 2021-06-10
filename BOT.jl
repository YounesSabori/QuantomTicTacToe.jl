### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils
using Random



mutable struct Game
	"""
	De Arrays
	"""
	VerCir::Array 			#verzameling van de gevormde cirkels
	Toegestaan::Array 		#bevat de toegestane input van het spel 
	Zet::Array 				#geeft de beurten weer
	Aanvuller::Array 		#checkt hoeveel zetten een vak bevat en of het R is
	Positie::Array 			#de 2 gezetten posities van de spelers
	Bord::Array 			#bevat het alle arrays die het grid vormen
	Blokken::Array 			#bevat het grid
	TePlaatsen::Array 		#de arrays die een blok vormen in het grid
	GebruikteZetten::Array 	#de niet-toegestane vakken in aanvuller
	Traject::Array 			#het traject dat gevolgd wordt voor de R-zetten
	
	"""
	constantes
	"""
	Dimensions::Int64 		#de dimensies van het bord
end
QTTT = Game([],[],[1],[],[0,0],[],[],[],[],[],0)

mutable struct Bot
	Mid::Array
end

AI = Bot([])
	
 
#*************************************************************************************									
function Board!(n::Int64)
	println()
	@assert(2 < n,"numbers bigger then 2 please") #een QTTT.Bord met 3x3 submatrix
	amount = (n^2) * 3 							#aantal rijen van ["t ","t ","t "]
		for i in eachindex(QTTT.Bord)
			pop!(QTTT.Bord)						#maakt het huidige QTTT.Bord leeg
		end

		for i in 1:amount
			push!(QTTT.Bord,["   ","   ","   "])	#QTTT.Bord met 'amount' aantal elementen
		end
end

function draw_board(n::Int64)					#samenstelling QTTT.Bord
	print("┼")
	print("—"^10)								#de basisafbakening
	for _ in 1:n-1
		print("┼")								#afbakening afhankelijk van grootte
		print("—"^10)
	end
	println("┼")
	for i in 1:length(QTTT.Bord)
		print("| ")
		for n in 1:3
			if 'X' ∈ QTTT.Bord[i][n]
				printstyled(QTTT.Bord[i][n]; color = :yellow )
			elseif 'O' ∈ QTTT.Bord[i][n]
				printstyled(QTTT.Bord[i][n]; color = :light_blue )
			else
				print("   ")
			end
		end			
				
		
		if mod(i,n) == 0 					#na het zoveelste element nieuwe rij
			print("|")
			println("")
		end
		
		if mod(i,n*3) == 0 					#wnr het einde bereikt is, afsluiten
			print("┼")
			print("—"^10)
				for _ in 1:n-1
					print("┼")
					print("—"^10)
				end
			println("┼")
		end
		
	end
end	
	
function VakkenVormen!(n::Int64, Array)
	#We maken QTTT.TePlaatsen leeg zodat er geen extra elementen in worden gestapeld.
		for i in eachindex(QTTT.TePlaatsen)
				pop!(QTTT.TePlaatsen)
		end
		
		for i in eachindex(Array)
				pop!(Array)
		end
		
	#Van elk vakje hebben we steeds de eerste array nodig.
		for i in 0:n
	#In QTTT.TePlaatsen steken we alle getallen die naar die eerste arrays verwijzen.
			
			if 3+n*3*i <= trunc(Int64, length(QTTT.Bord))-2*n 
	#de bovengrens zorgt ervoor dat we niet voorbij de lengte van onze array gaan.
				for j in 1:n
				push!(QTTT.TePlaatsen,j+n*3*i)
				end
			end
		end
	#Hier groeperen we de arrays die een blok vormen, tussen elke array is er een spatie van 3*n(n = dimensies)
		for i in 1:length(QTTT.Bord)
				if i ∈ QTTT.TePlaatsen 
				push!(Array,[QTTT.Bord[i],QTTT.Bord[i+n],QTTT.Bord[i+2*n]])
				end
		end
end

#*************************************************************************************

#Animations
function Animations(n)
	if n == 1
	printstyled("   ▄▄▄▄   ▄  ▄   ▄   ▄  ▄ ▄▄▄ ▄  ▄ ▄     ▄   ▄▄▄ ▄▄▄ ▄▄▄";color=:red)
	println()  
	printstyled("   █  █   █  █  █▄█  █▀▄█  █  █  █ █▀▄ ▄▀█    █   █   █";color=:red)
	println()
	printstyled("   ▀▀▀▀▄  █▄▄█ █   █ █  █  █  █▄▄█ █  ▀  █    █   █   █";color=:red)
	println()
	printstyled("———————————————————————————————————————————————————————————";color=:red)
	end
	if n == 2
	printstyled("  ▀▄ ▄▀   ▄       ▄  ▄▄▄  ▄   ▄  ▄▄▄▄   ▄";color=:red)
	println()  
	printstyled("    █     █   ▄   █   █   █▀▄ █  █▄▄▄   █";color=:red)
	println()
	printstyled("  ▄▀ ▀▄    ▀▄▀ ▀▄▀   ▄█▄  █  ▀█  ▄▄▄█   ▄";color=:red)
	println()
	printstyled("———————————————————————————————————————————————————————————";color=:red)
	end
	if n == 3
	printstyled("  ▄▀▀▀▄   ▄       ▄  ▄▄▄  ▄   ▄  ▄▄▄▄   ▄";color=:red)
	println()  
	printstyled("  █   █   █   ▄   █   █   █▀▄ █  █▄▄▄   █";color=:red)
	println()
	printstyled("  ▀▄▄▄▀    ▀▄▀ ▀▄▀   ▄█▄  █  ▀█  ▄▄▄█   ▄";color=:red)
	println()
	printstyled("———————————————————————————————————————————————————————————";color=:red)
	end
		if n == 4
	printstyled("  ▄   ▄   ▄▄▄       ▄▄▄   ▄   ▄  ▄▄▄▄    ▄       ▄  ▄▄▄  ▄   ▄  ▄▄▄▄   ▄";color=:red)
	println()  
	printstyled("  █▀▄ █  █   █     █   █  █▀▄ █  █▄▄▄    █   ▄   █   █   █▀▄ █  █▄▄▄   █";color=:red)
	println() 
	printstyled("  █  ▀█  ▀▄▄▄▀     ▀▄▄▄▀  █  ▀█  █▄▄▄     ▀▄▀ ▀▄▀   ▄█▄  █  ▀█  ▄▄▄█   ▄";color=:red)
	println()
	printstyled("———————————————————————————————————————————————————————————";color=:red)
	end	
	if n == 5
	printstyled("  █▀▀▀▄  █▀▀▄    ▄   █       █   █";color=:red)
	println()  
	printstyled("  █   █  █▄▄▀   █▄█  █   ▄   █   █";color=:red)
	println() 
	printstyled("  █▄▄▄▀  █  █  █   █  ▀▄▀ ▀▄▀    ▄";color=:red)
	println()
	printstyled("———————————————————————————————————————————————————————————";color=:red)
	end	
end

#*************************************************************************************
function KeyInput()
    ret = ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, true)
    ret == 0 || error("unable to switch to raw mode")
    c = read(stdin, Char)
    ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, false)
   return  c
end

function leave()
	println("Press m if you want to go to the menu")
    println("Press r if you want to restart")
    println("Press q to quit!");
    while true
        opt = KeyInput();
        if opt == 'r'
        	println("")
        	println("")
        	run(Cmd(["cmd", "/c", "cls"]))
            include("BOT.jl")
            exit()
        elseif opt =='q'
        	run(Cmd(["cmd", "/c", "cls"]))
        	exit()
        elseif opt =='m'
        	run(Cmd(["cmd", "/c", "cls"]))
        	include("menu.jl")
        	exit()
        else
            continue
        end
    end	
end

#controleren van het winnen 
function diagonal(K)
	diag = [] 
		for i in 1:K
			push!(diag,QTTT.Blokken[(i-1)*K+i][2][2][1])
		end
	diag
end

function antidiagonal(K)
	antidiag = [] 
		for i in 1:K
			push!(antidiag,QTTT.Blokken[K*i-(i-1)][2][2][1])
		end
	return antidiag
end

function vertical(K)
	vert = []
		for i in 1:K
			for n in 0:K-1
				push!(vert,QTTT.Blokken[i+n*K][2][2][1])
			end
		end
		ver = []
		for i in 1:K
			push!(ver,vert[(K*i)-(K-1):K*i])
		end
	return ver
end
	
function horizontal(K)
	hori = []
		for i in 0:K-1
			for n in 1:K
				push!(hori,(QTTT.Blokken[i*K+n][2][2][1]))
			end
		end
	hor = []
		for i in 1:K
			push!(hor,hori[(K*i)-(K-1):K*i])
		end
	return hor
end 

function ControlWin(K)
	antidiag = antidiagonal(K)
	diag = diagonal(K)
	hor = horizontal(K)
	ver = vertical(K)

	X = []
	O = []
	for i in 1:K 
		push!(X,'X') 
	end
	for i in 1:K 
		push!(O,'O') 
	end

	a = 0
	b = 0
	
	for i in 1:K
		if hor[i] == X || X == antidiag || X == diag || ver[i] == X
			a = 1
		end
		if hor[i] == O || O == antidiag || O == diag || ver[i] == O
			b = 1
		end
	end
	
	if a == 1 && b == 1 
		println()
		Animations(5)
		println()
		leave() 		
	elseif a == 1 
		println()
		Animations(2)
		println()
		leave()		
	elseif b == 1 
		println()
		Animations(3)
		println()
		leave() 
	end 
		
	for i in 1:K
		if ' ' ∉ hor[i] && ' ' ∉ antidiag && ' ' ∉ diag && ' ' ∉ ver[i]
			println()
			Animations(4)
			leave()
		end
	end		
end


#*************************************************************************************

#Robot 
function r_bord(Aanvuller)
	bord = [[] for i in 1:QTTT.Dimensions]
	test = []
		for i in 1:QTTT.Dimensions^2
			if Aanvuller[i][2] == 4
				push!(test, "$(collect(QTTT.Blokken[i][2][2])[1])")
			else
				push!(test, " ")
			end
		end
	a = 1
	b = 0
	for j in 1:length(test)
		b+=1
		if b == QTTT.Dimensions+1
			a+=1
			b = 1
		end
		push!(bord[a],test[j])
	end
	return bord
end

function c_bord()
	vert = []
	for i in 1:K
		for n in 0:K-1
			if QTTT.Aanvuller[i+n*K][2] == 4
			push!(vert,"$(collect(QTTT.Blokken[i+n*K][2][2][1])[1])")
			else
			push!(vert, "  ")
			end
		end
	end
	ver = []
	for i in 1:K
		push!(ver,vert[(K*i)-(K-1):K*i])
	end
	
	return ver
end

function antidiag_bord()
	antidiag = [] 
		for i in 1:QTTT.Dimensions
			if QTTT.Aanvuller[QTTT.Dimensions^2-(QTTT.Dimensions-1)*i][2] == 4
				push!(antidiag,collect(QTTT.Blokken[QTTT.Dimensions^2-(QTTT.Dimensions-1)*i][2][2])[1] )
			else
				push!(antidiag,"   ")
			end
		end
	return antidiag
end

function diag_bord()
	diag = [] 
		for i in 0:QTTT.Dimensions-1
			if QTTT.Aanvuller[1+(QTTT.Dimensions+1)*i][2] == 4
				push!(diag,collect(QTTT.Blokken[1+(1+QTTT.Dimensions)*i][2][2])[1] )
			else
				push!(diag,"   ")
			end
		end
	return diag
end

function Midden()
	for i in 1:(QTTT.Dimensions-2)
		for k in 2:(QTTT.Dimensions-1)
			push!(AI.Mid,i*QTTT.Dimensions +k)
		end
	end
end

function locaties(Aanvuller)
	D = QTTT.Dimensions
	valid_loc = []
	for i in 1:D^2
		if Aanvuller[i][2] != 4
			push!(valid_loc,i)
		end
	end
	return valid_loc
end

function mid_cntrl(pos1, pos2)  #posities zijn van de speler, checkt hoeveel zetten van de speler in het midden liggen 

	if pos1 ∉ AI.Mid && pos2 ∉ AI.Mid
		return []
	end

	if pos1 in AI.Mid
		if pos2 in AI.Mid
			#beiden zetten van de bot zelfde zetten als speler
			return [pos1, pos2]
		elseif pos2 ∉ AI.Mid
			#1 zet van de 2 is pos1
			#doe minimax met de andere zet
			return [pos1]
		end
	end

	if pos2 in AI.Mid
		if pos1 in AI.Mid
			#beiden zetten van de bot zelfde zetten als speler
			return [pos1, pos2]
		elseif pos1 ∉ AI.Mid
			#1 zet van de 2 is pos2
			#doe minimax met de andere zet
				return [pos2]
		end
	end
end

function score_amount(line, player1,player2)	#player2 = tegenstander	
	D = QTTT.Dimensions

	score = 0
		if count(e->e==player2 ,line) == D
					score -= 100000
		elseif count(e->e==player2,line) == D-1
			if count(e->e == player1, line) == 1
			score +=50000
			else
			score -=300
			end
		elseif count(e->e==player2,line) == D-2
			if count(e->e == player1, line) == 1
			score +=25
			else
			score -= 50
			end
		elseif	count(e->e==player2,line) == D-3 && D >3
			if count(e->e == player1, line) == 1
			score +=25
			else
			score -=60
			end

		elseif count(e->e==player1 ,line) == D
			score+=10000000
		end
	return score
end

function score_pos(aanvuller::Array,player1, player2)
	D = QTTT.Dimensions
	#dim in een rij
	#println("$(QTTT.Bord)")
	score = 0

	#horizontaal

	R_bord = r_bord(aanvuller)
	for r in 1:D
		row	= R_bord[r]	#de eerste rij dan de tweede, ...
		score += score_amount(row, player1, player2)
	end

	#verticaal
	C_bord = c_bord()
	for c in 1:D
		colom = C_bord[c] 
		score += score_amount(colom, player1, player2)
	end 

	#diagonaal
	diagonaal = diag_bord()
	score+=score_amount(diagonaal, player1, player2)

	#anti-diagonaal
	antidiagonaal = antidiag_bord()
	score+=score_amount(antidiagonaal, player1, player2)

	return score
end

function AI_move(player, vak)
	QTTT.Aanvuller[vak][2] += 1
	
	if QTTT.Aanvuller[vak][2] > 3 				#rij vol? -> volgende rij
		QTTT.Aanvuller[vak][1] += 1
		QTTT.Aanvuller[vak][2] = 1
	end

	QTTT.Blokken[vak][QTTT.Aanvuller[vak][1]][QTTT.Aanvuller[vak][2]] = player	
end

function Ai(move1, move2, player1, player2#=tegenstander=#)
	AI_move(player1, move1)
	AI_move(player1, move2)
	ControleCirkel(move1, move2, player1)
	QTTT.Zet[1] +=1
end

function AI_win(K)
	antidiag = antidiagonal(K)
	diag = diagonal(K)
	hor = horizontal(K)
	ver = vertical(K)

	X = []
	O = []
	for i in 1:K 
		push!(X,'X') 
	end
	for i in 1:K 
		push!(O,'O') 
	end

	a = 0
	b = 0
	
	for i in 1:K
		if hor[i] == X || X == antidiag || X == diag || ver[i] == X
			a = 1
		end
		if hor[i] == O || O == antidiag || O == diag || ver[i] == O
			b = 1
		end
	end
	
	if a == 1 && b == 1 
		return true		
	elseif a == 1 
		return true
		
	elseif b == 1 
		return true
	end 
		
	for i in 1:K
		if ' ' ∉ hor[i] && ' ' ∉ antidiag && ' ' ∉ diag && ' ' ∉ ver[i]
			return true
		end
	end	
	return false	
end

function Vak_waarde()
	a = []
	for i in 1:QTTT.Dimensions^2
		if i in AI.Mid
			push!(a,10)
		elseif i == 1 || i == QTTT.Dimensions || i == QTTT.Dimensions^2 || i == QTTT.Dimensions^2-(QTTT.Dimensions-1)
			push!(a,7)
		else
			push!(a,1)
		end
	end
	return a
end

function minimax(diepte,enkel, ingenomen)
	#players
		if QTTT.Zet[1] > 9
			Player1 = "X"*"$(QTTT.Zet[1])"					
		else
			Player1 = "X"*"$(QTTT.Zet[1])"*" "					
		end
		
		if QTTT.Zet[1] > 9					
			Player2 = "O"*"$(QTTT.Zet[1])"
		else					
			Player2 = "O"*"$(QTTT.Zet[1])"*" "
		end
	#backup
		aanvuller = deepcopy(QTTT.Aanvuller)
		vercir = deepcopy(QTTT.VerCir)
		zet = deepcopy(QTTT.Zet) 
		bord = deepcopy(QTTT.Bord) 
		VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
		gz = deepcopy(QTTT.GebruikteZetten)
		tr = deepcopy(QTTT.Traject)
	println("minimax will it be!")
	result = AI_win(QTTT.Dimensions)
	val_pos = locaties(QTTT.Aanvuller)
	
	beste_zet = []
		
		beste_score = -Inf
		
		QTTT.Zet[1]+=1
	if enkel == false
		for i in val_pos
			new = shuffle!(filter(e->e !=i, val_pos))
			for j in new
				
				#save
					QTTT.Aanvuller = deepcopy(aanvuller)
					QTTT.VerCir = deepcopy(vercir)
					QTTT.Zet = deepcopy(zet)
					QTTT.Bord = deepcopy(bord)
					VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
					QTTT.GebruikteZetten = deepcopy(gz)
					QTTT.Traject = deepcopy(tr)	
			
				AI_move(Player2, i)
				AI_move(Player2, j)
				ControleCirkel(i,j,Player2)
				score = xzet(diepte-1)

				if score > beste_score
					beste_score = score
					beste_zet = [i,j]
				end
				
			end
		end
		#save
					QTTT.Aanvuller = deepcopy(aanvuller)
					QTTT.VerCir = deepcopy(vercir)
					QTTT.Zet = deepcopy(zet)
					QTTT.Bord = deepcopy(bord)
					VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
					QTTT.GebruikteZetten = deepcopy(gz)
					QTTT.Traject = deepcopy(tr)	
		return beste_zet
	else
		val_pos = locaties(QTTT.Aanvuller)
		for j in filter(e->e !=ingenomen, val_pos)
			#save
				QTTT.Aanvuller = deepcopy(aanvuller)
				QTTT.VerCir = deepcopy(vercir)
				QTTT.Zet = deepcopy(zet)
				QTTT.Bord = deepcopy(bord)
				VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
				QTTT.GebruikteZetten = deepcopy(gz)
				QTTT.Traject = deepcopy(tr)
			AI_move(Player2, j)
			ControleCirkel(ingenomen,j,Player2)
			score = xzet(diepte-1)

			if score > beste_score
				beste_score = score
				beste_zet = [j]
			end
					
				
		end
		#save
					QTTT.Aanvuller = deepcopy(aanvuller)
					QTTT.VerCir = deepcopy(vercir)
					QTTT.Zet = deepcopy(zet)
					QTTT.Bord = deepcopy(bord)
					VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
					QTTT.GebruikteZetten = deepcopy(gz)
					QTTT.Traject = deepcopy(tr)	
		return beste_zet
	end
	#save
					QTTT.Aanvuller = deepcopy(aanvuller)
					QTTT.VerCir = deepcopy(vercir)
					QTTT.Zet = deepcopy(zet)
					QTTT.Bord = deepcopy(bord)
					VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
					QTTT.GebruikteZetten = deepcopy(gz)
					QTTT.Traject = deepcopy(tr)	
end

function xzet(diepte)
	#backup
		aanvuller = deepcopy(QTTT.Aanvuller)
		vercir = deepcopy(QTTT.VerCir)
		zet = deepcopy(QTTT.Zet) 
		bord = deepcopy(QTTT.Bord) 
		VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
		gz = deepcopy(QTTT.GebruikteZetten)
		tr = deepcopy(QTTT.Traject)
	beste_score = +Inf
	result = AI_win(QTTT.Dimensions)
	val_pos = locaties(QTTT.Aanvuller)
	QTTT.Zet[1]+=1
	
	#players
		if QTTT.Zet[1] > 9
			Player1 = "X"*"$(QTTT.Zet[1])"					
		else
			Player1 = "X"*"$(QTTT.Zet[1])"*" "					
		end
		
		if QTTT.Zet[1] > 9					
			Player2 = "O"*"$(QTTT.Zet[1])"
		else					
			Player2 = "O"*"$(QTTT.Zet[1])"*" "
		end
	beste_zet = []
	if result == true || diepte == 0
		score = score_pos(QTTT.Aanvuller, Player2, Player1)
		return score
	else
		for i in val_pos
		
	
		new = shuffle!(filter(e->e !=i, val_pos))
			for j in new
				#save
					QTTT.Aanvuller = deepcopy(aanvuller)
					QTTT.VerCir = deepcopy(vercir)
					QTTT.Zet = deepcopy(zet)
					QTTT.Bord = deepcopy(bord)
					VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
					QTTT.GebruikteZetten = deepcopy(gz)
					QTTT.Traject = deepcopy(tr)
				AI_move(Player1, i)
				AI_move(Player1, j)
				ControleCirkel(i,j,Player1)
				score = aizet(diepte-1)

				if score < beste_score
					beste_score = score
					beste_zet = [i,j]
				end
				
			end
		end
	end
	#save
				QTTT.Aanvuller = deepcopy(aanvuller)
				QTTT.VerCir = deepcopy(vercir)
				QTTT.Zet = deepcopy(zet)
				QTTT.Bord = deepcopy(bord)
				VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
				QTTT.GebruikteZetten = deepcopy(gz)
				QTTT.Traject = deepcopy(tr)
	return beste_score
end

function aizet(diepte)
	#backup
		aanvuller = deepcopy(QTTT.Aanvuller)
		vercir = deepcopy(QTTT.VerCir)
		zet = deepcopy(QTTT.Zet) 
		bord = deepcopy(QTTT.Bord) 
		VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
		gz = deepcopy(QTTT.GebruikteZetten)
		tr = deepcopy(QTTT.Traject)
	beste_score = -Inf
	result = AI_win(QTTT.Dimensions)
	val_pos = locaties(QTTT.Aanvuller)
	QTTT.Zet[1]+=1
	
	#players
		if QTTT.Zet[1] > 9
			Player1 = "X"*"$(QTTT.Zet[1])"					
		else
			Player1 = "X"*"$(QTTT.Zet[1])"*" "					
		end
		
		if QTTT.Zet[1] > 9					
			Player2 = "O"*"$(QTTT.Zet[1])"
		else					
			Player2 = "O"*"$(QTTT.Zet[1])"*" "
		end
	beste_zet = []
	if result == true || diepte == 0
		score = score_pos(QTTT.Aanvuller, Player2, Player1)
		return score
	
	else
		for i in val_pos
			
			new = shuffle!(filter(e->e !=i, val_pos))
			for j in new
				#save
					QTTT.Aanvuller = deepcopy(aanvuller)
					QTTT.VerCir = deepcopy(vercir)
					QTTT.Zet = deepcopy(zet)
					QTTT.Bord = deepcopy(bord)
					VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
					QTTT.GebruikteZetten = deepcopy(gz)
					QTTT.Traject = deepcopy(tr)
				AI_move(Player2, i)
				AI_move(Player2, j)
				ControleCirkel(i,j,Player2)
				score = aizet(diepte-1)

				if score > beste_score
					beste_score = score
					beste_zet = [i,j]
				end
				
			end
		end
	end
	#save
				QTTT.Aanvuller = deepcopy(aanvuller)
				QTTT.VerCir = deepcopy(vercir)
				QTTT.Zet = deepcopy(zet)
				QTTT.Bord = deepcopy(bord)
				VakkenVormen!(QTTT.Dimensions, QTTT.Blokken)
				QTTT.GebruikteZetten = deepcopy(gz)
				QTTT.Traject = deepcopy(tr)
	return beste_score
end

function Algoritme(AI, tegenstander)
	diepte = 3
	println("Bots turn")
	Midden()
	Val_loc = locaties(QTTT.Aanvuller)
	mid = mid_cntrl(QTTT.Positie[1],QTTT.Positie[2])
	score_vak = Vak_waarde()
	#stap1 == lengte van mid bepalen
	
	if QTTT.Aanvuller[QTTT.Positie[1]][2] == 4 || QTTT.Aanvuller[QTTT.Positie[2]][2]==4
	    		
		#indien beide zetten niet op en liggen // minimax
		
		optimaal = minimax(diepte,false, 0)
		println("$optimaal")
	
		Ai(optimaal[1], optimaal[2], AI, tegenstander)
	elseif length(mid) == 2
		prinln("beiden zetten zijn in het midden")
		#maak beiden zetten direct R
		Ai(QTTT.Positie[1], QTTT.Positie[2], AI, tegenstander)
	elseif length(mid) == 1
		println("een zet zit in het midden")
		#indien de 2de zet op een hoek is
		if score_vak[QTTT.Positie[1]] == 7 || score_vak[QTTT.Positie[2]] == 7
			println("de tweede ligt op een hoek")
			Ai(QTTT.Positie[1], QTTT.Positie[2], AI, tegenstander)

		else
			#indien de tweede zet niet op een hoek ligt // minimax voor 2de zet
			if score_vak[QTTT.Positie[1]] == 10
				println("de tweede ligt niet op een hoek")
				
				optimaal = minimax(diepte,true, QTTT.Positie[1])
				println("$optimaal")
			
				Ai(QTTT.Positie[1], optimaal[1], AI, tegenstander)
			elseif	score_vak[QTTT.Positie[2]] == 10
				println("de eerste ligt niet op een hoek")
				
				optimaal = minimax(diepte,true, QTTT.Positie[2])
				println("$optimaal")
			
				Ai(QTTT.Positie[2], optimaal[1], AI, tegenstander)

			end
		end
	else
		#als de beiden zetten op een hoek staan
		if score_vak[QTTT.Positie[1]] == 7 && score_vak[QTTT.Positie[2]] == 7
			println("beiden zetten liggen op een hoek")
				Ai(QTTT.Positie[1], QTTT.Positie[2], AI, tegenstander)
		#indien 1 van de op een hoek is en de andere niet in het midden 
		elseif score_vak[QTTT.Positie[1]] == 7 || score_vak[QTTT.Positie[2]] == 7
			println("1 zet ligt op een hoek en de andere NIET in het midden")

			if score_vak[QTTT.Positie[1]] == 7
				println("de 2de ligt niet op een hoek")
				
				optimaal = minimax(diepte,true, QTTT.Positie[1])
				
				Ai(QTTT.Positie[1], optimaal[1], AI, tegenstander)	
			else
				println("de 1ste ligt niet op een hoek")
				
				optimaal = minimax(diepte,true, QTTT.Positie[2])
				
				Ai(QTTT.Positie[2], optimaal[1], AI, tegenstander)	
			end
		else
			println("beiden liggen noch in de hoeken noch in het midden")
			#indien beide zetten niet op en liggen // minimax
			
			optimaal = minimax(diepte,false, 0)
			println("$optimaal")
			
			Ai(optimaal[1], optimaal[2], AI, tegenstander)
		end
	end
end

#*************************************************************************************
function DeepControle(posOut, VP)	#VP = QTTT.Positie die we moeten vermijden
	for j in 1:length(QTTT.VerCir)
		if posOut in QTTT.VerCir[j] && j != VP
			append!(QTTT.VerCir[VP],QTTT.VerCir[j])
			deleteat!(QTTT.VerCir,j)
			return true
			break
		end
	end	
end

function ControleCirkel(pos1::Int64, pos2::Int64,player)  
	if QTTT.VerCir == []
		push!(QTTT.VerCir,[pos1,pos2])
		
	else
		for i in 1:length(QTTT.VerCir)
			if pos1 in QTTT.VerCir[i] && pos2 in QTTT.VerCir[i]
				R_Zet!(QTTT.VerCir[i],pos1,pos2,player)
				deleteat!(QTTT.VerCir,i)
				
				
				#return true
				
				break
			elseif pos2 in QTTT.VerCir[i] && pos1 ∉ QTTT.VerCir[i]
			
				if DeepControle(pos1, i) == true
					DeepControle(pos1, i)
					break
				else
					push!(QTTT.VerCir[i],pos1)
				end
			elseif pos1 in QTTT.VerCir[i] && pos2 ∉ QTTT.VerCir[i]
				
				if DeepControle(pos2, i) == true
						DeepControle(pos2, i)
					break
				else
					push!(QTTT.VerCir[i],pos2)
				end
			end
		end
		
		verzameling = [] 		#alle gezette zetten 
		for i in 1:length(QTTT.VerCir)
			for j in 1:length(QTTT.VerCir[i])
				push!(verzameling,QTTT.VerCir[i][j])
			end
		end
		
		if pos1 ∉ verzameling && pos2 ∉ verzameling
				push!(QTTT.VerCir,[pos1,pos2])
			
		end
	end	
end


function Volgorde(Cirkel,vermijdenVak,vermijdenElement)
	AndereE = []	#elementen die zich in vermijdenVak bevinden 
	Vak = []		#vakken die de coresponderende elementen bevatten
	push!(QTTT.GebruikteZetten,vermijdenVak)
	
	#zoeken we de andere elementen buiten VermijdenElement in vermijdenVak
	for i in 1:3
		for j in 1:3
			if QTTT.Blokken[vermijdenVak][i][j] != "   " && QTTT.Blokken[vermijdenVak][i][j] != vermijdenElement && QTTT.Blokken[vermijdenVak][i][j] ∉ AndereE
				
				push!(AndereE,QTTT.Blokken[vermijdenVak][i][j])
			end
		end
	end
	
	#zoeken we de de vakken die de zelfde elementen bevatten als vermijdenVak
	for element in AndereE[1:end]
		for i in Cirkel
			for j in 1:3
				for k in 1:3
					if QTTT.Blokken[i][j][k] == element && i != vermijdenVak && i ∉ QTTT.GebruikteZetten		
						push!(QTTT.Traject,[element,i])
						push!(Vak,i)
						push!(QTTT.GebruikteZetten,i)

					end
				end
			end	
		end
	end

	#indien alle elementen gevonden zijn met hun verbonden vakken stopt de 	recusiviteit.
	if isempty(Vak) == false && isempty(AndereE) == false
		
		for i in 1:length(Vak)
			Volgorde(Cirkel,Vak[i],AndereE[i])
		end

	end
end

function AndereElement(Cirkel,vermijdenElement,vermijdenVak)
	#R maken van de andere verbonden vakken
	Volgorde(Cirkel,vermijdenVak,vermijdenElement)
	
	for K in 1:length(QTTT.Traject)
		QTTT.Aanvuller[QTTT.Traject[K][2]][1] = 3
		QTTT.Aanvuller[QTTT.Traject[K][2]][2] = 4
			for i in 1:3
				for j in 1:3
			QTTT.Blokken[QTTT.Traject[K][2]][i][j] = "   "
				end
			end
		QTTT.Blokken[QTTT.Traject[K][2]][2][2] = QTTT.Traject[K][1]
	end
end

#R maken van het gekozen vak en element
function R_Zet!(Cirkel,pos1,pos2,player)
	#printstyled("Do you want to put $player in $pos1 or $pos2 : ";color=:green)
	Gekozen = rand([pos1,pos2])
	if Gekozen == pos1 || Gekozen == pos2
		QTTT.Aanvuller[Gekozen][1] = 3
		QTTT.Aanvuller[Gekozen][2] = 4
		AndereElement(Cirkel,player,Gekozen)
			for i in 1:3
				for j in 1:3
					QTTT.Blokken[Gekozen][i][j] = "   "
				end
			end
		QTTT.Blokken[Gekozen][2][2] = player
	else
		R_Zet!(Cirkel,pos1,pos2,player)
	end
end

#indien in het spel nog 1 vak over is waarin er zetten kunne gezet worden, zal het spel niet meer gewonnen kunne worden door 1 van de 2 partijen dus zal het spel gestopt worden.
function CheckDonut()
	Donut = []
		for i in 1:QTTT.Dimensions^2
		if QTTT.Aanvuller[i][1] == 3 && QTTT.Aanvuller[i][2] > 3
			push!(Donut,i)
		end
	end
	
	if length(Donut) == QTTT.Dimensions^2 - 1
		println()
		printstyled(" "^5,"Nobody won..."; color = :yellow )
		println()
		leave()
	end
end


function makemove!(player,vak::Int64,Zet)		#dit kiest het in te vullen vak
	
	#indien er een zet gezet wordt in een Reëel vak
	if QTTT.Aanvuller[vak][1] == 3 && QTTT.Aanvuller[vak][2] > 3
		printstyled("This square is already real, chose another one: "; color = :green )

		QTTT.Positie[Zet] = InputControle(readline())
		while QTTT.Aanvuller[QTTT.Positie[Zet]][2] > 3 
			printstyled("This square is already real, chose another one: "; color = :green )				
			QTTT.Positie[Zet] = InputControle(readline())
		end
		
		if Zet == 2
			while QTTT.Positie[Zet] == QTTT.Positie[1]		
				println()
				printstyled("That's the same position: "; color = :green )
				QTTT.Positie[Zet] = InputControle(readline())
			end
			makemove!(player,QTTT.Positie[Zet],Zet)
		else
			makemove!(player,QTTT.Positie[Zet],Zet)
		end
	else

		QTTT.Aanvuller[vak][2] += 1

		if QTTT.Aanvuller[vak][2] > 3 				#rij vol? -> volgende rij
			QTTT.Aanvuller[vak][1] += 1
			QTTT.Aanvuller[vak][2] = 1
		end
		QTTT.Blokken[vak][QTTT.Aanvuller[vak][1]][QTTT.Aanvuller[vak][2]] = player
		#invullen
	end
end

#functie die gaat controleren of de gegeven input wel behoort tot het grid
function InputControle(input)
	if uppercase(input) == "QUIT"
		leave()
	else
		while input ∉ QTTT.Toegestaan
			println()
			printstyled("Number must be between 1 and $(QTTT.Dimensions^2): ";color=:green)				
			input = readline()
			InputControle(input)	#dan kun je ook quit invullen je laten leaven
		end
		input=parse(Int64,input)
		return input
	end
end

#functie die het verloop van het spel reguleert, het laat de zetten uitvoeren en controleert ze nadien door gebruik te maken van voorgaande functie.	
function play(player,persoon)

	printstyled("Player $persoon first move: ";color=:green) 
	
	QTTT.Positie[1] = InputControle(readline())	
	
	makemove!(player,QTTT.Positie[1],1)   
	run(Cmd(["cmd", "/c", "cls"]))    									
	draw_board(K)
	printstyled("Player $persoon second move: ";color=:green)               			
	
	QTTT.Positie[2] = InputControle(readline())
	while QTTT.Positie[1] == QTTT.Positie[2] 					#niet twee keer hetzelfde vak
		printstyled("That's the same position... :";color=:green)		
		QTTT.Positie[2] = InputControle(readline()) 	
	end
	makemove!(player,QTTT.Positie[2],2)								
	
	
	QTTT.Zet[1] += 1										#de volgende zet
	ControleCirkel(QTTT.Positie[1],QTTT.Positie[2],player)
	run(Cmd(["cmd", "/c", "cls"]))
	draw_board(K)
end

#*************************************************************************************
#Hier begint het spel effectief	
	Animations(1)
	println()
	println()
	println(uppercase("If you want to leave mid-game, type: quit"))
	println()

	print("What must be the dimensions of your grid? : ")
	QTTT.Dimensions = parse(Int64,readline())


	for i in 1:QTTT.Dimensions^2
		push!(QTTT.Aanvuller,[1,0])
		push!(QTTT.Toegestaan,string(i))
	end

	K = QTTT.Dimensions 					
	Board!(K)
	draw_board(K)
	VakkenVormen!(K,QTTT.Blokken)
		

	#deze blok zorgt voor de continuïteit van het spel
	while true 

		if QTTT.Zet[1] > 9
			Player1 = "X"*"$(QTTT.Zet[1])"					
		else
			Player1 = "X"*"$(QTTT.Zet[1])"*" "					
		end
		
		play(Player1,1)
		ControlWin(K)
		CheckDonut()
		if QTTT.Zet[1] > 9					
			Player2 = "O"*"$(QTTT.Zet[1])"
		else					
			Player2 = "O"*"$(QTTT.Zet[1])"*" "
		end

		Algoritme(Player2,Player1)
		run(Cmd(["cmd", "/c", "cls"]))
		draw_board(K)
		ControlWin(K)
		CheckDonut()
	end

