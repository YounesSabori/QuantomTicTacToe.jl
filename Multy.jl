### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ e9e9e950-95f1-11eb-39a6-5dcb271ef393
using PlutoUI

# ╔═╡ 5874c370-961c-11eb-12b5-cfcf7527e7af
#DeGroot-Sabori Productions

# ╔═╡ 5056f1d0-ae64-11eb-3967-c5194263eeb6
begin
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
end

# ╔═╡ 85dace80-a833-11eb-2c75-2123612c23a0
md"## Maken van het QTTT.Bord"

# ╔═╡ 7de3bba0-ae9c-11eb-1021-57c57de1f1ac
html"<br>"

# ╔═╡ f4456e62-95f1-11eb-0ade-8d57e514715a
begin 
									#maakt een lege matrix
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
#*************************************************************************************	
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
end

# ╔═╡ aa468980-a833-11eb-3bc5-5feb2fbcd2e6
md"## Vormen van de vakken"

# ╔═╡ 88a3a7d0-ae9c-11eb-31dd-ab3e7fa4ef2e
html"<br>"

# ╔═╡ b73822be-a833-11eb-18d9-1570b0f9cd65
md"""
Binnen elk vak van het grid zijn er 9 plaatsen waar er een quantum zet kan komen.
Om deze 9 plaatsen te realiseren, vormen we met 3 1x3 matrixen(die we uit *board[ ]* halen) 1 vak. Let echter op dat we **NIET** 3 opeenvolgende matrixen uit *board[ ]* pakken. We voegen de i-de, de i+n-de en de i+2n-de (n = de dimensie van het grid). want indien je alle matrixen uit *board[ ]* rangschikt om een grid te vormen zullen deze drie matrixen recht onder elkaar liggen Dus vormen ze een blok"""

# ╔═╡ 1b282cdb-e4b3-44f4-a8f5-d5bfc818546c
begin
	
	function VakkenVormen!(n::Int64=3)
#We maken QTTT.TePlaatsen leeg zodat er geen extra elementen in worden gestapeld.
		for i in eachindex(QTTT.TePlaatsen)
				pop!(QTTT.TePlaatsen)
		end
		
		for i in eachindex(QTTT.Blokken)
				pop!(QTTT.Blokken)
		end
		
#Van elk vakje hebben we steeds de eerste array nodig.
		for i in 0:n
#In QTTT.TePlaatsen steken we alle getallen die naar die eerste arrays verwijzen.
			
			if 3+n*3*i <= trunc(Int64, length(QTTT.Bord))-2*n 
# de bovengrens zorgt ervoor dat we niet voorbij de lengte van onze array gaan.
				for j in 1:n
				push!(QTTT.TePlaatsen,j+n*3*i)
				end
			end
		end
#Hier groeperen we de arrays die een blok vormen, tussen elke array is er een spatie van 3*n(n = dimensies)
		for i in 1:length(QTTT.Bord)
				if i ∈ QTTT.TePlaatsen 
				push!(QTTT.Blokken,[QTTT.Bord[i],QTTT.Bord[i+n],QTTT.Bord[i+2*n]])
				end
		end
	end
end

# ╔═╡ c6d9f680-ae97-11eb-2d6a-7b9cec7a2709
md""" ## Animaties
"""

# ╔═╡ b01f13d0-ae9c-11eb-0f16-41fdc4acb403
md"""
Functie die regelt welke animatie wanneer wordt geprint.
"""

# ╔═╡ bf5f2330-ae97-11eb-18ac-496f1633589a
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


# ╔═╡ ddf7ee80-ae97-11eb-00eb-b3b487176516
md""" ## Controle """

# ╔═╡ ef3c1900-ae97-11eb-28ae-677181f2de74
html"<br>"

# ╔═╡ 8ef9eece-a8ea-11eb-1d12-e590acb39c50
md"""
De ControlWin zal elke zet nagaan opdat er iemand gewonnen heeft. Eerst neemt hij vier functies. Deze functies nemen de waarde in het midden van een blok en steken het in een array. 3 arrays voor horizontale combinaties, 3 voor de verticale en 1 voor diagonaal en 1 voor antidiagonaal. Dan checkt hij opdat een array bestaat uit alleen X'en of O's. Indien dit true is print hij dat die persoon gewonnen is. Als alle arrays vol zitten en er niemand gewonnen heeft, zal hij printen dat er niemand heeft gewonnen."""

# ╔═╡ 415a7e5d-a3b9-4b98-8819-e9806e0d5f5c
begin
function KeyInput()
    ret = ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, true)
    ret == 0 || error("unable to switch to raw mode")
    c = read(stdin, Char)
    ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, false)
   return  c
