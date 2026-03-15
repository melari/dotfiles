#!/usr/bin/env fish

set script_dir (dirname (status -f))
set scripts_dir "$script_dir/setup_scripts"

set scripts (for f in $scripts_dir/*.fish; basename $f; end)

set selected 1

function draw_menu
    clear

    set cols (tput cols)

    set title "Arch Dotfiles Util"
    set title_len (string length $title)
    set title_col (math "($cols - $title_len) / 2")

    tput cup 1 $title_col
    echo $title

    set row 4

    for i in (seq (count $scripts))
        tput cup $row 4

        if test $i -eq $selected
            echo "> $scripts[$i]"
        else
            echo "  $scripts[$i]"
        end

        set row (math "$row + 1")
    end
end

function run_script
    clear
    tput cnorm

    fish -c "cd $scripts_dir; ./$scripts[$selected]"

    echo
    echo "Press any key to return..."
    read --silent --nchars 1

    tput civis
end

tput civis

while true
    draw_menu

    read --silent --nchars 1 key

    switch $key

        case q
            tput cnorm
            clear
            exit 0

	case (printf '\x03')  # Ctrl+C
            tput cnorm
            clear
            exit 0

        case j
            if test $selected -lt (count $scripts)
                set selected (math "$selected + 1")
            end

        case k
            if test $selected -gt 1
                set selected (math "$selected - 1")
            end

        case ''
            run_script

        case (printf '\e')
            read --silent --nchars 2 seq

            switch $seq
                case '[A'
                    if test $selected -gt 1
                        set selected (math "$selected - 1")
                    end
                case '[B'
                    if test $selected -lt (count $scripts)
                        set selected (math "$selected + 1")
                    end
            end
    end
end
