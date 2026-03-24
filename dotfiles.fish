#!/usr/bin/env fish

set script_dir (dirname (status -f))

if test (uname) = Darwin
    set os_name OSX
    set scripts_dir "$script_dir/osx/setup_scripts"
else
    set os_name Linux
    set scripts_dir "$script_dir/arch/setup_scripts"
end

set scripts (for f in $scripts_dir/*.fish; basename $f; end)

set selected 1
set checked

function draw_menu
    tput cup 0 0

    set cols (tput cols)

    set title "Dotfiles Util - $os_name"
    set title_len (string length $title)
    set title_col (math --scale 0 "($cols - $title_len) / 2")

    tput cup 1 $title_col
    echo $title

    set kc (set_color yellow)
    set nc (set_color normal)
    set sc (set_color brblack)

    set controls_plain "q: quit  |  j/k: move  |  <enter>: toggle  |  a: select all  |  r: run selected"
    set controls_col (math --scale 0 "($cols - "(string length $controls_plain)") / 2")

    tput cup 3 $controls_col
    printf '%s' $kc q $nc ": quit  " $sc "|" $nc "  " $kc j/k $nc ": move  " $sc "|" $nc "  " $kc "<enter>" $nc ": toggle  " $sc "|" $nc "  " $kc a $nc ": select all  " $sc "|" $nc "  " $kc r $nc ": run selected"

    set row 5

    for i in (seq (count $scripts))
        tput cup $row 4

        if contains $i $checked
            set box "[x]"
        else
            set box "[ ]"
        end

        if test $i -eq $selected
            echo "> $box $scripts[$i]"
        else
            echo "  $box $scripts[$i]"
        end

        set row (math "$row + 1")
    end
end

function run_selected
    clear
    tput cnorm

    for i in $checked
        fish -c "cd $scripts_dir; ./$scripts[$i]"

        if test $status -ne 0
            echo
            printf "Script failed, continue to next script anyway? [y/N] "
            read -P "" --silent --nchars 1 answer
            echo
            if not string match -qi y $answer
                break
            end
        end
    end

    echo
    echo "Press any key to return..."
    read --silent --nchars 1 -P ""

    tput civis
    clear
end

tput civis
clear

while true
    draw_menu

    read --silent --nchars 1 key -P ""
    if test $status -ne 0
        tput cnorm
        clear
        exit 0
    end

    switch $key

        case q
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
            if contains $selected $checked
                set -l idx (contains --index $selected $checked)
                set -e checked[$idx]
            else
                set checked $checked $selected
            end

            if test $selected -lt (count $scripts)
                set selected (math "$selected + 1")
            end

        case a
            set checked (seq (count $scripts))

        case r
            if test (count $checked) -gt 0
                run_selected
                set checked
            end

        case (printf '\e')
            read --silent --nchars 2 seq -P ""

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