end

function leave()
	println("Press m if you want to go to the menu.")
    println("Press r if you want to restart")
    println("Press q to quit!");
    while true
        opt = KeyInput();
        if opt == 'r'
        	println("")
        	println("")
        	run(Cmd(["cmd", "/c", "cls"]))
            include("Multy.jl")
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

#*************************************************************************************
	
	function diagonal(K)
		diag = [] 
			for i in 1:K
				push!(diag,QTTT.Blokken[(i-1)*K+i][2][2][1])
			end
		diag
	end
	
#*************************************************************************************	
	function antidiagonal(K)
		antidiag = [] 
			for i in 1:K
				push!(antidiag,QTTT.Blokken[K*i-(i-1)][2][2][1])
			end
		antidiag
	end

#*************************************************************************************
	
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
			ver
	end
	
#*************************************************************************************
	
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
		hor
	end 

#*************************************************************************************	
	
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
end

# ╔═╡ 047fb990-a833-11eb-3475-e733ba918060
md""" ### Vak Omtrent Het Verloop

"""

# ╔═╡ 3fdcb740-a833-11eb-055c-b524c78d2a24
 html"<br><br>"

# ╔═╡ 927b19a0-96ff-11eb-280f-21bf567ea2ec
#cell die alles gaat uitvoeren
begin
	
	
#*************************************************************************************#opstellen van de onderlinge verbindingen 
	# QTTT.VerCir = Verzameling Cirkels
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
					run(Cmd(["cmd", "/c", "cls"]))
					draw_board(K)
					
					
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
	
	#*************************************************************************************
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
		
		
		
		#*************************************************************************************

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
		printstyled("Do you want to put $player in $pos1 or $pos2 : ";color=:green)
		Gekozen = InputControle(readline())
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
	
	
	#*************************************************************************************	#indien in het spel nog 1 vak over is waarin er zetten kunne gezet worden, zal het spel niet meer gewonnen kunne worden door 1 van de 2 partijen dus zal het spel gestopt worden.
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
			exit()
		end
	end
	
#*************************************************************************************			
"""
opmerking: met de 2de while loop controleren we of we niet 2 keer dezelfde zet doen			
"""	
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
	#*************************************************************************************#functie die gaat controleren of de gegeven input wel behoort tot het grid
	
	
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
	


#*************************************************************************************#functie die het verloop van het spel reguleert, het laat de zetten uitvoeren en controleert ze nadien door gebruik te maken van voorgaande functie.	

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
		run(Cmd(["cmd", "/c", "cls"]))
		draw_board(K)
		
		QTTT.Zet[1] += 1										#de volgende zet
		ControleCirkel(QTTT.Positie[1],QTTT.Positie[2],player)
		
		
	end
	

#*************************************************************************************Hier begint het spel effectief	
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
	VakkenVormen!(K)
		
	
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
		
		play(Player2,2)	
		
		ControlWin(K)
		CheckDonut()
	end
	
end

# ╔═╡ Cell order:
# ╟─5874c370-961c-11eb-12b5-cfcf7527e7af
# ╟─e9e9e950-95f1-11eb-39a6-5dcb271ef393
# ╠═5056f1d0-ae64-11eb-3967-c5194263eeb6
# ╟─85dace80-a833-11eb-2c75-2123612c23a0
# ╟─7de3bba0-ae9c-11eb-1021-57c57de1f1ac
# ╠═f4456e62-95f1-11eb-0ade-8d57e514715a
# ╟─aa468980-a833-11eb-3bc5-5feb2fbcd2e6
# ╟─88a3a7d0-ae9c-11eb-31dd-ab3e7fa4ef2e
# ╟─b73822be-a833-11eb-18d9-1570b0f9cd65
# ╠═1b282cdb-e4b3-44f4-a8f5-d5bfc818546c
# ╟─c6d9f680-ae97-11eb-2d6a-7b9cec7a2709
# ╟─b01f13d0-ae9c-11eb-0f16-41fdc4acb403
# ╟─bf5f2330-ae97-11eb-18ac-496f1633589a
# ╟─ddf7ee80-ae97-11eb-00eb-b3b487176516
# ╟─ef3c1900-ae97-11eb-28ae-677181f2de74
# ╟─8ef9eece-a8ea-11eb-1d12-e590acb39c50
# ╟─415a7e5d-a3b9-4b98-8819-e9806e0d5f5c
# ╟─047fb990-a833-11eb-3475-e733ba918060
# ╟─3fdcb740-a833-11eb-055c-b524c78d2a24
# ╠═927b19a0-96ff-11eb-280f-21bf567ea2ec
