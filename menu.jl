### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils
using Random

#schrijven van een interactieve menu
function getc1()
    ret = ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, true)
    ret == 0 || error("unable to switch to raw mode")
    c = read(stdin, Char)
    ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, false)
    c
end

function menu()
    println("Press m to go back to the menu!")
    println("Press q to quit!");
    while true
        opt = getc1();
        if opt == 'm'
        	println("")
        	println("")
            run(Cmd(["cmd", "/c", "cls"]))
            include("menu.jl")
        elseif opt =='q'
            run(Cmd(["cmd", "/c", "cls"]))
        	exit()
        elseif opt == 'c'
        	println("")
        	println("")
            run(Cmd(["cmd", "/c", "cls"]))
        	println("$(include("info.TXT"))")
         elseif opt == 'b'
            run(Cmd(["cmd", "/c", "cls"]))
            include("Multy.jl")
        elseif opt == 'a'
            run(Cmd(["cmd", "/c", "cls"]))
        	include("BOT.jl")
        else
            continue
        end
    end
end
run(Cmd(["cmd", "/c", "cls"]))
printstyled("   ▄▄▄▄   ▄  ▄   ▄   ▄  ▄ ▄▄▄ ▄  ▄ ▄     ▄   ▄▄▄ ▄▄▄ ▄▄▄";color=:red)
println()  
printstyled("   █  █   █  █  █▄█  █▀▄█  █  █  █ █▀▄ ▄▀█    █   █   █";color=:red)
println()
printstyled("   ▀▀▀▀▄  █▄▄█ █   █ █  █  █  █▄▄█ █  ▀  █    █   █   █";color=:red)
println()
printstyled("———————————————————————————————————————————————————————————";color=:red)
println("")
hoofd= include("hoofdding.TXT")
println("$hoofd")
menu()

